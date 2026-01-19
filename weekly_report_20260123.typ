// Weekly Report - 2026.01.23
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
            [2026.01.23 #h(1em) #slide-counter.display() / #slide-counter.final().first()]
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
  date: [2026년 1월 23일],
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
        [SNOMED & LOINC], [Prompt Engineering],
        [DEEP-ICU Synthetic Data], [Downstream Task 검증],
        [K-MIMIC 도주 환자], [ITEMID 검색],
        [K-MIMIC 문제점 정리], [리스트 작성],
        [자폐 플랫폼 (김동영)], [논문 writing],
        [Pediatric Skull CT (김동영, MICCAI)], [논문 writing],
        [Medical Video Seg (김동영, MICCAI)], [논문 writing],
      )
    ]
  )
]

// ============================================
// SNOMED CT & LOINC Title
// ============================================
#section-slide(
  title: [SNOMED CT & LOINC Mapping],
  subtitle: [Human-AI Collaborative Approach],
  note: [BERT + LLM Pipeline 성능 개선]
)

// ============================================
// SNOMED CT & LOINC Mapping Results
// ============================================
#slide(title: [SNOMED CT & LOINC Mapping: LLM Pipeline])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *LLM Pipeline 구축*
      - BERT 모델 출력에 LLM 후처리 추가
      - KLUE-BERT + LLM 파이프라인 완성

      #v(0.5em)

      *현재 상황*
      - #text(fill: hold)[⚠] LLM 후처리 성능이 기대 이하
      - Prompt Engineering 진행 중

      #v(0.5em)

      #block(
        fill: luma(230),
        inset: 10pt,
        radius: 4pt,
        width: 100%,
        text(size: 12pt)[
          *문제:* LLM이 BERT Top-5 결과를\
          효과적으로 재순위화하지 못함
        ]
      )
    ],
    [
      *개선 방향*
      - #text(fill: inprogress)[→] Prompt 구조 개선
      - #text(fill: inprogress)[→] Few-shot examples 추가
      - #text(fill: inprogress)[→] Chain-of-thought 적용

      #v(0.5em)

      *시도 중인 접근*
      - 의료 용어 맥락 정보 추가
      - 출력 형식 제약 조건 강화
      - 후보군 설명 정보 제공
    ]
  )
]

// ============================================
// DEEP-ICU Title
// ============================================
#section-slide(
  title: [DEEP-ICU],
  subtitle: [Domain-Embedded Encodings for\ Personalized ICU outcomes],
  note: [Synthetic Data Downstream Task 검증]
)

// ============================================
// DEEP-ICU Local LLM
// ============================================
#slide(title: [DEEP-ICU: Mortality Prediction 검증])[\
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *Pipeline 완성*
      - Local LLM 대규모 생성 파이프라인 구축
      - Synthetic Data 생성 완료

      #v(0.5em)

      *Downstream Task 검증*
      - Mortality Prediction 모델 학습
      - K-MIMIC Synthetic Data 활용

      #v(0.5em)

      #block(
        fill: completed.lighten(70%),
        inset: 10pt,
        radius: 4pt,
        width: 100%,
        text(size: 14pt)[
          *결과:* MIMIC-III Benchmark와\
          유사한 성능 달성
        ]
      )
    ],
    [
      *결과 분석*
      - #text(fill: completed)[✓] Synthetic Data 품질 검증됨
      - #text(fill: completed)[✓] 임상적 패턴 보존 확인
      - #text(fill: completed)[✓] Downstream Task 활용 가능

      #v(0.5em)

      *의의*
      - Local LLM으로 충분한 품질 확보
      - 비용 효율적 대규모 생성 가능
      - 외부 API 의존성 제거
    ]
  )

  #v(0.3em)

  #block(
    fill: primary.lighten(80%),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    text(size: 14pt)[
      *성과:* Local LLM 기반 Synthetic Data가 실제 데이터와 유사한 예측 성능을 보임
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
          - SNOMED CT & LOINC Mapping
            - #text(size: 12pt)[BERT + LLM Pipeline 구축 완료]
            - #text(size: 12pt)[성능 저조 → Prompt Engineering 진행]
          - DEEP-ICU Synthetic Data
            - #text(size: 12pt)[Local LLM Pipeline 완성]
            - #text(size: 12pt)[Mortality Prediction 검증]
            - #text(size: 12pt)[MIMIC-III Benchmark 수준 달성]
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
          - LOINC Mapping 성능 개선
            - #text(size: 12pt)[Prompt Engineering 지속]
            - #text(size: 12pt)[Few-shot / CoT 적용]
          - DEEP-ICU 후속 작업
            - #text(size: 12pt)[추가 Downstream Task 검증]
            - #text(size: 12pt)[논문 작성 준비]
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
