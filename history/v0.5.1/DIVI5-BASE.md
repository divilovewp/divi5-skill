---
name: divi5-base
description: Core rules, nesting hierarchy, common mistakes and validation checklist for Divi 5 JSON generation. Always attach this file alongside any other DIVI5 skill files.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Base Rules
> **Part of the DIVI5 skill set. Always attach this file. Attach module/styling files as needed.**
> Skill files: BASE (this) · DESIGN-PROCESS · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS

> **Build order: ask, think, then transcribe.** Before writing any markup, work through **DESIGN-PROCESS**: first **ask the user focused discovery questions** (goal, CTA, brand, content, sections…), then produce a written **Page Plan** (intent → narrative → blueprint → design system → self-critique). The rules below govern the JSON; the design quality comes from the discovery + plan.

---

## 0. What's New in v0.5.1 (Divi 5.7.4)

Targets the current **Divi 5.7.x** line (latest **5.7.4**, 06-12-2026). The authoring features below were all introduced in **5.7.0**; releases **5.7.1–5.7.4** were maintenance/bug-fix patches with **no new authoring schema, attribute paths, or render contracts** — nothing in hand-authored page JSON changes. (5.7.1–5.7.4 added the builder-UI **workspace** system, command-center comments, and a long list of Visual-Builder / migration / front-end render fixes — none affect generated markup.) `builderVersion` is bumped to `"5.7.4"` to match the installed theme.

Authoring features (introduced in 5.7.0, on top of the 5.6.2 baseline below):

- **Text fill effects (font groups):** any font group now supports **gradient text fill**, **image text fill**, and **text stroke** via `<element>.decoration.font.textEffects` → STYLING §7b.
- **Gradient variables:** gradients (backgrounds *and* text fill) can reference a reusable global gradient token — `$variable({"type":"gradient",...})$`, stored under `global_variables` type `gradients` → STYLING §1 + §10.
- **Gradient picker / new gradient fields:** richer gradient model now exposed everywhere a gradient is set — adds `conic`/`elliptical` types, `directionRadial`, `repeat`, `length` → STYLING §1.
- **"Convert to variable"** right-click option in the builder produces ordinary global tokens; the `$variable(...)$` reference syntax is unchanged.
- **`builderVersion` bumped to `"5.7.4"`** (older values still import via backward-compat migration; match the installed Divi version).

## 0b. What's New in v0.4.0 (Divi 5.6.2)

Built/confirmed against Divi **5.0.x**; this revision documents everything added through **5.6.2** (source-verified — entries marked *⚙ source* still pending real-render confirmation).

- **New modules:** `divi/svg`, `divi/timeline` + `divi/timeline-item`, `divi/breadcrumbs`, `divi/table-of-contents`, `divi/instagram-feed`, `divi/dropdown`, `divi/contact-form-7` (CF7 styler).
- **New systems:** **Grid layout** (`layout.display:"grid"`) → LAYOUT; **aspect-ratio** + **image framing** (object-fit/position) → STYLING; **Loop Builder** (`advanced.loop`) → DYNAMIC; **form pseudo-class states** (focus/checked/active) → INTERACTIVE; **variable generators** (Color Scale / Color Harmony / fluid sizing) → STYLING; **`divi/global-layout`** → LAYOUT.
- **Newly documented module families:** dynamic content (blog, portfolio, post*, menu, search, login, sidebar, comments, map) → MODULES-DYNAMIC; full WooCommerce family → MODULES-WOOCOMMERCE.
- **`builderVersion` bumped to `"5.6.2"`** (since superseded by `"5.7.4"` — see v0.5.1 above) (older values like `"5.1.0"` still import via backward-compat migration, but match the installed Divi version).

## 1. Non-Negotiable Rules — Always Follow These

