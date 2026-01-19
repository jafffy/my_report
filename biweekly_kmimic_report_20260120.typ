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
        [K-MIMIC 도주 환자], [ITEMID 검색],
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
        fill: completed.lighten(70%),
        inset: 8pt,
        radius: 4pt,
        width: 100%,
        text(size: 12pt)[
          *결과:* 높은 Specificity로 생존자 예측 우수
        ]
      )
    ],
    [
      *Key Observations*
      #set text(size: 14pt)
      - High specificity: 생존자 98.9% 정확 식별
      - Low sensitivity: 사망 예측 32.9%
      - False negatives: 96명 (사망→생존 예측)
      - False positives: 6명 (생존→사망 예측)

      #v(0.5em)

      *진행 현황*
      - #text(fill: completed)[✓] Local LLM Pipeline 완성
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
  subtitle: [ICU 도주 환자 특성 분석],
  note: [ITEMID 기반 데이터 추출]
)

// ============================================
// K-MIMIC 도주 환자 Details
// ============================================
#slide(title: [K-MIMIC 도주 환자: 진행 현황])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *현재 진행 상황*
      - K-MIMIC에서 도주 환자 데이터 추출
      - 관련 ITEMID 검색 중

      #v(0.5em)

      *데이터 추출 목표*
      - 도주 환자 기본 정보
      - 관련 임상 변수 (바이탈, 검사 결과)
      - 도주 전후 이벤트 데이터

      #v(0.5em)

      #block(
        fill: inprogress.lighten(70%),
        inset: 10pt,
        radius: 4pt,
        width: 100%,
        text(size: 14pt)[
          *상태:* ITEMID 매핑 작업 진행 중
        ]
      )
    ],
    [
      *다음 단계*
      - #text(fill: inprogress)[→] ITEMID 목록 확정
      - #text(fill: inprogress)[→] 데이터 추출 쿼리 작성
      - #text(fill: inprogress)[→] 코호트 정의 및 추출

      #v(0.5em)

      *예상 분석*
      - 도주 환자 특성 분석
      - 위험 요인 도출
      - 예방 방안 제시
    ]
  )
]

// ============================================
// K-MIMIC 문제점 정리 Title
// ============================================
#section-slide(
  title: [K-MIMIC 문제점 정리],
  subtitle: [데이터 품질 및 활용 이슈],
  note: [체계적 문제점 리스트 작성]
)

// ============================================
// K-MIMIC 문제점 정리 Details
// ============================================
#slide(title: [K-MIMIC 문제점: 현황 정리])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *진행 목적*
      - K-MIMIC 활용 시 발견된 문제점 정리
      - 향후 데이터 개선 방향 제시
      - 사용자 가이드라인 마련

      #v(0.5em)

      *정리 중인 항목*
      - 데이터 결측 패턴
      - ITEMID 매핑 이슈
      - 시간 기록 불일치
      - 코드 체계 문제점
    ],
    [
      *예상 산출물*
      - #text(fill: inprogress)[→] 문제점 분류 체계
      - #text(fill: inprogress)[→] 우선순위별 이슈 목록
      - #text(fill: inprogress)[→] 해결 방안 제안

      #v(0.5em)

      #block(
        fill: hold.lighten(70%),
        inset: 10pt,
        radius: 4pt,
        width: 100%,
        text(size: 14pt)[
          *목표:* K-MIMIC 활용도 향상을 위한\
          체계적 문제점 문서화
        ]
      )
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
      - 관련 임상 변수
      - 치료 및 예후 데이터
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
            - #text(size: 12pt)[High Specificity (98.9%)]
          - K-MIMIC 도주 환자
            - #text(size: 12pt)[ITEMID 검색 진행 중]
          - K-MIMIC 문제점 정리
            - #text(size: 12pt)[리스트 작성 중]
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
          - K-MIMIC 도주 환자
            - #text(size: 12pt)[ITEMID 확정 및 데이터 추출]
          - K-MIMIC 문제점 정리
            - #text(size: 12pt)[문제점 리스트 완성]
            - #text(size: 12pt)[해결 방안 제안]
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
