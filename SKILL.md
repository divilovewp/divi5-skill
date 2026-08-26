---
name: divi5-skill
description: Generate Divi 5 page layouts as valid builder JSON/markup — sections, rows, modules, styling, presets, gradients, dynamic content, and WooCommerce. Use when the user asks to build, design, or generate a Divi 5 page, layout, section, module, Theme Builder template, or global preset, or to publish one live to a WordPress site via the Divi Connect plugin or REST API. Covers the full Divi 5 authoring schema, the token/variable system, and a design process that asks discovery questions before generating.
---

# Divi 5 Skill

Build Divi 5 page layouts as valid builder markup. The skill is **modular**: this
file routes to focused reference files — read only the ones a task needs.

## 🚦 MANDATORY workflow for building a page (do NOT skip)

Building a page is a **gated, multi-step** process. Do **not** jump straight to
markup or call `divi_create_page` / `POST /pages`.

**▸WAIT means: end your message and wait for the user's actual reply.** Do NOT ask
questions and then answer them yourself, and do NOT continue to the next step in
the same turn. Ask → **stop** → let the user respond → then continue. This is the
#1 thing models get wrong here — you must genuinely pause.

1. **▸WAIT — Connection mode.** Ask: live site (Divi Connect) or JSON only? If
   live, get the site URL + API key and call `/design-system` to load real tokens.
   (Skip if obvious from context.)
2. **▸WAIT — Discovery (almost always required).** Ask a focused, batched set of
   questions — goal/offer, audience, key sections, brand/tone, must-have content,
   primary CTA (~4–6, each with a sensible default), then **STOP and wait.**
   A short or generic brief is **not** enough to skip this — e.g.
   *"create a page for a business mentor"* tells you nothing about the offer,
   audience, sections, or CTA, so you **MUST ask first**, not guess.
   **Only skip discovery if** the user gave genuinely detailed requirements OR
   explicitly said "just go / just build it."
3. **▸WAIT — Page Plan + approval.** Present a concise written **Page Plan**
   (intent → narrative → section blueprint → which design-system tokens map to
   what) and a one-line self-critique. Then **explicitly ask the user to approve
   or change it, and STOP. Do NOT generate markup or create the page until they
   approve.** If they give feedback, revise, re-present, and ask again — iterate
   until approved.
4. **Build.** Only after approval: generate the markup (using real tokens), then
   create the page (live mode) and return the URL. After creating, the user can
   still ask for changes — apply them (edit/recreate) and re-confirm.

> This is the core value of the skill — the plan is the thinking; the markup is
> just transcription. Full method: **`DIVI5-DESIGN-PROCESS.md`** (read it).
> The ONLY bypass: the user explicitly says "just build it / just go" — then
> proceed with **stated assumptions**, still showing a 2-line plan first.

## Reference files to read while building
- **Always:** `DIVI5-BASE.md` (rules/validation) + `DIVI5-DESIGN-PROCESS.md` (the workflow above).
- **Live publish:** `DIVI5-CONNECT.md` (design-system tokens, create page).
- **Modules/styling:** the feature files in the table below.
- Generate markup with real design tokens; validate against BASE before creating.

## ⚠️ CRITICAL block-markup rules (these cause silently BLANK pages)

Read these even if you read nothing else. The Divi Connect server-side validator
rejects pages that break rules 1-3, so getting them right avoids a failed call.

1. **NEVER wrap module attributes in `attrs`.** The JSON after a block name *is*
   the attributes object — put `title`/`content`/`module`/`builderVersion` at the
   **top level**.
   ❌ `<!-- wp:divi/heading {"attrs":{"title":{...}}} /-->` → renders EMPTY
   ✅ `<!-- wp:divi/heading {"title":{...},"builderVersion": "5.11.1"} /-->`
   (`attrs` is only a key in **preset** definitions — never in module blocks.)

2. **`divi/text` content key is exactly `content`** — never `body` or `text`.
   ❌ `"body":{...}` or `"text":{...}` → renders EMPTY
   ✅ `"content":{"innerContent":{"desktop":{"value":"<p>Hello.</p>"}}}`
   (`body` only exists as the `bodyFont` styling group.)