1. **Every page content string is wrapped in `<!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder -->`.**
2. **Hierarchy is always: Section → Row → Column → Module(s).** Never skip levels.
3. **`builderVersion: "5.7.4"` must be on every single module** — section, row, column, and all content modules. (Match the installed Divi version; older values import via backward-compat but should be updated.)
4. **Self-closing modules** end with ` /-->` (space + slash): `<!-- wp:divi/heading {...} /-->`.
5. **Container modules** (section, row, column, group, etc.) use open + close pairs.
6. **Row flex layout is driven by `flexColumnStructure` + `layout.*.value.flexWrap`** — NOT by a `display: flex` property.
7. **Column widths are set via `module.decoration.sizing.*.value.flexType`** using the `N_24` fraction system.
8. **`flexColumnStructure` count must exactly match the number of `divi/column` children** in that row.
9. **Heading `title.innerContent` is plain text only** — no HTML tags. The tag is set via `headingLevel`.
10. **Rich text content** (text, blurb body, testimonial) must HTML-encode `<` as `\u003c` and `>` as `\u003e`.
11. **Never include `groupPreset`** — it references site-specific preset IDs.
12. **Spacing is optional** — DIVI5 applies default padding when none is specified.
13. **The `data` field value is a plain string** — not a nested object.
14. **Build with REAL Divi modules — never a `divi/code` + `<style>` stylesheet.** The product promise is "pages built from Divi 5 modules." Express every trust bar, quote, stat, icon, link, list, and card as its proper module (icon-list, text, number-counter, blurb/icon, link, accordion, testimonial…). **`divi/code` is last-resort only**, for genuine custom SVG art or a third-party embed — never as the primary way to lay out a page, and **never ship a shared global stylesheet** that styles modules via classes. Style through module **decoration** + design-system tokens instead. (See DESIGN-PROCESS "Module-selection decision tree" + "Native recipes"; self-audit in §9.)
15. **Design-system tokens are the default for colors/sizes/spacing — but gated on availability + consent.** Prefer `gcid-*` color and `gvid-*` size/width/spacing/font variables so the design stays editable + fluid. BUT first confirm the site actually has them (`GET /design-system`). If the needed variables are **absent**, **ASK the user**: generate a variable system, or build with inline numeric values? Build with tokens only if they exist or the user opts to generate them; otherwise inline literals are an **accepted** path, not a defect. (See DESIGN-PROCESS "Variable-availability gate" + STYLING §10.)

---

## 2. Top-Level JSON Structure

```json
{
  "context": "et_builder",
  "data": {
    "11": "<!-- wp:divi/placeholder -->...PAGE_CONTENT...<!-- /wp:divi/placeholder -->"
  },
  "presets": null,
  "global_colors": [],
  "global_variables": [],
  "canvases": {"local": [], "global": []},
  "images": [],
  "thumbnails": []
}
```

### Critical: `data` Value Format

The value of `data["11"]` must be a **plain string** containing the Gutenberg markup.

❌ **Wrong** (post_type portability format):
```json
"data": {"1": {"post_content": "...", "post_title": "My Page"}}
```
✅ **Correct** (`et_builder` context — raw string):
```json
"data": {"11": "<!-- wp:divi/placeholder --><!-- wp:divi/section...<!-- /wp:divi/placeholder -->"}
```

---

## 3. Import & Export

- Upload via Divi's Import & Export UI, or create pages via the WordPress REST API (see WORDPRESS skill file).
- `context` must be `"et_builder"` — hard-validated server-side. Wrong context = import fails with `"This file should not be imported in this context."`

---

## 4. Nesting Hierarchy

```
placeholder wrapper
  └── Section
        └── Row
              └── Column
                    └── Module(s) or Group
                          └── Module(s) [if inside Group]
                          └── Nested Row → Column → Module
```

**Never place a module directly in a section or row.** Always: Section → Row → Column → Module.

### Parent–Child Rules

| Parent | Valid Children |
|--------|----------------|
| `section` | `row`, `global-layout` |
| `row` | `column` only |
| `column` | `group`, `group-carousel`, any content module, nested `row` |
| `group` | any content module, nested `row` |
| `group-carousel` | `group` |
| `accordion` | `accordion-item` |
| `counters` | `counter` |
| `contact-form` | `contact-field` |
| `pricing-tables` | `pricing-table` |
| `slider` | `slide` |
| `tabs` | `tab` |
| `social-media-follow` | `social-media-follow-network` |
| `icon-list` | `icon-list-item` |
| `video-slider` | `video-slider-item` |
| `timeline` | `timeline-item` |
| `map` / `fullwidth-map` | `map-pin` |

---

## 5. Self-Closing vs Container Reference

