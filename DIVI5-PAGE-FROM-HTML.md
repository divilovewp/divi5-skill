# DIVI5 Skill — Page from HTML (design first, then compose)

> **Read this before building any NEW page on a connected site.** It replaces "assemble a
> page from named patterns" as the default route. The pattern route stays for a section that
> IS a native pattern (a working contact form, an accordion FAQ, a real pricing table).

## Why

A page assembled from named patterns is valid and generic: every column a card, everything
centred, the same rhythm on every site. Measured 2026-09-09 on three unrelated briefs (a logo
designer, a yoga studio, an invoicing SaaS): the pattern route produced the same page three
times with different words; a page the AI first DESIGNED as HTML, then SAW, then composed
module by module kept its own rhythm, type scale and asymmetry on all three.

The mechanism is the one the Figma route already proved: a **picture** carries composition, the
**data** carries values, and the page needs both. Here the AI writes the data (the HTML) itself.

## The order of work — do not skip a step

1. **Read the site.** `divi_get_design_system`. Note the font variables (display / body /
   mono by name), the size-scale names, and every global colour WITH its hex value.
2. **Ask what the design-process topic asks** (§0c) — brief, audience, tone, imagery, the one
   action the page exists for. Then decide, do not offer three.
3. **Design the page as HTML** — one file, an inline `<style>`, semantic tags: `<section>` per
   band, real `<h1>`–`<h3>`, `<p>`, `<a>` buttons, `<img>` with `width` + `height` +
   `object-fit`. Use the site's EXACT hex values and font names. An exact match binds to the
   variable automatically; a near miss stops the build with a reconciliation prompt you must
   put to the user (`token_mode`: snap / adopt / append / literal).
