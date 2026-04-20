// Classic single-column resume template.
// Reads JSON Resume data passed via `--input resume=<path>`.

#let resume = json(sys.inputs.resume)
#let basics = resume.at("basics", default: (:))

#set page(
  paper: "a4",
  margin: (x: 1.8cm, y: 1.8cm),
)
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true, leading: 0.6em)

#let section(title) = [
  #v(0.6em)
  #text(size: 11pt, weight: "bold", upper(title))
  #line(length: 100%, stroke: 0.5pt)
  #v(-0.2em)
]

#let daterange(start, end) = {
  let e = if end == none or end == "" { "Present" } else { end }
  [#start -- #e]
}

// Header
#align(center)[
  #text(size: 20pt, weight: "bold", basics.at("name", default: ""))
  #if basics.at("label", default: "") != "" [
    \
    #text(size: 11pt, basics.label)
  ]
  \
  #text(size: 9.5pt)[
    #basics.at("email", default: "")
    #if basics.at("phone", default: "") != "" [ · #basics.phone ]
    #if basics.at("url", default: "") != "" [ · #link(basics.url) ]
    #if basics.at("location", default: none) != none [
      #let loc = basics.location
      · #loc.at("city", default: "")#if loc.at("region", default: "") != "" [, #loc.region]
    ]
  ]
]

// Summary
#if basics.at("summary", default: "") != "" [
  #section("Summary")
  #basics.summary
]

// Work
#let work = resume.at("work", default: ())
#if work.len() > 0 [
  #section("Experience")
  #for job in work [
    *#job.at("position", default: "")* -- #job.at("name", default: "") #h(1fr) #daterange(job.at("startDate", default: ""), job.at("endDate", default: none)) \
    #if job.at("summary", default: "") != "" [#emph(job.summary) \ ]
    #for h in job.at("highlights", default: ()) [
      - #h
    ]
    #v(0.3em)
  ]
]

// Education
#let edu = resume.at("education", default: ())
#if edu.len() > 0 [
  #section("Education")
  #for e in edu [
    *#e.at("institution", default: "")* #h(1fr) #daterange(e.at("startDate", default: ""), e.at("endDate", default: none)) \
    #e.at("studyType", default: ""), #e.at("area", default: "")
    #v(0.3em)
  ]
]

// Skills
#let skills = resume.at("skills", default: ())
#if skills.len() > 0 [
  #section("Skills")
  #for s in skills [
    *#s.at("name", default: "")*: #s.at("keywords", default: ()).join(", ") \
  ]
]

// Projects
#let projects = resume.at("projects", default: ())
#if projects.len() > 0 [
  #section("Projects")
  #for p in projects [
    *#p.at("name", default: "")* #h(1fr) #daterange(p.at("startDate", default: ""), p.at("endDate", default: none)) \
    #if p.at("description", default: "") != "" [#p.description \ ]
    #for h in p.at("highlights", default: ()) [
      - #h
    ]
    #v(0.3em)
  ]
]
