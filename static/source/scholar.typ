#let color-math(x, color) = text(fill: color)[$#x$]

#let homework-header(title: none, author-name: none) = {
  align(center, [
    = #title
    #align(left, [
      == #author-name
      == #datetime.today().display("[month]/[day]/[year]")
    ])
  ])

  v(2em)
}

#let homework-question(
  body,
  title: none,
  desc: none,
  show-answers: true,
  page-break: true,
) = {
  let content_ = [
    *#title*

    _#desc _

    #v(1em)
    #set enum(indent: 1em, spacing: 2em)
    
    #if show-answers { body }

    #v(3em)
  ]

  if page-break {
    content_
  } else {
    box(content_)
  }
}

#let homework-subquestion(
  body,
  desc: none,
  page-break: false,
) = {
  let content_ = [
    _#desc _
    #v(1em)
    #body
    #v(2em)
  ]

  if page-break {
    content_
  } else {
    box(content_)
  }
}
