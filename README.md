Compile all static/source source files from typst code

```bash
find static/source -type f -exec sh -c 'f="{}"; typst c --features html --format html "$f" "static/content/$(basename "$f" .typ).html"' \;
```