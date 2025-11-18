Compile all static/source source files from typst code

```bash
find static/source -type f -exec sh -c 'f="{}"; typst c --features html --root static --format html "$f" "static/build/$(basename "$f" .typ).html"' \;
```