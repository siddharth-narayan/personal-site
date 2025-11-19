// #import "lib.typ": *
#import "@preview/finite:0.5.0": automaton, layout
#import "../../lib/scholar.typ": *

= This website is now written in Typst!

What follows are a series of tests to make sure that all the Typst stuff works correctly

```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}```

```json
{
  "user": {
    "id": 1024,
    "name": "Alice Nguyen",
    "roles": ["editor", "reviewer"],
    "active": true
  },
  "metrics": {
    "requests_today": 57,
    "avg_latency_ms": 142,
    "error_rate": 0.013
  },
  "settings": {
    "theme": "dark",
    "notifications": {
      "email": true,
      "sms": false
    }
  }
}

```

#html.frame[
  #let color-primary = color.hsl(0deg, 0%, 15%)
  #let color-secondary = color.hsl(0deg, 0%, 25%)

  #box(fill: color-primary, inset: 2em, radius: .5em, stroke: color-secondary)[


    #set text(fill: white)
    #set table(stroke: white)
    #set line(stroke: white)

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
]