4. **Look at it.** A page you have not seen is a page you are guessing about.
   - If this client can screenshot (Claude Code, Cursor, Codex CLI: a browser or Playwright is
     available), render the file at 1440 wide, full page, and LOOK before composing.
   - If it cannot (claude.ai, ChatGPT, the Codex app), call `divi_preview_html` with the
     complete HTML. It comes back as a picture in parts, with a temporary preview address;
     SHOW the picture to the user and LOOK at it yourself. Fix the HTML and preview again if
     the composition is not what you meant.
   - If `divi_preview_html` answers that the setting is off, say so once (it is "Let the AI
     look at its drafts" under Divi Connect → Settings) and compose from the HTML without a
     picture. Do not retry, and do not ask the user to paste a screenshot.
5. **Compose into Divi** with `divi_build_page` using free-form sections / rows / columns /
   modules that reproduce the HTML (§ Compose). Name a pattern only where the section IS that
   native thing. Pass `status:"draft"` unless told otherwise.
6. **Render and look again** — `divi_get_rendered_page`, then compare with step 4's picture.
   Fix what moved with `divi_edit_module` / `divi_move_module`. "Built" means rendered and
   looked at, never the tool's return value.

## Design rules (the design-process topic's § 8b/8c, restated for the HTML you write)

- **5–9 sections; one idea per section; alternate surfaces** (white / tint / dark / accent).
- **Vary the section SHAPE.** One asymmetric split (7/5 or 2/1), one full-bleed band with a
  photograph, one grid, one centred statement, one plain two-column FAQ. Never five identical
  three-column rows.
- **One display face + one body face** from the site's font variables. Hero H1 at the top of
  the scale (72–88px on desktop), section H2 44–56px, body 16–18px, eyebrows 13px tracked caps.
- **Body copy 45–75ch.** State `max-width` on paragraphs in `ch`.
- **Cards are opt-in.** A column with a background is a column. Draw a card only where the
  design has one, and never a card inside a card.
- **Buttons:** one filled primary, at most one ghost beside it. Every button gets a hover.
- **Photographs at a stated box** (`width`, `height`, `object-fit: cover`). The box IS the
  design; the photograph is cropped to it.
- **The 3-brands test:** would this page be identical for a law firm, a taco truck and a SaaS?
  If yes, it is the generic default. Reground it in this brief's voice and the site's tokens.

## Presets — explicit values first, presets after approval

Measured: a named look overrides the design. `group style:"card-inverse"` painted a design's
blue plan DARK because that is the pack's inverse look. So:

- **Compose with explicit values** — `family`, `size`, `weight`, `lh`, `color`, `bg`, `radius`.
- **Name a preset only where the design IS that look** — a native accordion for an FAQ, a
  contact form, a pricing table. Not for headings, text, buttons or groups you can state.
- **After the render is approved,** offer ONE consented pass: "Shall I bind this page to the
  site's presets so it re-themes when your colours change?" Only on a yes, and only then.
- A page must never read as a catalogue of the pack's looks.

## Compose — how the HTML maps onto `divi_build_page`

| in the HTML | in the spec |
|---|---|
| `<section>` with `background` / `padding` | section `bg` (a hex, or a global colour's LABEL) · `pad:[top,bottom]` |
| `background-image` + a translucent veil | section `bg_image` + `bg_overlay` + `bg_overlay_opacity` |
| `.wrap{max-width:1200px}` | row `maxw:"1200px"` |
| `grid-template-columns: 7fr 5fr` | two columns `w:"14_24"` / `w:"10_24"` (24ths) |
| `gap` / `align-items:end` | row `gap` / `align:"bottom"` |
| a 3×2 grid of items | TWO rows of three columns |
| `<h1>`…`<h3>` | `heading{text,level,size,family,weight,lh,ls,color,align}` |
| `<p>` / `<ul>` | `text{html,size,color,lh,maxw,align}` — `maxw:"none"` for full width |
| an eyebrow | `eyebrow{text,color,align}` |
| `<a class="btn">` | `button{text,url,bg,fg,radius,pad,align}`; ghost = `fg` + `border_color`, no `bg` |
| `<img width height object-fit>` | `image{src,alt,width,radius}` — state `width` or it renders narrower than its column |
| a circle avatar | `image{width:"72px",radius:"36px",center:true}` |
| `text-align:center` on a band | `align:"center"` on each module AND `center:true` on the column |
| a flex "line" (time · class · teacher) | one `<p>` per line inside one text module, `lh` ≥ 2 |
| two buttons side by side | two narrow columns; in ONE column they stack |
| an offset layout (content left, nothing right) | a column with `modules:[]` — it holds its width |

**Column widths are Divi's, not CSS grid's.** A Divi 24ths column subtracts the row gap
unevenly: an `8_24` column beside a 64px gap renders 357px wide where CSS `2fr 1fr` gives
378px (measured). A photograph drawn to the CSS column therefore fits the Divi column a few
percent narrower, ratio kept. Size photographs to the Divi column, or accept the fit.

**`token_mode:"snap"` snaps WIDTHS too.** Answering a colour reconciliation with `snap` also
rebinds a row's `maxw:"1200px"` to the nearest size variable, and on a fluid scale that is a
clamp(): measured, a 1200px row rendered 1098px at 1440. If the design's widths must hold,
avoid the prompt (use the site's exact colours) or answer `literal`, and say which you did.

Sizes in px trigger the font-size question; answer it with the user (`size_policy`).
Always read the response `warnings` and relay the ones about contrast and linked variables.

## The translator alternative — `divi_build_from_html`, and what it DROPS

For a design that is simple grids, `divi_build_from_html` → `divi_create_page` is
deterministic and needs no composing. It reads real CSS, computes columns and binds exact
colours. But it drops what it cannot read, and SAYS SO in `notes` — repeat every note to the
user. Measured drops (2026-09-09), with the HTML that avoids each:

| what you wrote | what arrived | write instead |
|---|---|---|
| a grid with more children than tracks (3 tracks, 6 items) | ONE row of six columns | one container per visual row, three children each |
| a grid nested inside a grid cell | flattened into one wide row | one level of grid per section; split a 2×2 into two rows |
| `display:flex` rows of `<span>` (a timetable line) | every span a column, words broken one letter per line | one `<p>` per line, `&nbsp;` and `<strong>` inside it |
| column ratios on a DESCENDANT selector (`.hero .wrap{7fr 5fr}`) | "declared no widths, split evenly" | put the ratio on the element's OWN class |
| a background-image section whose CHILD carries the padding and veil | padding and veil lost | `background-image` and padding on the `<section>` itself; the veil is a compose job |
| `border-radius` on an `<img>` | square | compose it (`image.radius`) |
| `text-align:center` on a section holding an `<img>` | headings centred, image left | compose it (`center:true`) |
| a descendant colour on list items (`.pro li{color:#fff}`) | grey ink on the coloured card | state the colour on the `<ul>` itself |
| any translated page | 8–40px sideways scroll at 1440 | known, translator side — check `scrollWidth` after the build |

When a design uses more than two of the left column, compose it (§ Compose) instead.

## What a finished job looks like to the user

"I read your site's colours and fonts, designed the page as a draft you can see here, then
built it in Divi from that design. It is a draft at <url>. Two things to know: <the warnings
that matter>. Want me to bind it to your presets so it re-themes with the site?"
