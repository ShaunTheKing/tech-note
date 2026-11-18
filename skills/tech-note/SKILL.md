---
name: tech-note
description: Build a one-page "technical note" in an academic-paper style — small-caps running head, big serif title with one highlighted phrase, abstract, a hero flow diagram on a lavender panel, numbered two-column sections, a booktabs table, and captioned figures — as a self-contained HTML file plus PDF. Use when the user asks for a technical note, a paper-style one-pager, "notes like this", or a visual explainer of a system, workflow, paper, tool, or concept.
---

# Tech note

Topic: $ARGUMENTS (if empty, ask what the note is about and who it's for).

The reference is `assets/example.html` — a complete note that uses every component.
**Read it fully before writing.** Copy its `<style>` block verbatim; reuse its markup patterns.

## Workflow
1. **Gather facts.** About the user's code/system → read it. About an external topic →
   research primary sources. Never invent numbers, dates, or quotes. A chart without real
   data must say "schematic" in its axis label and caption.
2. **Outline in your head (fixed anatomy, one page):**
   - Running head: `Technical Note · <Field>` + tiny mark on the right.
   - Title block: badge (SVG icon/monogram) + title with **one** `.hl` phrase + italic subtitle
     (one line, states the idea, not the topic). Thick+thin rule below.
   - Abstract: 4–6 sentences, `Abstract.` label. What it is, how it works, the key rule, the outcome.
   - **Figure 1 (hero)**: the mechanism as a flow diagram on `.panel`. Left = actors/inputs,
     middle = the agent/engine, right = numbered steps + a decision diamond + keep/drop outcomes,
     loops drawn back with labelled arrows.
   - Two columns. Left: `1 Method` (one paragraph) → `Table 1` (4–5 rules, one `.hl` row for the
     key rule) → `2 Why …`. Right: `Figure 2` (chart/timeline) → `Figure 3` (a)(b) small
     multiples → `3 <consequence>`.
   - Every figure/table has a caption whose first sentence says what it shows and the rest
     says what to notice.
3. **Write** `~/Claude/notes/<slug>/<slug>.html` (create the folder). Self-contained: inline
   CSS and SVG, Google Fonts link only. `<title>` = the note title.
4. **Render and look:** `bash ~/.claude/skills/tech-note/scripts/render.sh <file.html>`
   then **Read the PNG** and check it like a reviewer (see checklist). Exit code 3 = overflow:
   read `<slug>.full.png`, tighten, re-render. Repeat until `pages=1` and the checklist passes.
5. **Deliver:** `open <slug>.pdf`. Tell the user the HTML/PDF paths and what's in the note.

## Diagram rules (inline SVG)
- Plan coordinates on a grid before writing: hero viewBox ≈ `0 0 960 480`; columns at
  x≈40 (actors, w 210), x≈300 (agent, w 150), x≈500 (steps, w 220), x≈760 (outcomes, w 170).
  Steps h=50 with 22px gaps; box text starts 14px from the left edge.
- Use the CSS classes, not inline colours: groups `.box .human .edit .keep .drop .dark .focus .note`
  wrapping a `<rect>`; text `.k` (small-caps kicker) `.t` (serif) `.big` (bold mono) `.m` (mono)
  `.d` (description) `.i` (italic edge label) `.c` (centered); lines `.ln` (+`.dash`).
- One `.focus` box only — the step the note is really about.
- Arrows: `marker-end="url(#ah)"`; end 2px before the target edge. Route loops in empty
  gutters with orthogonal paths (`M x y H x V y`); never cross a box or a label.
- Text must fit its box: mono ≈ 0.6 × font-size per char, serif ≈ 0.5 ×. Shorten labels
  rather than shrinking fonts below 11px.
- A badge is an SVG icon or monogram. Use a photo only if the user supplies the image, and
  never a real person's likeness otherwise.

## Review checklist (after every render)
- [ ] `pages=1`; nothing clipped at the bottom; columns end at similar heights.
- [ ] No text overflowing a box, overlapping a line, or colliding with another label.
- [ ] Every arrow starts and ends on an edge; loop labels sit beside their line.
- [ ] Exactly one highlighted title phrase, one `.focus` box, one highlighted table row.
- [ ] Figure/table numbers are sequential and referenced in the order they appear.
- [ ] Facts trace to sources; schematic charts say so.

## Fitting one page (in this order)
Cut words first (abstract ≤ 5 lines, method ≤ 9 lines, table cells one line) → compact the
small figures (shorter viewBox heights) → only then reduce spacing. Don't drop below
body 13.5px / caption 12.5px. If it still overflows, the note has two ideas: split it.

## Gotchas
- Fonts load from Google; render.sh waits 6s. Offline → fallbacks (Georgia/Courier) shift
  widths, so re-check box text fit.
- `.page` is fixed at 1000×1294 with `overflow:hidden` so the PDF is one page; that hides
  overflow in the PNG — trust render.sh's page count, not your eyes, for fit.
- SVG `<text>` doesn't wrap. Multi-line labels = multiple `<text>` elements 16–18px apart.
- Keep marker ids unique per SVG (`ah`, `ah2`, …).
- The example's content is about the plan-and-delegate skill — replace all of it.
