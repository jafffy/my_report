#!/usr/bin/env python3
"""
MIMIC-IV "Run Away" (Against Medical Advice) Analysis
Matching K-MIMIC analysis format
"""

import pandas as pd
import gzip
from collections import Counter

# Paths
MIMIC_PATH = "/Users/jafffy/workspace/datasets/mimic-iv-3.1"

print("=" * 60)
print("MIMIC-IV 'Run Away' (Against Medical Advice) Analysis")
print("=" * 60)

# Load admissions data
print("\nLoading admissions data...")
with gzip.open(f"{MIMIC_PATH}/hosp/admissions.csv.gz", 'rt') as f:
    admissions = pd.read_csv(f)

# Filter for "AGAINST ADVICE" cases
runaway = admissions[admissions['discharge_location'] == 'AGAINST ADVICE'].copy()

print(f"\n{'='*60}")
print("1. 개요 (Overview)")
print(f"{'='*60}")
print(f"총 Run away 케이스: {len(runaway)}건")
print(f"전체 입원 대비 비율: {len(runaway)/len(admissions)*100:.2f}%")
print(f"관련 환자 수: {runaway['subject_id'].nunique()}명")

# Admission types
print(f"\n{'='*60}")
print("2. 입원 유형 (Admission Type)")
print(f"{'='*60}")
admission_type_counts = runaway['admission_type'].value_counts()
total = len(runaway)
for atype, count in admission_type_counts.items():
    pct = count / total * 100
    print(f"{atype}: {count}건 ({pct:.1f}%)")

# Group into categories similar to K-MIMIC
emergency_types = ['EW EMER.', 'URGENT', 'DIRECT EMER.', 'AMBULATORY OBSERVATION', 'EU OBSERVATION']
runaway['admission_category'] = runaway['admission_type'].apply(
    lambda x: 'Emergency' if x in emergency_types else ('Elective' if x == 'ELECTIVE' else 'Other')
)
print("\n[카테고리별 요약]")
for cat, count in runaway['admission_category'].value_counts().items():
    pct = count / total * 100
    print(f"{cat}: {count}건 ({pct:.1f}%)")

# Insurance types
print(f"\n{'='*60}")
print("3. 보험 유형 (Insurance Type)")
print(f"{'='*60}")
insurance_counts = runaway['insurance'].value_counts()
for ins, count in insurance_counts.items():
    pct = count / total * 100
    print(f"{ins}: {count}건 ({pct:.1f}%)")

# Load diagnoses
print(f"\n{'='*60}")
print("4. 진단 분석 (Diagnosis Analysis)")
print(f"{'='*60}")
print("\nLoading diagnoses data...")
with gzip.open(f"{MIMIC_PATH}/hosp/diagnoses_icd.csv.gz", 'rt') as f:
    diagnoses = pd.read_csv(f)

# Load ICD descriptions
with gzip.open(f"{MIMIC_PATH}/hosp/d_icd_diagnoses.csv.gz", 'rt') as f:
    icd_desc = pd.read_csv(f)

# Get diagnoses for runaway patients
runaway_hadm_ids = set(runaway['hadm_id'])
runaway_diagnoses = diagnoses[diagnoses['hadm_id'].isin(runaway_hadm_ids)].copy()

# Get primary diagnoses (seq_num = 1)
primary_dx = runaway_diagnoses[runaway_diagnoses['seq_num'] == 1].copy()

# Extract first letter of ICD code for category
primary_dx['icd_category'] = primary_dx['icd_code'].str[0]

print(f"\n총 Run away 환자 진단 기록: {len(runaway_diagnoses)}건")
print(f"주진단(seq_num=1) 기록: {len(primary_dx)}건")

# ICD category analysis
print(f"\n{'='*60}")
print("4-1. 주진단 대분류 (ICD-10 첫 글자 기준)")
print(f"{'='*60}")

# Separate ICD-9 and ICD-10
icd10_primary = primary_dx[primary_dx['icd_version'] == 10].copy()
icd9_primary = primary_dx[primary_dx['icd_version'] == 9].copy()

print(f"\nICD-10 진단: {len(icd10_primary)}건")
print(f"ICD-9 진단: {len(icd9_primary)}건")

