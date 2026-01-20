// Biweekly K-MIMIC Report - 2026.01.20
// Typst Presentation (Native)

#set page(
  paper: "presentation-16-9",
  margin: (x: 1cm, top: 0.5cm, bottom: 1cm),
)
#set text(font: ("Noto Sans CJK KR", "Noto Sans KR", "Apple SD Gothic Neo", "Noto Sans"), size: 20pt)

// Colors
#let completed = rgb(34, 139, 34)
#let inprogress = rgb(70, 130, 180)
#let hold = rgb(255, 140, 0)
#let highlight = rgb(128, 0, 128)

// Theme colors (Madrid-like)
#let primary = rgb(0, 51, 102)
#let secondary = rgb(51, 51, 178)

// Slide counter
#let slide-counter = counter("slide")

// Title slide template
#let title-slide(title: [], author: [], date: [], institute: []) = {
  slide-counter.step()
  page(margin: 0pt)[
    #set align(center + horizon)
    #block(
      fill: primary,
      width: 100%,
      inset: 30pt,
      text(size: 36pt, weight: "bold", fill: white)[#title]
    )
    #v(2em)
    #text(size: 20pt)[#author]
    #v(0.5em)
    #text(size: 16pt, fill: gray)[#institute]
    #v(0.5em)
    #text(size: 16pt)[#date]
  ]
}

// Section slide template
#let section-slide(title: [], subtitle: none, note: none) = {
  slide-counter.step()
  page(margin: 0pt)[
    #set align(center + horizon)
    #text(size: 44pt, weight: "bold")[#title]
    #if subtitle != none {
      v(0.8em)
      text(size: 22pt)[#subtitle]
    }
    #if note != none {
      v(1em)
      text(size: 16pt, fill: gray)[#note]
    }
  ]
}

// Regular slide template
#let slide(title: [], body) = {
  slide-counter.step()
  page(
    margin: (x: 1cm, top: 60pt, bottom: 50pt),
    header: place(top, dx: -1cm, dy: 0pt,
      block(
        fill: primary,
        width: 100% + 2cm,
        inset: 12pt,
        text(size: 24pt, weight: "bold", fill: white)[#title]
      )
    ),
    footer: place(bottom, dx: -1cm, dy: 0pt,
      block(
        fill: primary,
        width: 100% + 2cm,
        inset: 8pt,
        context {
          set text(size: 10pt, fill: white)
          grid(
            columns: (1fr, 1fr, 1fr),
            align: (left, center, right),
            [최재원],
            [K-MIMIC 격주 보고],
            [2026.01.20 #h(1em) #slide-counter.display() / #slide-counter.final().first()]
          )
        }
      )
    )
  )[
    #body
  ]
}

// ============================================
// Title Slide
// ============================================
#title-slide(
  title: [K-MIMIC 격주 보고],
  author: [최재원],
  date: [2026년 1월 20일],
  institute: [서울대학교병원 융합의학과]
)

// ============================================
// Overview Slide
// ============================================
#slide(title: [K-MIMIC 프로젝트 Overview])[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      #text(weight: "bold", fill: completed)[완료 (Completed)]
      #v(0.3em)
      #set text(size: 16pt)
      #table(
        columns: (auto, auto),
        stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
        inset: 6pt,
        table.header(
          [*프로젝트*], [*상태*],
        ),
        [ARDS 연구 (김성민 교수님)], [데이터 전달 완료],
      )
    ],
    [
      #text(weight: "bold", fill: inprogress)[진행 중 (In Progress)]
      #v(0.3em)
      #set text(size: 16pt)
      #table(
        columns: (auto, auto),
        stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
        inset: 6pt,
        table.header(
          [*프로젝트*], [*상태*],
        ),
        [DEEP-ICU Synthetic Data], [Downstream Task 검증],
        [FastText Embeddings], [Temporal 확장 검증],
        [K-MIMIC 도주 환자], [코호트 구축 완료],
        [K-MIMIC 문제점 정리], [리스트 작성],
      )
    ]
  )
]