**Self-closing** (end with ` /-->`):
text, heading, button, image, blurb, cta, testimonial, video, code, divider, icon, link, team-member, number-counter, circle-counter, gallery, lottie, audio, before-after-image, countdown-timer, map-pin, menu, fullwidth-menu, search, sidebar, login, canvas-portal, fullwidth-header, post-nav, accordion-item, toggle, tab, contact-field, slide, video-slider-item, counter, pricing-table, social-media-follow-network, icon-list-item, signup, blog, post-carousel, post-slider, portfolio, filterable-portfolio, comments, pagination, dropdown, **svg, breadcrumbs, table-of-contents, instagram-feed, timeline-item, contact-form-7, global-layout**, and most WooCommerce modules (see MODULES-WOOCOMMERCE)

**Container** (require open + close tags):
section, row, column, group, group-carousel, accordion, tabs, contact-form, counters, pricing-tables, social-media-follow, icon-list, slider, video-slider, **timeline, map, fullwidth-map**

> `map`/`fullwidth-map` are containers when they hold `map-pin` children. A standalone `divi/map` with the address in `map.innerContent` can be self-closing.

---

## 6. Responsive Breakpoints

| Key | Screen Width |
|-----|-------------|
| `desktop` | ≥ 981px — **always required** |
| `tablet` | 768–980px |
| `phoneWide` | 480–767px |
| `phone` | < 480px |

Always provide `desktop` values. Add other breakpoints only when behavior should differ.

---

## 7. Common Mistakes & Fixes

### `innerContent.desktop.value` Must Never Be an Array
❌ `"value": [{"src": "..."}, {"src": "..."}]` — WordPress `formatting.php:ltrim()` crashes on array values → **500 Server Error**.
✅ `"value": "string"` or `"value": {"key": "string"}` — strings and objects are safe.

This affects gallery images and any field where you might try to pass a list. Arrays as `innerContent` values are not supported anywhere in the Divi 5 REST API.

### Wrong `data` field structure
❌ Nested object. ✅ Plain string (see Section 2).

### Missing `builderVersion`
❌ Any module without `"builderVersion": "5.7.4"` will fail to render or import.

### Row Flex Not Working
❌ Setting `display: flex` or `"display": "flex"` — ignored by Divi.
✅ Set `flexColumnStructure` in `module.advanced` + `flexWrap` in `module.decoration.layout`.

### HTML Tags in Heading Content
❌ `"value": "<h2>My Title</h2>"` — renders as literal text.
✅ `"value": "My Title"` — plain text. Control tag with `headingLevel: "h2"`.

### ❌ NEVER wrap module attributes in an `attrs` object  (BLANK-PAGE CAUSE #1)
The JSON after a block name **is** the attributes object. Put the attribute groups
(`title`, `content`, `module`, `builderVersion`, ...) at the **top level** of the block JSON.
❌ `<!-- wp:divi/heading {"attrs":{"title":{...}}} /-->` -- module renders **EMPTY** (blank page).
✅ `<!-- wp:divi/heading {"title":{...},"builderVersion":"5.7.4"} /-->`
> `attrs` IS a real key in **preset** definitions (see PRESETS) -- do not carry it over. Module **blocks** never use an `attrs` wrapper.

### `divi/text` content key is `content` — NOT `body`, NOT `text`  (BLANK-PAGE CAUSE #2)
❌ `"body": {"innerContent": {...}}` or `"text": {"innerContent": {...}}` -- text renders **EMPTY**. The key is literally `content`. (`body` only exists as the `bodyFont` *styling* group, e.g. `decoration.bodyFont.body.font`.)
✅ `"content": {"innerContent": {"desktop": {"value": "\u003cp\u003eHello.\u003c/p\u003e"}}}`

### HTML content MUST be unicode-escaped
Any module holding HTML (`divi/text` content, blurb/CTA/testimonial/fullwidth-header body, etc.) must escape `<`/`>` as `\u003c`/`\u003e`. Raw tags break the block parser and leak as literal text on the page.
❌ `"value": "<p>Hello.</p>"`  (raw `<p>` -- WRONG)
✅ `"value": "\u003cp\u003eHello.\u003c/p\u003e"`

