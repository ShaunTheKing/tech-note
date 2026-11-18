#!/bin/bash
# Render a tech-note HTML file with headless Chrome.
# Usage: render.sh path/to/note.html
# Writes note.png (what the page looks like) and note.pdf next to the HTML.
# Exit 3 = content overflows one page; also writes note.full.png showing the overflow.
set -euo pipefail

[ $# -eq 1 ] && [ -f "$1" ] || { echo "usage: render.sh note.html" >&2; exit 1; }
in="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
base="${in%.html}"

C=""
for b in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
         "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" \
         "/Applications/Chromium.app/Contents/MacOS/Chromium"; do
  [ -x "$b" ] && { C="$b"; break; }
done
[ -n "$C" ] || { echo "no Chrome/Brave/Chromium found" >&2; exit 1; }

run() { "$C" --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=6000 "$@" 2>/dev/null; }

# 1. Measure: unclip the page and count PDF pages.
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
sed 's/height:1294px; overflow:hidden;/min-height:1294px;/' "$in" > "$tmp/m.html"
run --no-pdf-header-footer --print-to-pdf="$tmp/m.pdf" "file://$tmp/m.html"
pages=$(python3 -c "import re,sys;d=open(sys.argv[1],'rb').read();print(max(int(x) for x in re.findall(rb'/Count (\d+)',d)))" "$tmp/m.pdf")

# 2. Screenshot + PDF of the real (one-page) note.
run --window-size=1000,1294 --screenshot="$base.png" "file://$in"
run --no-pdf-header-footer --print-to-pdf="$base.pdf" "file://$in"

echo "pages=$pages"
echo "png=$base.png"
echo "pdf=$base.pdf"
if [ "$pages" -gt 1 ]; then
  run --window-size=1000,1800 --screenshot="$base.full.png" "file://$tmp/m.html"
  echo "OVERFLOW: content needs $pages pages; see $base.full.png and tighten until pages=1" >&2
  exit 3
fi
rm -f "$base.full.png"