// ============================================
// DEEP-ICU Title
// ============================================
#section-slide(
  title: [DEEP-ICU],
  subtitle: [Domain-Embedded Encodings for\ Personalized ICU outcomes],
  note: [K-MIMIC Synthetic Data 활용]
)

// ============================================
// DEEP-ICU Pipeline
// ============================================
#slide(title: [DEEP-ICU: Synthetic Data 생성 파이프라인])[\
  #v(0.3em)
  #align(center)[
    #block(
      fill: luma(245),
      inset: 15pt,
      radius: 6pt,
      width: 95%,
      [
        #grid(
          columns: (1fr, auto, 1fr, auto, 1fr),
          gutter: 8pt,
          align: center + horizon,
          [
            #block(fill: primary.lighten(70%), inset: 10pt, radius: 4pt, width: 100%)[
              #text(size: 14pt, weight: "bold")[Step 1: ICD 코드 생성]
              #v(0.3em)
              #text(size: 12pt)[
                *Halo 모델* 활용\
                K-MIMIC 원래 분포 기반\
                ICD 코드 생성
              ]
            ]
          ],
          [#text(size: 24pt)[→]],
          [
            #block(fill: secondary.lighten(70%), inset: 10pt, radius: 4pt, width: 100%)[
              #text(size: 14pt, weight: "bold")[Step 2: Clinical Events]
              #v(0.3em)
              #text(size: 12pt)[
                *Local LLM* 활용\
                Chart Events 생성\
                Lab Events 생성
              ]
            ]
          ],
          [#text(size: 24pt)[→]],
          [
            #block(fill: completed.lighten(70%), inset: 10pt, radius: 4pt, width: 100%)[
              #text(size: 14pt, weight: "bold")[Step 3: 검증]
              #v(0.3em)
              #text(size: 12pt)[
                MIMIC-III 학습 모델로\
                Mortality Prediction\
                *유사 성능 달성*
              ]
            ]
          ],
        )
      ]
    )
  ]

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *Halo 모델 (ICD 코드 생성)*
      #set text(size: 14pt)
      - K-MIMIC 진단 코드 분포 학습
      - 환자별 현실적 ICD 코드 조합 생성
      - 원본 데이터 분포 유지
    ],
    [
      *Local LLM (Clinical Events 생성)*
      #set text(size: 14pt)
      - ICD 코드 기반 Chart Events 생성
      - Lab Events (검사 결과) 생성
      - Mortality Prediction 입력 형식 준수
    ]
  )
]

// ============================================
// FastText Embeddings Pipeline
// ============================================
#slide(title: [FastText Embeddings: 파이프라인])[\
  #v(0.3em)
  #align(center)[
    #block(
      fill: luma(245),
      inset: 15pt,
      radius: 6pt,
      width: 95%,
      [
        #grid(
          columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr),
          gutter: 6pt,
          align: center + horizon,
          [
            #block(fill: primary.lighten(70%), inset: 8pt, radius: 4pt, width: 100%)[
              #text(size: 12pt, weight: "bold")[Clinical Events]
              #v(0.2em)
              #text(size: 10pt)[
                17 Vital Signs\
                36 Lab Tests
              ]
            ]
          ],
          [#text(size: 20pt)[→]],
          [
            #block(fill: secondary.lighten(70%), inset: 8pt, radius: 4pt, width: 100%)[
              #text(size: 12pt, weight: "bold")[Tokenization]
              #v(0.2em)
              #text(size: 10pt)[
                측정값 이산화\
                이벤트 시퀀스 생성
              ]
            ]
          ],
          [#text(size: 20pt)[→]],
          [
            #block(fill: hold.lighten(70%), inset: 8pt, radius: 4pt, width: 100%)[
              #text(size: 12pt, weight: "bold")[FastText]
              #v(0.2em)
              #text(size: 10pt)[
                Skipgram 학습\
                128차원 임베딩
              ]
            ]
          ],
          [#text(size: 20pt)[→]],
          [
            #block(fill: completed.lighten(70%), inset: 8pt, radius: 4pt, width: 100%)[
              #text(size: 12pt, weight: "bold")[Evaluation]
              #v(0.2em)
              #text(size: 10pt)[
                Mortality Pred.\
                XGBoost 분류
              ]
            ]
          ],
        )
      ]
    )
  ]

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *데이터 특성*
      #set text(size: 14pt)
      - ICU 입실 후 첫 48시간 데이터
      - 17개 Vital Signs (HR, BP, SpO2 등)
      - 36개 Lab Tests (CBC, BMP 등)
      - MIMIC-IV 85,243 ICU stays
    ],
    [
      *임베딩 방법*
      #set text(size: 14pt)
      - FastText Skipgram 모델
      - 128차원 환자 임베딩 생성
      - 이벤트 임베딩 평균 → 환자 벡터
      - Mortality 예측 downstream task
    ]
  )
]