# ICD-10 category mapping
icd10_categories = {
    'A': '감염성 질환', 'B': '감염성 질환',
    'C': '신생물(암)', 'D': '혈액/면역 질환',
    'E': '내분비/대사 질환',
    'F': '정신/행동 장애',
    'G': '신경계 질환',
    'H': '눈/귀 질환',
    'I': '순환기계 질환',
    'J': '호흡기계 질환',
    'K': '소화기계 질환',
    'L': '피부 질환',
    'M': '근골격계 질환',
    'N': '비뇨생식계 질환',
    'O': '임신/출산',
    'P': '주산기 질환',
    'Q': '선천기형',
    'R': '증상/징후',
    'S': '손상(외상)',
    'T': '중독/외인',
    'U': '기타',
    'V': '외인(교통)', 'W': '외인(추락)', 'X': '외인(기타)', 'Y': '외인',
    'Z': '건강상태/서비스'
}

print("\n[ICD-10 주진단 대분류]")
icd10_cat_counts = icd10_primary['icd_category'].value_counts()
for cat, count in icd10_cat_counts.head(15).items():
    pct = count / len(icd10_primary) * 100
    desc = icd10_categories.get(cat, '기타')
    print(f"{cat} ({desc}): {count}건 ({pct:.1f}%)")

# F-code (Psychiatric) analysis
print(f"\n{'='*60}")
print("4-2. 정신과 진단 상세 (F코드)")
print(f"{'='*60}")

# Get all F-code diagnoses for runaway patients
all_runaway_dx = runaway_diagnoses.copy()
f_codes = all_runaway_dx[(all_runaway_dx['icd_version'] == 10) &
                          (all_runaway_dx['icd_code'].str.startswith('F'))].copy()

print(f"\nF코드 진단 총 건수: {len(f_codes)}건")
print(f"F코드 진단 환자 수: {f_codes['hadm_id'].nunique()}명")

# Merge with descriptions
f_codes_with_desc = f_codes.merge(
    icd_desc[icd_desc['icd_version'] == 10][['icd_code', 'long_title']],
    on='icd_code',
    how='left'
)

# Group by ICD code
f_code_counts = f_codes_with_desc.groupby(['icd_code', 'long_title']).size().reset_index(name='count')
f_code_counts = f_code_counts.sort_values('count', ascending=False)

print("\n[상위 15개 F코드 진단]")
for _, row in f_code_counts.head(15).iterrows():
    print(f"{row['icd_code']}: {row['long_title'][:50]}... ({row['count']}건)")

# Alcohol-related F codes
print("\n[알코올 관련 진단 (F10)]")
alcohol_f = f_codes_with_desc[f_codes_with_desc['icd_code'].str.startswith('F10')]
alcohol_counts = alcohol_f.groupby(['icd_code', 'long_title']).size().reset_index(name='count')
alcohol_counts = alcohol_counts.sort_values('count', ascending=False)
for _, row in alcohol_counts.head(10).iterrows():
    print(f"{row['icd_code']}: {row['long_title'][:50]}... ({row['count']}건)")

print(f"\n알코올 관련(F10) 총 건수: {len(alcohol_f)}건")
print(f"알코올 관련(F10) 환자 수: {alcohol_f['hadm_id'].nunique()}명")

# T-code (Poisoning/External) analysis
print(f"\n{'='*60}")
print("4-3. 중독/자해 관련 (T코드)")
print(f"{'='*60}")

t_codes = all_runaway_dx[(all_runaway_dx['icd_version'] == 10) &
                          (all_runaway_dx['icd_code'].str.startswith('T'))].copy()

print(f"\nT코드 진단 총 건수: {len(t_codes)}건")
print(f"T코드 진단 환자 수: {t_codes['hadm_id'].nunique()}명")

t_codes_with_desc = t_codes.merge(
    icd_desc[icd_desc['icd_version'] == 10][['icd_code', 'long_title']],
    on='icd_code',
    how='left'
)

t_code_counts = t_codes_with_desc.groupby(['icd_code', 'long_title']).size().reset_index(name='count')
t_code_counts = t_code_counts.sort_values('count', ascending=False)

print("\n[상위 15개 T코드 진단]")
for _, row in t_code_counts.head(15).iterrows():
    title = row['long_title'] if pd.notna(row['long_title']) else 'Unknown'
    print(f"{row['icd_code']}: {title[:50]}... ({row['count']}건)")

