// Weekly Report - 2026.01.09
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
            [주간 업무 보고],
            [2026.01.09 #h(1em) #slide-counter.display() / #slide-counter.final().first()]
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
  title: [주간 업무 보고],
  author: [최재원],
  date: [2026년 1월 9일],
  institute: [서울대학교병원 융합의학과]
)

// ============================================
// Overview Slide
// ============================================
#slide(title: [업무 현황 Overview])[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      #text(weight: "bold", fill: completed)[완료 (Completed)]
      #v(0.3em)
      #set text(size: 14pt)
      #table(
        columns: (auto, auto),
        stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
        inset: 6pt,
        table.header(
          [*프로젝트*], [*상태*],
        ),
        [SNOMED CT 간호 용어 분류], [논문 초안 전달],
        [사망 데이터 활용 연구], [데이터 추출],
        [뇌조직 생검술 뇌출혈 예측], [논문 초안 전달],
        [ARDS 연구 (김성민 교수님)], [데이터 전달],
      )
    ],
    [
      #text(weight: "bold", fill: inprogress)[진행 중 (In Progress)]
      #v(0.3em)
      #set text(size: 14pt)
      #table(
        columns: (auto, auto),
        stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
        inset: 6pt,
        table.header(
          [*프로젝트*], [*상태*],
        ),
        [의료 프로그램 자동화], [개발 중],
        [SNOMED & LOINC], [Validation],
        [DEEP-ICU Synthetic Data], [Local LLM 테스트],
        [K-MIMIC 도주 환자], [ITEMID 검색],
        [K-MIMIC 문제점 정리], [리스트 작성],
        [자폐 플랫폼 (김동영)], [논문 writing],
      )
    ]
  )
]

// ============================================
// 의료 프로그램 자동화 Title
// ============================================
#section-slide(
  title: [의료 프로그램 업무 자동화],
  subtitle: [사구체 최적 Zoom 결정을 위한\ RL Agent 개발],
  note: [Reinforcement Learning 기반 접근]
)

// ============================================
// RL Agent 개발
// ============================================
#slide(title: [RL Agent: 사구체 최적 Zoom 결정])[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *문제 정의*
      - 병리 이미지에서 사구체 관찰 시 최적의 zoom level 자동 결정
      - 수동 조작의 반복적 작업 자동화
      - 일관된 관찰 품질 확보

      #v(0.5em)

      *RL 접근 방식*
      - State: 현재 이미지 상태
      - Action: Zoom in/out/maintain
      - Reward: 사구체 가시성 품질
    ],
    [
      *현재 진행 상황*
      - #text(fill: inprogress)[→] RL Agent 아키텍처 설계 중
      - #text(fill: inprogress)[→] 학습 환경 구축 중

      #v(0.5em)

      *기대 효과*
      - 업무 효율성 향상
      - 관찰 품질 표준화
      - 반복 작업 시간 절감
    ]
  )
]

// ============================================
// SNOMED CT & LOINC Title
// ============================================
#section-slide(
  title: [SNOMED CT & LOINC Mapping],
  subtitle: [Human-AI Collaborative Approach],
  note: [KLUE-BERT 기반 LOINC Mapping 모델]
)

// ============================================
// SNOMED CT & LOINC Mapping Results
// ============================================
#slide(title: [SNOMED CT & LOINC Mapping: Validation 결과])[
  #grid(
    columns: (1.1fr, 0.9fr),
    gutter: 20pt,
    [
      #align(center)[
        *모델 성능 비교 (KLUE-BERT)*
        #v(0.3em)
        #set text(size: 14pt)
        #table(
          columns: (auto, auto, auto),
          stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
          inset: 6pt,
          table.header(
            [], [*SNOMED CT*], [*LOINC*],
          ),
          [Classes], [2,079], [391],
          [Test Samples], [6,793], [539],
          [*Top-1 Acc*], [75.40%], [65.0%],
          [*Top-5 Acc*], [81.54%], [79.3%],
        )
      ]

      #v(0.3em)

      #block(
        fill: luma(230),
        inset: 10pt,
        radius: 4pt,
        width: 100%,
        text(size: 12pt)[
          *SNOMED CT가 더 높은 이유:*\
          간호사 선생님들 의견 -- 문장에 정보량이\
          더 많아서 맞추기 쉬웠을 것
        ]
      )
    ],
    [
      *결과 분석*
      #set text(size: 16pt)
      - SNOMED CT: 75%도 실용성 부족
      - LOINC: Top-1 65%는 더 낮음
      - 단독 BERT 모델의 한계

      #v(0.5em)

      *향후 개선 방향*
      #set text(size: 16pt)
      - LLM 후처리 추가 (ACE approach 적용)
    ]
  )
]

// ============================================
// DEEP-ICU Title
// ============================================
#section-slide(
  title: [DEEP-ICU],
  subtitle: [Domain-Embedded Encodings for\ Personalized ICU outcomes],
  note: [K-MIMIC Synthetic Data Generation]
)

// ============================================
// DEEP-ICU Local LLM
// ============================================
#slide(title: [DEEP-ICU: Local LLM 생성 테스트])[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *변경 사항*
      - 기존: Claude Sonnet 4.5 (API)
      - 현재: Local LLM 테스트

      #v(0.5em)

      *Local LLM*
      - 비용 절감 (API 비용 없음)
      - 데이터 외부 전송 없음
      - 대규모 생성 시 경제적
    ],
    [
      *현재 진행 상황*
      - #text(fill: inprogress)[→] Local LLM 환경 구축
      - #text(fill: inprogress)[→] 생성 품질 테스트 중
      - #text(fill: inprogress)[→] Claude 대비 품질 비교

      #v(0.5em)

      *확인 필요 사항*
      - 생성 품질 비교
      - 생성 속도 측정
      - 임상적 타당성 검증
    ]
  )

  #v(0.3em)

  #block(
    fill: primary.lighten(80%),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    text(size: 14pt)[
      *목표:* Local LLM으로 동등한 품질의 Synthetic Data 생성 가능 여부 검증
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
          *이번 주 진행 사항*
          #set text(size: 14pt)
          - 의료 프로그램 자동화
            - #text(size: 12pt)[사구체 최적 zoom RL agent 개발 착수]
          - SNOMED CT & LOINC Mapping
            - #text(size: 12pt)[SNOMED: Top-1 75.4%, Top-5 81.5%]
            - #text(size: 12pt)[LOINC: Top-1 65.0%, Top-5 79.3%]
          - DEEP-ICU
            - #text(size: 12pt)[Local LLM 생성 테스트 진행]
          - K-MIMIC 도주 환자 분석
            - #text(size: 12pt)[도주 관련 ITEMID mapping 검색]
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
          *다음 주 계획*
          #set text(size: 14pt)
          - RL Agent 개발 지속
            - #text(size: 12pt)[학습 환경 완성]
            - #text(size: 12pt)[초기 학습 실험]
          - LOINC Mapping 개선
            - #text(size: 12pt)[LLM 후처리로 정확도 향상 시도]
            - #text(size: 12pt)[BERT + LLM 파이프라인 구축]
          - DEEP-ICU Local LLM
            - #text(size: 12pt)[품질 비교 완료]
            - #text(size: 12pt)[대규모 생성 파이프라인]
          - K-MIMIC 문제점 정리
            - #text(size: 12pt)[APACHE score, 기호 문제]
            - #text(size: 12pt)[임상관찰/간호기록 모호함]
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