### Escape non-ASCII characters in content (em-dash, smart quotes, emoji)
Raw multibyte characters can be corrupted to `�` when content is sent through the claude.ai MCP connector. In any text `value`, prefer plain ASCII (`-`, straight quotes) **or** unicode-escape: em-dash `\u2014`, en-dash `\u2013`, curly quotes `\u2018`/`\u2019`/`\u201c`/`\u201d`. (Escapes decode correctly when WordPress parses the block.)

### Self-Closing Syntax Error
❌ `<!-- wp:divi/text {...} -->` — opens a container, never closes.
✅ `<!-- wp:divi/text {...} /-->` — note the space before `/`.

### `divi/cta` always shows a default background
`divi/cta` renders Divi's theme primary color as its background even when none is set. If the CTA shouldn't have its own panel, set `module.decoration.background.desktop.value.color` to `"rgba(0,0,0,0)"` (transparent). See MODULES-CONTENT → divi/cta.

### Missing Closing Tags
Every container needs a close: `<!-- /wp:divi/section -->`, `<!-- /wp:divi/row -->`, `<!-- /wp:divi/column -->`

### Script-Dependent Modules + Programmatic/REST Creation (Dynamic Assets)
Divi 5's **dynamic-assets** system only enqueues a module's frontend JS/CSS when the module is detected through the **builder save pipeline**. If you create a page/Theme-Builder layout by writing **raw block markup via the REST API/DB**, modules that build themselves client-side may not get their script and will render empty/incomplete. Confirmed for **`divi/table-of-contents`** (built nothing until created via the builder UI); likely also affects other script-driven modules. **Fix:** create/save such layouts through the builder UI, or ensure the module's script is enqueued. Static/server-rendered modules (heading, text, image, blurb, etc.) are unaffected.

### Grid Layout Does Not Stack on Mobile
A container with `layout.display:"grid"` keeps its `gridColumnCount` on every breakpoint — it will NOT collapse to one column on phones the way a flex row wraps. Set responsive `gridColumnCount` (`tablet`/`phone`) explicitly. (Render-confirmed in 5.6.2.) See LAYOUT §5b.

### `flexColumnStructure` Mismatch
If row declares `equal-columns_3` but has only 2 `divi/column` children → broken layout. Count must match exactly.

### Missing `<!-- wp:divi/placeholder -->` Wrapper
Entire page content must be wrapped. Missing this = import failure.

### Wrong Button Attribute Names
❌ Divi 4: `url`, `newWindow`
✅ Divi 5: `linkUrl`, `linkTarget`

### Missing `settings: {}` in Variable References
❌ `$variable({"type":"color","value":{"name":"gcid-primary-color"}})$`
✅ `$variable({"type":"color","value":{"name":"gcid-primary-color","settings":{}}})$`

### Blurb Title Format
❌ `"innerContent": {"desktop": {"value": "Feature Title"}}` (plain string)
✅ `"innerContent": {"desktop": {"value": {"text": "Feature Title"}}}` (object with `text` key)
To link the title, add `"url"` + `"target"` to that value object — NOT `linkUrl`/`linkTarget` (those are the *button* keys and yield no anchor on a blurb). See MODULES-CONTENT `divi/blurb`.

### Invalid Module Nesting
❌ Module directly in section · Module directly in row · Section nested inside column

### Number Counter — 3rd Column Hidden on Mobile
When a 3-column stats row wraps to single column on mobile, the 3rd `number-counter` can appear invisible if it ends up on a white background with default text color. Always explicitly set `color` on `number.decoration.font` and `title.decoration.font`. Never rely on defaults when sections alternate backgrounds.

### Transparent Button Background Is Invisible
❌ `"background": {"color": "transparent"}` — button text has no visible container on any background.
✅ For ghost/outline buttons, use a `border` instead:
```json
"module": {
  "decoration": {
    "background": {"desktop": {"value": {"color": "transparent"}}},
    "border": {"desktop": {"value": {"styles": {"all": {
      "width": "2px", "color": "#FFFFFF", "style": "solid"
    }}, "radius": {"topLeft": "8px", "topRight": "8px",
      "bottomLeft": "8px", "bottomRight": "8px", "sync": "on"
    }}}}
  }
}
```

### Button Centering — Use `module.advanced.alignment`

