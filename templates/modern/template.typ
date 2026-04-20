// Modern two-column resume template.
// Sidebar holds contact info and skills; main column holds experience and education.
// Reads JSON Resume data passed via `--input resume=<path>`.

#let resume = json(sys.inputs.resume)
#let basics = resume.at("basics", default: (:))

#set page(
  paper: "a4",
  margin: (x: 1.5cm, y: 1.5cm),
)
#set text(font: "Inter", size: 10pt)
#set par(leading: 0.6em)

#let accent = rgb("#2b6cb0")

#let sidebar_heading(t) = [
  #v(0.4em)
  #text(size: 10pt, weight: "bold", fill: accent, upper(t))
  #v(-0.3em)
  #line(length: 100%, stroke: 0.4pt + accent)
]

#let main_heading(t) = [
  #v(0.5em)
  #text(size: 12pt, weight: "bold", fill: accent, upper(t))
  #line(length: 100%, stroke: 0.6pt + accent)
  #v(-0.2em)
]

#let daterange(start, end) = {
  let e = if end == none or end == "" { "Present" } else { end }
  [#start -- #e]
}

// Header spans full width
#block[
  #text(size: 22pt, weight: "bold", basics.at("name", default: ""))
  #if basics.at("label", default: "") != "" [
    \
    #text(size: 12pt, fill: accent, basics.label)
  ]
]

#v(0.4em)

// Two-column body
#grid(
  columns: (33%, 1fr),
  column-gutter: 1.2em,
  // Sidebar
  [
    #sidebar_heading("Contact")
    #if basics.at("email", default: "") != "" [#basics.email \ ]
    #if basics.at("phone", default: "") != "" [#basics.phone \ ]
    #if basics.at("url", default: "") != "" [#link(basics.url) \ ]
    #if basics.at("location", default: none) != none [
      #let loc = basics.location
      #loc.at("city", default: "")#if loc.at("region", default: "") != "" [, #loc.region] \
    ]

    #let skills = resume.at("skills", default: ())
    #if skills.len() > 0 [
      #sidebar_heading("Skills")
      #for s in skills [
        *#s.at("name", default: "")* \
        #text(size: 9pt, s.at("keywords", default: ()).join(", ")) \
        #v(0.2em)
      ]
    ]

    #let langs = resume.at("languages", default: ())
    #if langs.len() > 0 [
      #sidebar_heading("Languages")
      #for l in langs [
        *#l.at("language", default: "")* -- #l.at("fluency", default: "") \
      ]
    ]
  ],
  // Main column
  [
    #if basics.at("summary", default: "") != "" [
      #main_heading("Profile")
      #basics.summary
    ]

    #let work = resume.at("work", default: ())
    #if work.len() > 0 [
      #main_heading("Experience")
      #for job in work [
        *#job.at("position", default: "")* #h(1fr) #text(size: 9pt, daterange(job.at("startDate", default: ""), job.at("endDate", default: none))) \
        #text(fill: accent, job.at("name", default: "")) \
        #if job.at("summary", default: "") != "" [#emph(job.summary) \ ]
        #for h in job.at("highlights", default: ()) [
          - #h
        ]
        #v(0.3em)
      ]
    ]

    #let edu = resume.at("education", default: ())
    #if edu.len() > 0 [
      #main_heading("Education")
      #for e in edu [
        *#e.at("institution", default: "")* #h(1fr) #text(size: 9pt, daterange(e.at("startDate", default: ""), e.at("endDate", default: none))) \
        #e.at("studyType", default: ""), #e.at("area", default: "") \
        #v(0.2em)
      ]
    ]

    #let projects = resume.at("projects", default: ())
    #if projects.len() > 0 [
      #main_heading("Projects")
      #for p in projects [
        *#p.at("name", default: "")* #h(1fr) #text(size: 9pt, daterange(p.at("startDate", default: ""), p.at("endDate", default: none))) \
        #if p.at("description", default: "") != "" [#p.description \ ]
        #for h in p.at("highlights", default: ()) [
          - #h
        ]
        #v(0.3em)
      ]
    ]
  ],
)
