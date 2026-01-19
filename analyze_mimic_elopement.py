#!/usr/bin/env python3
"""
MIMIC-IV "Elopement/Run Away" 추정 분석
Z5321 코드 및 기타 proxy indicator 활용
"""

import pandas as pd
import gzip
from datetime import timedelta

# Paths
MIMIC_PATH = "/Users/jafffy/workspace/datasets/mimic-iv-3.1"

print("=" * 60)
print("MIMIC-IV 'Elopement/Run Away' 추정 분석")
print("=" * 60)

# Load data
print("\nLoading data...")
with gzip.open(f"{MIMIC_PATH}/hosp/admissions.csv.gz", 'rt') as f:
    admissions = pd.read_csv(f, parse_dates=['admittime', 'dischtime', 'edregtime', 'edouttime'])

with gzip.open(f"{MIMIC_PATH}/hosp/diagnoses_icd.csv.gz", 'rt') as f:
    diagnoses = pd.read_csv(f)

with gzip.open(f"{MIMIC_PATH}/hosp/d_icd_diagnoses.csv.gz", 'rt') as f:
    icd_desc = pd.read_csv(f)

# ============================================
# 방법 1: Z5321 코드 (환자가 의료진 만나기 전 떠남)
# ============================================
print(f"\n{'='*60}")
print("방법 1: Z5321 코드 분석")
print("(Procedure not carried out due to patient leaving prior to being seen)")
print(f"{'='*60}")

z5321_dx = diagnoses[diagnoses['icd_code'] == 'Z5321']
z5321_hadm_ids = set(z5321_dx['hadm_id'])
z5321_admissions = admissions[admissions['hadm_id'].isin(z5321_hadm_ids)]

print(f"\nZ5321 진단 건수: {len(z5321_dx)}건")
print(f"관련 입원 수: {len(z5321_admissions)}건")

# Characteristics of Z5321 patients
print("\n[Z5321 환자 입원 유형]")
for atype, count in z5321_admissions['admission_type'].value_counts().items():
    pct = count / len(z5321_admissions) * 100
    print(f"  {atype}: {count}건 ({pct:.1f}%)")

print("\n[Z5321 환자 퇴원 위치]")
for loc, count in z5321_admissions['discharge_location'].value_counts().items():
    pct = count / len(z5321_admissions) * 100
    print(f"  {loc}: {count}건 ({pct:.1f}%)")

# ============================================
# 방법 2: AMA 중 초단기 체류 (응급실 < 4시간)
# ============================================
print(f"\n{'='*60}")
print("방법 2: AMA + 초단기 응급실 체류 (< 4시간)")
print(f"{'='*60}")

ama_admissions = admissions[admissions['discharge_location'] == 'AGAINST ADVICE'].copy()

# Calculate ED length of stay
ama_admissions['ed_los_hours'] = (
    (ama_admissions['edouttime'] - ama_admissions['edregtime']).dt.total_seconds() / 3600
)

# Filter for short ED stays (< 4 hours) that came through ED
short_ed_ama = ama_admissions[
    (ama_admissions['ed_los_hours'] < 4) &
    (ama_admissions['edregtime'].notna())
]

print(f"\nAMA 전체: {len(ama_admissions)}건")
print(f"응급실 경유 AMA: {ama_admissions['edregtime'].notna().sum()}건")
print(f"응급실 체류 < 4시간인 AMA: {len(short_ed_ama)}건")

# Very short stays (< 2 hours)
very_short_ed_ama = ama_admissions[
    (ama_admissions['ed_los_hours'] < 2) &
    (ama_admissions['edregtime'].notna())
]
print(f"응급실 체류 < 2시간인 AMA: {len(very_short_ed_ama)}건")

# ============================================
# 방법 3: 정신과 관련 AMA (도망 가능성 높음)
# ============================================
print(f"\n{'='*60}")
print("방법 3: 정신과/약물 관련 AMA 환자 분석")
print(f"{'='*60}")

ama_hadm_ids = set(ama_admissions['hadm_id'])
ama_diagnoses = diagnoses[diagnoses['hadm_id'].isin(ama_hadm_ids)]

# F20 (조현병), F31 (양극성), F60 (인격장애) - 병식 부족 가능성
high_risk_f_codes = ['F20', 'F31', 'F60']
high_risk_dx = ama_diagnoses[
    ama_diagnoses['icd_code'].str[:3].isin(high_risk_f_codes) &
    (ama_diagnoses['icd_version'] == 10)
]

print("\n[고위험 정신과 진단 (F20, F31, F60)]")
high_risk_hadm = set(high_risk_dx['hadm_id'])
print(f"조현병/양극성/인격장애 환자 수: {len(high_risk_hadm)}명")

# Get detailed breakdown
for code_prefix in high_risk_f_codes:
    subset = ama_diagnoses[
        (ama_diagnoses['icd_code'].str.startswith(code_prefix)) &
        (ama_diagnoses['icd_version'] == 10)
    ]
    unique_patients = subset['hadm_id'].nunique()
    print(f"  {code_prefix}: {unique_patients}명")

