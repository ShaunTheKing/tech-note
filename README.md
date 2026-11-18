# Tech Note — Agent Skill

A Claude Code skill that turns a system, workflow, paper, tool or concept into a one-page
**technical note** in an academic-paper style: small-caps running head, a big serif title with one
highlighted phrase, an abstract, a hero flow diagram on a lavender panel, numbered two-column
sections, a booktabs table, and captioned figures. Output is a self-contained HTML file plus a PDF.
Layout follows [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills).

## Skills

| Skill | Description |
|---|---|
| [`tech-note`](skills/tech-note/SKILL.md) | Workflow, page anatomy, inline-SVG diagram rules, a review checklist and how to fit one page |

### Files
- [`assets/example.html`](skills/tech-note/assets/example.html) — a complete reference note that uses every component; its `<style>` block is the design system
- [`scripts/render.sh`](skills/tech-note/scripts/render.sh) — renders the HTML to PNG + PDF with headless Chrome and exits `3` if the content overflows one page

## Install

```bash
git clone https://github.com/ShaunTheKing/tech-note.git
cp -R tech-note/skills/tech-note ~/.claude/skills/
```

Then ask for "a technical note on …" or run `/tech-note <topic>`. Notes are written to
`~/Claude/notes/<slug>/<slug>.html` (and `.pdf`).

## Requirements
- Google Chrome, Brave or Chromium (for `render.sh`)
- Python 3 (used by `render.sh` to count PDF pages)
- Internet access for Google Fonts (EB Garamond, Courier Prime); without it the fonts fall back to Georgia/Courier