The simplest and most reliable way to center a `divi/button` is `module.advanced.alignment`. It works standalone without touching the parent column:

```json
"module": {
  "advanced": {
    "alignment": {
      "desktop": {"value": "center"},
      "tablet":  {"value": "center"},
      "phone":   {"value": "center"}
    }
  }
}
```

Set it on every breakpoint — alignment does not inherit across breakpoints. Omitting tablet/phone causes the button to fall back to left-aligned on those sizes.

**Alternative (flex-based):** `module.decoration.layout` with `display: "flex"` and `justifyContent: "center"` also works but requires the same values set on the parent column for every breakpoint. Prefer `module.advanced.alignment` — it is self-contained and avoids column coordination.

### Column Padding + Module Internal Padding Double-Up
Modules like `testimonial`, `blurb`, and `cta` have their own internal padding (typically 40px). If you also add padding to the wrapping `column`, both compound and the usable text area shrinks significantly — cards look cramped even though the column width is adequate. **Rule:** let modules define their own internal spacing; columns should only provide structural layout (flex widths, responsive stacking). Do not set `spacing.padding` on columns unless the child module has no internal padding.

### `divi/audio` src Must Be a Plain String, Not an Object
❌ `"audio": {"innerContent": {"desktop": {"value": {"src": "https://...mp3"}}}}` — crashes WP with 500 (`ltrim(): array given` in AudioModule.php)
✅ `"audio": {"innerContent": {"desktop": {"value": "https://...mp3"}}}` — plain string URL

This differs from `divi/video` which uses `{"src": "..."}` as an object. Audio uses a bare string.