// ============================================
// FastText Results
// ============================================
#slide(title: [FastText Embeddings: 결과])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *Mortality Prediction 결과*
      #set text(size: 14pt)
      #table(
        columns: (auto, auto),
        stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
        inset: 5pt,
        table.header([*Metric*], [*Value*]),
        [Dataset], [85,243 ICU stays],
        [Mortality Rate], [11.12%],
        [Accuracy], [82.3%],
        [AUC-ROC], [*0.8954*],
        [F1-score], [0.5019],
      )

      #v(0.3em)

      #block(
        fill: completed.lighten(70%),
        inset: 8pt,
        radius: 4pt,
        width: 100%,
        text(size: 12pt)[
          *AUC-ROC 0.8954*: 임베딩이 mortality 예측에 유의미한 신호 포착
        ]
      )
    ],
    [
      #set text(size: 14pt)
      #text(size: 20pt, weight: "bold")[Key Findings]
      - 첫 48시간 데이터만으로 높은 예측력
      - AUC-ROC 0.8954 달성
      - F1 0.50은 클래스 불균형 영향
      - Synthetic Data 대비 우수한 성능

      #v(0.5em)

      #text(size: 20pt, weight: "bold")[진행 현황]
      - #text(fill: completed)[✓] MIMIC-IV 코호트 구축
      - #text(fill: completed)[✓] FastText 임베딩 학습
      - #text(fill: completed)[✓] Mortality Prediction 검증
      - #text(fill: inprogress)[→] Temporal 확장 평가 예정
    ]
  )
]

// ============================================
// FastText Temporal Extension
// ============================================
#slide(title: [FastText Temporal: 시간 정보 확장])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *Temporal Encoding 방식*
      #set text(size: 14pt)
      #table(
        columns: (auto, auto),
        stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
        inset: 5pt,
        table.header([*Mode*], [*설명*]),
        [bucket], [시간을 구간으로 이산화],
        [marker], [시간 마커 토큰 삽입],
        [relative], [상대적 시간 간격 인코딩],
        [combined], [bucket + marker 결합],
        [none], [시간 정보 없음 (baseline)],
      )

      #v(0.3em)

      #block(
        fill: inprogress.lighten(70%),
        inset: 8pt,
        radius: 4pt,
        width: 100%,
        text(size: 12pt)[
          *목표:* "언제" 이벤트가 발생했는지 정보 활용
        ]
      )
    ],
    [
      #set text(size: 14pt)
      #text(size: 20pt, weight: "bold")[기대 효과]
      - 이벤트 발생 시점 정보 반영
      - 시간에 따른 패턴 변화 포착
      - 임상적으로 중요한 temporal dynamics

      #v(0.5em)

      #text(size: 20pt, weight: "bold")[현재 상태]
      - #text(fill: completed)[✓] Temporal 코호트 생성 완료
      - #text(fill: completed)[✓] 5가지 encoding 모드 구현
      - #text(fill: inprogress)[→] 평가 진행 중
      - #text(fill: inprogress)[→] 성능 비교 분석 예정

      #v(0.3em)

      #block(
        fill: luma(240),
        inset: 6pt,
        radius: 4pt,
        width: 100%,
        text(size: 11pt)[
          *검증 계획:* 각 temporal mode별 AUC-ROC 비교
        ]
      )
    ]
  )
]