# Self-harm related (T36-T50 poisoning, T71 asphyxiation)
print("\n[자해/중독 의심 진단]")
poisoning_t = t_codes_with_desc[
    (t_codes_with_desc['icd_code'].str.match(r'^T[345]\d')) |  # T30-T59 poisoning
    (t_codes_with_desc['icd_code'].str.startswith('T71'))  # asphyxiation
]
if len(poisoning_t) > 0:
    poison_counts = poisoning_t.groupby(['icd_code', 'long_title']).size().reset_index(name='count')
    poison_counts = poison_counts.sort_values('count', ascending=False)
    for _, row in poison_counts.head(10).iterrows():
        title = row['long_title'] if pd.notna(row['long_title']) else 'Unknown'
        print(f"{row['icd_code']}: {title[:50]}... ({row['count']}건)")

# K-code analysis (including alcoholic liver disease)
print(f"\n{'='*60}")
print("4-4. 소화기계 질환 (K코드) - 알코올성 간질환 포함")
print(f"{'='*60}")

k_codes = all_runaway_dx[(all_runaway_dx['icd_version'] == 10) &
                          (all_runaway_dx['icd_code'].str.startswith('K'))].copy()

print(f"\nK코드 진단 총 건수: {len(k_codes)}건")

k_codes_with_desc = k_codes.merge(
    icd_desc[icd_desc['icd_version'] == 10][['icd_code', 'long_title']],
    on='icd_code',
    how='left'
)

# Alcoholic liver disease (K70)
print("\n[알코올성 간질환 (K70)]")
alc_liver = k_codes_with_desc[k_codes_with_desc['icd_code'].str.startswith('K70')]
alc_liver_counts = alc_liver.groupby(['icd_code', 'long_title']).size().reset_index(name='count')
alc_liver_counts = alc_liver_counts.sort_values('count', ascending=False)
for _, row in alc_liver_counts.iterrows():
    title = row['long_title'] if pd.notna(row['long_title']) else 'Unknown'
    print(f"{row['icd_code']}: {title[:50]}... ({row['count']}건)")

print(f"\n알코올성 간질환(K70) 총 건수: {len(alc_liver)}건")
print(f"알코올성 간질환(K70) 환자 수: {alc_liver['hadm_id'].nunique()}명")

# Summary statistics
print(f"\n{'='*60}")
print("5. 정신건강/알코올 관련 환자 요약")
print(f"{'='*60}")

# Unique patients with mental health or alcohol issues
f_code_patients = set(f_codes['hadm_id'])
alc_liver_patients = set(alc_liver['hadm_id'])
mental_alcohol_patients = f_code_patients | alc_liver_patients

print(f"\nF코드(정신과) 진단 환자: {len(f_code_patients)}명")
print(f"알코올성 간질환(K70) 환자: {len(alc_liver_patients)}명")
print(f"중복 제외 합계: {len(mental_alcohol_patients)}명")
print(f"전체 Run away 환자 대비 비율: {len(mental_alcohol_patients)/len(runaway)*100:.1f}%")

# Alcohol-related summary
alcohol_f_patients = set(alcohol_f['hadm_id'])
all_alcohol_patients = alcohol_f_patients | alc_liver_patients
print(f"\n[알코올 관련 총계]")
print(f"알코올 관련 F10 진단: {len(alcohol_f_patients)}명")
print(f"알코올성 간질환 K70: {len(alc_liver_patients)}명")
print(f"알코올 관련 전체 (중복제외): {len(all_alcohol_patients)}명")
print(f"전체 Run away 환자 대비 비율: {len(all_alcohol_patients)/len(runaway)*100:.1f}%")

# Demographics
print(f"\n{'='*60}")
print("6. 인구통계학적 특성")
print(f"{'='*60}")

# Race
print("\n[인종/민족]")
race_counts = runaway['race'].value_counts()
for race, count in race_counts.head(10).items():
    pct = count / total * 100
    print(f"{race}: {count}건 ({pct:.1f}%)")

# Language
print("\n[언어]")
lang_counts = runaway['language'].value_counts()
for lang, count in lang_counts.head(5).items():
    pct = count / total * 100
    print(f"{lang}: {count}건 ({pct:.1f}%)")

# Marital status
print("\n[결혼 상태]")
marital_counts = runaway['marital_status'].value_counts()
for status, count in marital_counts.items():
    pct = count / total * 100
    print(f"{status}: {count}건 ({pct:.1f}%)")

print(f"\n{'='*60}")
print("분석 완료!")
print(f"{'='*60}")