# ============================================
# 방법 4: 조합 분석 - 가장 '도망' 같은 케이스
# ============================================
print(f"\n{'='*60}")
print("방법 4: 복합 조건 - '도망 추정' 케이스")
print("(AMA + 정신과 진단 + 응급실 경유)")
print(f"{'='*60}")

# AMA with psych diagnosis from ED
f_code_ama = ama_diagnoses[
    (ama_diagnoses['icd_code'].str.startswith('F')) &
    (ama_diagnoses['icd_version'] == 10)
]
f_code_hadm_ids = set(f_code_ama['hadm_id'])

# AMA from ED with psych diagnosis
ed_ama_hadm_ids = set(ama_admissions[ama_admissions['edregtime'].notna()]['hadm_id'])
ed_psych_ama = f_code_hadm_ids & ed_ama_hadm_ids

print(f"\n응급실 경유 + AMA + 정신과 진단: {len(ed_psych_ama)}건")

# Short stay + psych
short_ed_hadm_ids = set(short_ed_ama['hadm_id'])
short_psych_ama = short_ed_hadm_ids & f_code_hadm_ids
print(f"응급실 < 4시간 + AMA + 정신과 진단: {len(short_psych_ama)}건")

# ============================================
# 최종 요약: 도망 추정 케이스
# ============================================
print(f"\n{'='*60}")
print("최종 요약: '도망(Elopement)' 추정 케이스")
print(f"{'='*60}")

# Method 1: Z5321 code
method1 = z5321_hadm_ids

# Method 2: Very short ED stay + AMA
method2 = set(very_short_ed_ama['hadm_id'])

# Method 3: High-risk psych + AMA + ED
method3 = high_risk_hadm & ed_ama_hadm_ids

# Combined (union)
estimated_elopement = method1 | method2 | method3

print(f"\n[개별 방법별 추정]")
print(f"  방법 1 (Z5321 코드): {len(method1)}건")
print(f"  방법 2 (ED < 2시간 + AMA): {len(method2)}건")
print(f"  방법 3 (고위험 정신과 + ED + AMA): {len(method3)}건")
print(f"\n[합계 (중복 제외)]")
print(f"  도망 추정 케이스: {len(estimated_elopement)}건")

# Analyze these estimated elopement cases
estimated_admissions = admissions[admissions['hadm_id'].isin(estimated_elopement)]
estimated_diagnoses = diagnoses[diagnoses['hadm_id'].isin(estimated_elopement)]

print(f"\n{'='*60}")
print("도망 추정 케이스 상세 분석")
print(f"{'='*60}")

print("\n[입원 유형]")
for atype, count in estimated_admissions['admission_type'].value_counts().items():
    pct = count / len(estimated_admissions) * 100
    print(f"  {atype}: {count}건 ({pct:.1f}%)")

print("\n[보험 유형]")
for ins, count in estimated_admissions['insurance'].value_counts().items():
    pct = count / len(estimated_admissions) * 100
    print(f"  {ins}: {count}건 ({pct:.1f}%)")

print("\n[퇴원 위치]")
for loc, count in estimated_admissions['discharge_location'].value_counts().head(5).items():
    pct = count / len(estimated_admissions) * 100
    print(f"  {loc}: {count}건 ({pct:.1f}%)")

# F-code analysis for estimated elopement
print("\n[정신과 진단 (F코드)]")
est_f_codes = estimated_diagnoses[
    (estimated_diagnoses['icd_code'].str.startswith('F')) &
    (estimated_diagnoses['icd_version'] == 10)
]
est_f_merged = est_f_codes.merge(
    icd_desc[icd_desc['icd_version'] == 10][['icd_code', 'long_title']],
    on='icd_code',
    how='left'
)
f_counts = est_f_merged.groupby(['icd_code', 'long_title']).size().reset_index(name='count')
f_counts = f_counts.sort_values('count', ascending=False)
for _, row in f_counts.head(10).iterrows():
    title = row['long_title'][:45] if pd.notna(row['long_title']) else 'Unknown'
    print(f"  {row['icd_code']}: {title}... ({row['count']}건)")

# K-MIMIC vs MIMIC-IV 비교
print(f"\n{'='*60}")
print("K-MIMIC vs MIMIC-IV 비교")
print(f"{'='*60}")
print(f"\n{'항목':<30} {'K-MIMIC':<15} {'MIMIC-IV (추정)':<15}")
print("-" * 60)
print(f"{'Run away/도망 케이스':<30} {'409건':<15} {f'{len(estimated_elopement)}건':<15}")
print(f"{'Against Advice (참고)':<30} {'-':<15} {'3,393건':<15}")

print(f"\n{'='*60}")
print("분석 완료!")
print(f"{'='*60}")