// ============================================
// DEEP-ICU Details
// ============================================
#slide(title: [DEEP-ICU: Synthetic Data 검증])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *Mortality Prediction 결과*
      #set text(size: 14pt)
      #table(
        columns: (auto, auto),
        stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
        inset: 5pt,
        table.header([*Metric*], [*Value*]),
        [평가 환자 수], [677/991 (31% 데이터 이슈)],
        [Accuracy], [84.9%],
        [Precision (death)], [88.7%],
        [Recall (death)], [32.9%],
        [Specificity], [98.9% (528/534)],
      )

      #v(0.3em)

      #block(
        fill: hold.lighten(70%),
        inset: 8pt,
        radius: 4pt,
        width: 100%,
        text(size: 12pt)[
          *한계:* 클래스 불균형 (생존 79%)으로 해석 주의 필요
        ]
      )
    ],
    [
      #set text(size: 14pt)
      #text(size: 20pt, weight: "bold")[Key Observations]
      - Baseline (모두 생존 예측): 78.9% Acc
      - 현재 모델: +6%p 향상 (84.9%)
      - 사망 예측 recall 32.9%로 낮음
      - 추가 지표 (AUROC, F1) 필요

      #v(0.5em)

      #text(size: 20pt, weight: "bold")[진행 현황]
      - #text(fill: completed)[✓] Halo 모델 ICD 생성 완료
      - #text(fill: completed)[✓] Local LLM Pipeline 완성
      - #text(fill: completed)[✓] Synthetic Data 생성 완료
      - #text(fill: completed)[✓] Mortality Prediction 검증
      - #text(fill: inprogress)[→] 추가 Downstream Task 검증 예정
    ]
  )
]

// ============================================
// K-MIMIC 도주 환자 Title
// ============================================
#section-slide(
  title: [K-MIMIC 도주 환자 연구],
  subtitle: [ICU 도주 환자 특성 및 위험 요인 분석],
  note: [전체 병원 도주 환자 코호트 구축 완료]
)

// ============================================
// K-MIMIC 도주 환자 진행 현황
// ============================================
#slide(title: [K-MIMIC 도주 환자: 진행 현황])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *완료 사항*
      - #text(fill: completed)[✓] 전체 병원 도주 환자 필터링 완료
      - #text(fill: completed)[✓] 도주 환자 코호트 구축

      #v(0.5em)

      #block(
        fill: completed.lighten(70%),
        inset: 10pt,
        radius: 4pt,
        width: 100%,
        text(size: 14pt)[
          *상태:* 코호트 필터링 완료\
          다음 단계 진행 준비
        ]
      )
    ],
    [
      *다음 단계*
      - #text(fill: inprogress)[→] 코호트 기술통계 산출
      - #text(fill: inprogress)[→] 임상 변수 ITEMID 매핑
      - #text(fill: inprogress)[→] 대조군 설정 및 매칭

      #v(0.5em)

      *연구 목표*
      - 도주 환자 특성 분석
      - 위험 요인 도출
      - 예방 방안 제시
    ]
  )
]