3. **HTML in a `value` is passed RAW** (`<p>`, `<strong>`) -- never pre-escape it.
   ❌ `"value":"&lt;p&gt;Hello.&lt;/p&gt;"`   ✅ `"value":"<p>Hello.</p>"`
   Also write **non-ASCII** typography as numeric HTML entities (em-dash `&#8212;`, curly quotes `&#8217;`/`&#8220;`/`&#8221;`), OR use plain ASCII (`-`, straight quotes). The claude.ai connector corrupts raw multibyte characters, and a JSON `\uXXXX` escape survives the transport verbatim so the visitor reads it literally.

4. Every module needs `"builderVersion": "5.11.1"`. Self-closing modules end ` /-->`.
   Wrap the whole page in `<!-- wp:divi/placeholder --> ... <!-- /wp:divi/placeholder -->`.

Full detail + all other pitfalls: read `DIVI5-BASE.md`.

## ⚠️ When connected to a live site (Divi Connect / MCP)

After calling `divi_get_design_system`, you MUST build with its tokens:
- Use the exact `token` string (the whole `$variable(...)$`) for **every color AND size** — font sizes, spacing, padding/margin, gaps, radius — not just colors. Don't hardcode a value when a matching token exists (**headings are the #1 offender — never hardcode heading sizes**).
- **Never invent** a `gvid-`/`gcid-` ID. Only use IDs returned by `/design-system` (no `gcid-primary`, `gcid-heading`, `gvid-h1`, etc. unless that exact id was returned). Invented IDs render as nothing.
- Match by `label` (e.g. `H1 Desktop`, `Section Gap`). Hardcode only when no token exists.
Detail: `DIVI5-CONNECT.md` §3.

## Reference files

| File | When to read |
|------|---------------|
| `DIVI5-BASE.md` | **Always** — core rules, nesting, validation, common mistakes |
| `DIVI5-DESIGN-PROCESS.md` | **Always** — discovery questions + page planning before JSON |
| `DIVI5-CONNECT.md` | Publishing live via the Divi Connect plugin (read design system, create pages, manage tokens) |
| `DIVI5-WORDPRESS.md` | Creating pages programmatically via REST API / WP-CLI |
| `DIVI5-LAYOUT.md` | Page structure (section/row/column/group), Grid layout, global-layout |
| `DIVI5-STYLING.md` | Backgrounds, gradients + gradient variables, spacing, border, typography, text effects, aspect-ratio, framing, variables, pseudo-classes |
| `DIVI5-MODULES-CONTENT.md` | heading, text, button, image, blurb, CTA, testimonial, team, icon, divider, code, fullwidth-header, svg, timeline, breadcrumbs |
| `DIVI5-MODULES-INTERACTIVE.md` | accordion, toggle, tabs, contact-form, signup, dropdown, contact-form-7, interactions |
| `DIVI5-MODULES-MEDIA.md` | video, gallery, slider, video-slider, lottie, audio, before-after-image |
| `DIVI5-MODULES-DATA.md` | counters, pricing tables, social, table-of-contents, instagram-feed |
| `DIVI5-MODULES-DYNAMIC.md` | blog, portfolio, post modules, menu, search, login, sidebar, comments, map, Loop Builder |
| `DIVI5-MODULES-WOOCOMMERCE.md` | shop, single-product, cart & checkout modules |
| `DIVI5-PRESETS.md` | Global Presets — storage format, attrs key paths, REST endpoint, helpers |
| `DIVI5-PATTERNS.md` | Real-world layout patterns + Python generation helpers |
| `DIVI5-COVERAGE.md` | What is confirmed, source-verified, and untested |
| `DIVI5-CUSTOM-MODULES.md` | Building custom Divi 5 modules — file structure, PHP/JS registration hooks, module.json schema, all 5 module types |

## Typical combinations

> Always start with **BASE + DESIGN-PROCESS**.