### Standalone Button — ALL visible styling goes on `button.decoration`
> **⚠️ CORRECTED 2026-06-20 (render-verified on Divi 5.7.4).** This
> supersedes the older guidance that put background/border/padding on
> `module.decoration`. On 5.7.4, a standalone `divi/button`'s visible styling —
> **background, border, radius, spacing(padding), AND label font (color/weight/
> size/family)** — ALL live on **`button.decoration`**. Putting the background on
> `module.decoration` leaves the builder's **Design ▸ Button ▸ Background** field
> empty and the colour "comes from nowhere." Use `module.decoration` only for the
> wrapper's own concerns (e.g. `module.advanced.alignment` to center the button).
> `button.decoration` is the SAME element used by sub-button fields inside other
> modules (`divi/cta`, etc.). *(Priority item for the per-module button deep-dive —
> confirm every Design/Advanced field's exact home.)*

✅ Correct (everything on `button.decoration`):
```json
"button": {
  "innerContent": {"desktop": {"value": {"text": "Book a call", "linkUrl": "/book/", "linkTarget": "off"}}},
  "decoration": {
    "background": {"desktop": {"value": {"color": "#2563eb"}}},
    "border":     {"desktop": {"value": {"radius": {"topLeft": "10px", "topRight": "10px", "bottomLeft": "10px", "bottomRight": "10px", "sync": "on"}}}},
    "spacing":    {"desktop": {"value": {"padding": {"top": "16px", "bottom": "16px", "left": "36px", "right": "36px"}}}},
    "font": {"font": {"desktop": {"value": {"color": "#FFFFFF", "weight": "700", "family": "$variable({\"type\":\"font\",\"value\":{\"name\":\"gvid-font-body\",\"settings\":{}}})$"}}}}
  }
},
"module": {"advanced": {"alignment": {"desktop": {"value": "center"}}}}
```

**Hover state** must be a `hover` key **nested INSIDE the breakpoint, sibling of `value`, content UN-wrapped** — NOT `background.hover.value.color`. Without this no `:hover` CSS is emitted (source: `MultiViewUtils.php` → `desktop:{value,hover,sticky}`). See STYLING §7c.
```json
"button": {"decoration": {
  "background": {"desktop": {"value": {"color": "#2563eb"}, "hover": {"color": "#1e4fd0"}}},
  "font": {"font": {"desktop": {"value": {"color": "#FFFFFF"}, "hover": {"color": "#FFFFFF"}}}}
}}
```

### Side-by-Side Buttons

Two `divi/button` modules in a column stack vertically by default. To place them side by side, set `flexDirection: "row"` on the **column**:

```json
"module": {
  "decoration": {
    "layout": {
      "desktop": {"value": {"flexDirection": "row", "alignItems": "center"}},
      "phone":   {"value": {"flexDirection": "column"}}
    }
  }
}
```

Set `phone` back to `"column"` so buttons stack on mobile.

### Spacing Sync Fields Are Strings, Not Booleans

`syncVertical` and `syncHorizontal` must be the string `"on"` or `"off"`, not `true`/`false`:

✅ `"padding": {"top": "1rem", "bottom": "1rem", "syncVertical": "on", "left": "2rem", "right": "2rem", "syncHorizontal": "on"}`
❌ `"padding": {"top": "1rem", "syncVertical": true}` — booleans silently ignored

### `divi/blurb` Without Icon/Image Source
If `imageIcon.innerContent.desktop.value.src` is an empty string `""` (with `useIcon` off), Divi renders a blank space above the title. Either provide a valid image URL, set `"useIcon": "on"` + an `icon` object, or omit the `imageIcon` block entirely to render title+text only. See MODULES-CONTENT `divi/blurb` for the full image-vs-icon toggle.

---

## 8. Validation Checklist

**Root structure:**
- [ ] `"context": "et_builder"` present
- [ ] `"data"` has one key (integer string), value is plain string

**Content string:**
- [ ] Starts with `<!-- wp:divi/placeholder -->`
- [ ] Ends with `<!-- /wp:divi/placeholder -->`
- [ ] Every section → row → column chain is intact

**Modules:**
- [ ] Every module has `"builderVersion": "5.7.4"`
- [ ] Every container has matching close tag
- [ ] Every self-closing ends with ` /-->`
- [ ] `flexColumnStructure` count matches actual column count
- [ ] Mobile breakpoints set for columns + row `flexWrap: "wrap"`

**Content:**
- [ ] Heading `title.innerContent` is plain text
- [ ] Rich text uses `\u003c` / `\u003e` encoding
- [ ] Blurb title uses `{"text": "..."}` object format
- [ ] Button uses `linkUrl` / `linkTarget`
- [ ] Variable refs include `"settings": {}`
- [ ] No `groupPreset` keys

---

## 9. Authoring Self-Audit Gate (run BEFORE deploying a page)

The validation checklist (§8) catches *structural* errors. This gate catches
*authoring-quality* failures — the "why did it build like that" problems. **Do not
deploy until every line passes.** A failure here means rework, not a warning.

- [ ] **Real modules, not code.** `divi/code` count ≈ 0 — present ONLY for genuine
  custom SVG art / third-party embeds. No trust bar, quote, stat, icon, link, list,
  or card is faked with `divi/code`. (Rule 14.)
- [ ] **No shared stylesheet.** The page ships zero global `<style>` blocks; all
  styling is module `decoration` + tokens.
- [ ] **Variables honoured per the gate.** If the site has the variables (or the
  user opted to generate them), every color/size/width/spacing/radius references a
  token — a stray literal is a defect. If the user opted OUT, inline literals are
  fine and consistent. (Rule 15 + DESIGN-PROCESS variable-availability gate.)
- [ ] **Copy is verbatim.** On-page text matches the source/reference exactly — no
  paraphrasing. (DESIGN-PROCESS verbatim-copy rule.)
- [ ] **Contrast checked.** Every text/icon has adequate contrast on its actual
  background (incl. *dark cards* — titles/meta/icons must use light tokens, not the
  light-bg colours). No element relies on an **undefined** `var()` (an unmapped
  token on `color`/`stroke`/`fill` silently renders nothing). Spot-check dark
  sections specifically.
- [ ] **Tokens resolve.** Every `gcid-*`/`gvid-*` used actually exists in the
  site's design system (don't invent token names); recolor/alias helpers map every
  variant incl. `-mid`/`-soft`/`-deep`.
- [ ] **Module-specific shapes correct.** Standalone button styling on
  `button.decoration`; hover nested inside the breakpoint; blurb title as
  `{"text":...}`; heading `innerContent` plain text; absolute position anchored by a
  `relative` parent with **top-left** origin (not center — center adds a
  translate that shifts the whole element). (STYLING §7c/§8.)

---

*DIVI5 Base Skill — V0.5.1 | Builder Version 5.7.4 | Created by Shashank Gupta @ divilove.com*