// ============================================
// K-MIMIC 도주 환자 연구 계획
// ============================================
#slide(title: [K-MIMIC 도주 환자: 연구 계획])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      #set text(size: 14pt)
      #text(size: 20pt, weight: "bold")[1. 코호트 정의 및 기술통계]
      - 도주 정의 기준 명확화
      - 전체 환자 수, 병원별 분포
      - 인구통계 (나이, 성별, 입원 경로)

      #v(0.3em)

      #text(size: 20pt, weight: "bold")[2. 임상 변수 추출]
      - 바이탈: HR, BP, BT, RR, SpO2
      - 의식 상태: GCS, 진정제 사용
      - Lab: 전해질, 간/신기능
      - 중증도: SOFA
      - 투약: 진정제, 진통제
    ],
    [
      #set text(size: 14pt)
      #text(size: 20pt, weight: "bold")[3. 시간 관련 변수]
      - ICU 재원 기간 (도주 시점까지)
      - 도주 발생 시간대 (주/야간)
      - 입원 후 도주까지 경과 시간

      #v(0.3em)

      #text(size: 20pt, weight: "bold")[4. 대조군 설정]
      - 비도주 환자 중 매칭 대조군 선정
      - 매칭 기준: 나이, 성별, 중증도, 진단

      #v(0.3em)

      #text(size: 20pt, weight: "bold")[5. 분석 계획]
      - Univariate 특성 비교
      - Logistic regression (위험 요인)
      - 도주 후 예후 분석
    ]
  )
]

// ============================================
// ARDS 연구 Title
// ============================================
#section-slide(
  title: [ARDS 연구],
  subtitle: [김성민 교수님 공동 연구],
  note: [K-MIMIC 데이터 활용]
)

// ============================================
// ARDS 연구 Details
// ============================================
#slide(title: [ARDS 연구: 완료 현황])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *완료 사항*
      - #text(fill: completed)[✓] K-MIMIC ARDS 데이터 추출
      - #text(fill: completed)[✓] 데이터 전처리 완료
      - #text(fill: completed)[✓] 김성민 교수님께 데이터 전달

      #v(0.5em)

      *데이터 범위*
      - ARDS 환자 코호트
    ],
    [
      *후속 계획*
      - 교수님 피드백 대기
      - 추가 데이터 요청 시 대응 예정

      #v(0.5em)

      #block(
        fill: completed.lighten(70%),
        inset: 10pt,
        radius: 4pt,
        width: 100%,
        text(size: 14pt)[
          *상태:* 데이터 전달 완료\
          (2026.01 기준)
        ]
      )
    ]
  )
]

// ============================================
// Summary
// ============================================
#slide(title: [Summary & Next Steps])[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      #block(
        fill: luma(240),
        inset: 12pt,
        radius: 4pt,
        width: 100%,
        [
          *지난 2주 진행 사항*
          #set text(size: 14pt)
          - DEEP-ICU Synthetic Data
            - #text(size: 12pt)[Mortality Prediction: 84.9% Acc]
            - #text(size: 12pt)[Baseline 대비 +6%p, 추가 검증 필요]
          - FastText Embeddings
            - #text(size: 12pt)[AUC-ROC 0.8954 달성]
            - #text(size: 12pt)[Temporal 확장 코호트 구축 완료]
          - K-MIMIC 도주 환자
            - #text(size: 12pt)[전체 병원 코호트 필터링 완료]
          - ARDS 연구
            - #text(size: 12pt)[데이터 전달 완료]
        ]
      )
    ],
    [
      #block(
        fill: luma(240),
        inset: 12pt,
        radius: 4pt,
        width: 100%,
        [
          *다음 2주 계획*
          #set text(size: 14pt)
          - DEEP-ICU 후속 작업
            - #text(size: 12pt)[추가 Downstream Task 검증]
            - #text(size: 12pt)[논문 작성 준비]
          - FastText Temporal 평가
            - #text(size: 12pt)[5가지 temporal mode 성능 비교]
            - #text(size: 12pt)[시간 정보 효과 검증]
          - K-MIMIC 도주 환자
            - #text(size: 12pt)[기술통계 산출 및 임상 변수 추출]
            - #text(size: 12pt)[대조군 설정 및 분석 시작]
        ]
      )
    ]
  )
]

// ============================================
// Q&A
// ============================================
#slide-counter.step()
#page(margin: 0pt)[
  #set align(center + horizon)
  #text(size: 48pt, weight: "bold")[Q & A]
  #v(2em)
  #text(size: 28pt)[감사합니다]
]
