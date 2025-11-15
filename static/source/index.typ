// #import "lib.typ": *
#import "@preview/finite:0.5.0": automaton, layout
#import "scholar.typ": *

#html.frame[
  #set text(fill: white)
  #set table(stroke: white)
  #set line(stroke: white)

  #homework-header(
    title: "CS 4386 Homework 2",
    author-name: "Siddharth Narayan",
  )

  #homework-question(
    title: "Question I - FIRST and FOLLOW",
    desc: [
      For the following grammar
      $
        & S -> A a \
        & A -> B D \
        & B -> b \
        & B -> epsilon \
        & D -> d \
        & D -> epsilon
      $
    ],
    page-break: false,
  )[
    + #homework-subquestion(desc: "Give the FIRST set for each symbol")[
        #grid(columns: 2, column-gutter: 3em)[
          $"FIRST"(S) = { b, d, a }$

          $"FIRST"(A) = { b, d, epsilon }$

          $"FIRST"(B) = { b, epsilon }$

          $"FIRST"(D) = { d, epsilon }$
        ][
          $"FIRST"(a) = { a }$

          $"FIRST"(b) = { b }$

          $"FIRST"(d) = { d }$
        ]
      ]
    + #homework-subquestion(desc: "Give the FOLLOW set for each of the nonterminals")[
        // #text(red)[Is $"FOLLOW"(S) =  epsilon$ or is it \$ ]

        $"FOLOW"(S) = { \$ }$

        $"FOLOW"(A) = { a }$

        $"FOLOW"(B) = { d, a }$

        $"FOLOW"(D) = { a }$
      ]
  ]

  #homework-question(
    title: "Question II - LL Parsing",
    desc: [
      Given the following grammar

      The LL parse table for the grammar is below. Show the steps to accept or reject the string "`a + a * a`"

      #align(center, table(
        columns: (2em,) + (5.6em,) * 6,
        rows: 1.5em,
        align: center + horizon,
        stroke: .3pt,

        table.header([], [`a`], [`+`], [`*`], [`(`], [`)`], [`$`]),

        [$E$], [$E->T A$], [], [], [$E->T A$], [], [],

        [$T$], [$T -> F B$], [], [], [$T->F B$], [], [],

        [$F$], [$F -> a$], [], [], [$F->(E)$], [], [],
        [$A$], [], [$A -> + T A$], [], [], [$A->epsilon$], [$A->epsilon$],

        [$B$], [], [$B->epsilon$], [$B->* F B$], [], [$B->epsilon$], [$B->epsilon$],
      ))
    ],
  )[
    In this case, I did not show the terminals matching step. If the terminals matched after a production, I popped them from the stack

    automatically
    #table(
      columns: (6em,) * 3,
      rows: 2em,
      stroke: .3pt,
      align: (right + horizon,) * 2 + (center + horizon,),

      table.header([Stack], [Input], [Action]),

      [$E \$$], [`a + a * a$`], [$E ->T A$],
      [$T A \$$], [`a + a * a$`], [$T->F B$],
      [$F B A \$$], [`a + a * a$`], [$F->$ `a`],
      [$B A \$$], [`+ a * a$`], [$B -> epsilon$],
      [$A\$$], [`+ a * a$`], [$A ->$ `+` $T A$],
      [$T A \$$], [`a * a$`], [$T -> F B$],
      [$F B A \$$], [`a * a$`], [$F ->$ `a`],
      [$B A \$$], [`* a$`], [$B -> * F B$],
      [$F B A \$$], [`a$`], [$F -> a$],
      [$B A \$$], [`$`], [$B -> epsilon$],
      [$A \$$], [`$`], [$A -> epsilon$],
      [$\$$], [`$`], text(fill: green.darken(30%))[*Accept*],
    )
  ]

  #homework-question(
    title: "Question III - LR Parsing",
    desc: [
      Make an LR(0) automaton for the following CFG

      $
        & S' -> S \
        & S -> A a \
        & S -> B b \
        & S -> a c \
        & A -> a \
        & B -> b
      $


    ],
  )[
    First compute the closure of $S'$ (And the start state)

    $I_0 = {S' -> .S, S ->.A a, S -> .B b, S -> .a c, A ->.a, B -> .b}$

    Now compute GOTO transitions. Let's color reduce states with blue. Green is the accepting state

    #grid(columns: 2, column-gutter: 3em)[
      $I_1 = "GOTO"(I_0, S) = { #color-math($S' -> S.$, green.darken(30%))}$

      $I_2 = "GOTO"(I_0, A) = { S -> A.a}$

      $I_3 = "GOTO"(I_0, B) = { S -> B.b}$

      $I_4 = "GOTO"(I_0, a) = \
      "   "{ S -> a.c, #color-math($A-> a.$, blue)}$

      $I_5 = "GOTO"(I_0, b) = { #color-math($B -> b.$, blue)}$

      #line()
      // Second level GOTOs
      $I_6 = "GOTO"(I_2, a) = { #color-math($S -> A a.$, blue)}$

      $I_7 = "GOTO"(I_3, b) = { #color-math($S -> B b.$, blue)}$

      $I_8 = "GOTO"(I_4, c) = { #color-math($S -> a c.$, blue)}$
    ][
      #let curve-strength = 0
      #let neg-curve = (curve: -curve-strength, label: (dist: -.5))
      #let straight = (curve: 0)

      #automaton(
        (
          I0: (I1: "S", I2: "A", I3: "B", I4: "a", I5: "b"),
          // I1: (),
          I2: (I6: "a"),
          I3: (I7: "b"),
          I4: (I8: "c"),
          I5: (),
          // I4: (I1: "c"),
        ),
        initial: "I0",
        final: ("I1",),
        style: (
          state: (fill: luma(250), stroke: 2pt + black),
          transition: (curve: curve-strength, label: (angle: 0deg), stroke: luma(81.18%)),
          I1: (stroke: 1.5pt + green.darken(40%)),
          I4: (stroke: (thickness: 2pt, dash: "densely-dashed", paint: blue)),
          I5: (stroke: 2pt + blue),
          I6: (stroke: 2pt + blue),
          I7: (stroke: 2pt + blue),
          I8: (stroke: 2pt + blue),
          // I0-I2: (curve: -.5),
          // I0-I3: (curve: -1),
          // I0-I4: (curve: -2),
          // I0-I5: (curve: -2),
        ),
        layout: layout.custom.with(positions: (
          I0: (-2, -4),
          I1: (2, 0),
          I2: (2, -2),
          I3: (2, -4),
          I4: (2, -6),
          I5: (2, -8),
          I6: (4, -2),
          I7: (4, -4),
          I8: (4, -6),
        )),
      )
    ]

    #v(2em)

    // #text(red)[State 4 seems ambiguous, but it can be reorganized to be deterministic. What's the process for that, are we expected to do it by hand?]



  ]
]