- **Landing page (JSON only):** BASE + DESIGN-PROCESS + LAYOUT + STYLING + MODULES-CONTENT + PATTERNS
- **Build and publish live (Divi Connect):** + CONNECT
- **Import via REST API / WP-CLI:** + WORDPRESS
- **Interactive sections:** + MODULES-INTERACTIVE
- **Media/video:** + MODULES-MEDIA
- **Pricing / counters:** + MODULES-DATA
- **Blog / portfolio / Theme Builder:** + MODULES-DYNAMIC
- **WooCommerce store:** + MODULES-WOOCOMMERCE
- **Building a custom module:** BASE + CUSTOM-MODULES

## Version

**V0.6.9 — Builder Version 5.11.1** (tracks the Divi 5.11.x line). The
`builderVersion` stamp on generated markup should match your site's Divi version
(`"5.11.1"` on current installs; older values still import via backward-compat).
🆕 **v0.6.9 makes a design's font sizes a question, not a guess** — a vector PDF
exported from Figma, or a screenshot whose canvas width the user states, DOES carry exact
type sizes, so the reference ladder gains a fourth rung and a **font-size gate**: ask once,
then pass `size_policy` `exact` | `snap` | `presets` to `divi_build_page` and relay which
one was used. See DIVI5-CONNECT §"Match a reference".
🆕 **v0.6.8 covers Divi 5.11's four new modules** — `divi/charts`,
`divi/gravity-forms`, `divi/imagely-gallery`, `divi/payment-button` — and its **native
`backdrop-filter` control**, which replaces the Custom CSS workaround earlier versions of
this Skill taught. See DIVI5-BASE §0.
🚨 **v0.6.7 fixed a breakpoint error that made mobile styling silently do nothing:**
`phoneWide` is **disabled by default and emits no CSS** — use `phone`. See DIVI5-BASE §6.
v0.6.6 is a correctness release (same 5.9.0 schema). It fixes two rules that were
wrong in every copy downloaded at 0.6.5 or earlier, both of which fail *silently*:
**`text-transform` comes only from `capitalization`** (the legacy `style:["uppercase"]`
stores cleanly and emits nothing), and **`htmlAttributes` takes the breakpoint
outermost** — `htmlAttributes.desktop.value.{id, class}`, not `htmlAttributes.id.
desktop.value`, which renders no `id` at all so in-page `#anchor` links go nowhere.
It also settles rich-text escaping in one place (**raw HTML, never pre-escaped**) and
documents the native **Sizing → Alignment** control
(`module.decoration.sizing.{bp}.value.alignSelf`), which supersedes the old
`sizing.alignment` preset path. Adds DESIGN-PROCESS §11b (post-build polish pass) and
§8c (landing-page heuristics), CONNECT §5 (match a reference), PRESETS §1b (the
four-level preset model), and an **Adobe Typekit / non-Divi fonts** section (STYLING).
v0.6.5 shipped only inside the Divi Connect plugin bundle — never as a repo release or
download — so its notes are folded in here: rich-text content is documented as raw
HTML because a JSON `\uXXXX` escape survives the MCP transport verbatim (the old
guidance put literal `\u003cp\u003e` on the page), and non-ASCII typography uses
numeric HTML entities (`&#8212;`) for the same reason.
v0.6.4 is a documentation/patterns release (same 5.9.0 schema): it documents the
Divi Connect **section-pattern library** — 28 ready-made, mostly-native section
patterns (hero, pricing, testimonials, FAQ, timeline, gallery, comparison, and
more) plus the `divi_list_patterns` discovery tool and the `divi_build_page`
fidelity primitives (background-image overlays, badges, tilt, variable fonts). v0.6.3
added the Divi 5.9.0 **Grid Editor** (`gridOffsetRules`; LAYOUT §5b) and an "avoid
AI-design clichés" section. v0.6.0 added the **Tooltip module** + the **Advanced
Text Styling** batch. See `DIVI5-COVERAGE.md` for what is
real-render tested vs source-verified.
