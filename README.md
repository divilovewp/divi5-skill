# DIVI5 Skill Files

Modular skill files for generating Divi 5 page layouts via JSON.

📖 **New here? Start with the [Wiki](docs/wiki/Home.md)** — what this is, how to attach
it to Claude, building a page, publishing live, module coverage, and contributing.

Created and maintained by **Shashank Gupta** ([@shashankgupta-dev](https://github.com/shashankgupta-dev))
of [divilove.com](https://divilove.com).

Licensed under the [MIT License](LICENSE).

## Files

| File | When to attach |
|------|---------------|
| `DIVI5-BASE.md` | **Always** — core rules, nesting, common mistakes, validation |
| `DIVI5-DESIGN-PROCESS.md` | **Always** — *ask, then think*: asks focused discovery questions, then plans the page (intent, narrative, blueprint, design system, self-critique) before generating JSON |
| `DIVI5-LAYOUT.md` | Building page structure (section/row/column/group) + **Grid layout** + global-layout |
| `DIVI5-STYLING.md` | Styling any module (backgrounds, **gradients + gradient variables**, spacing, border, typography, **text effects: gradient/image fill + stroke**, **aspect-ratio**, **framing**, variables, pseudo-classes) |
| `DIVI5-MODULES-CONTENT.md` | heading, text, button, image, blurb, CTA, testimonial, team-member, link, icon, divider, code, fullwidth-header, **svg, timeline, breadcrumbs** |
| `DIVI5-MODULES-INTERACTIVE.md` | accordion, toggle, tabs, contact-form, signup, **dropdown, contact-form-7**, interactions |
| `DIVI5-MODULES-MEDIA.md` | video, gallery, slider, video-slider, lottie, audio, before-after-image |
| `DIVI5-MODULES-DATA.md` | counters, pricing tables, social, **table-of-contents, instagram-feed**, misc |
| `DIVI5-MODULES-DYNAMIC.md` | **(new)** blog, portfolio, post*, menu, search, login, sidebar, comments, map + **Loop Builder** |
| `DIVI5-MODULES-WOOCOMMERCE.md` | **(new)** shop, single-product, cart & checkout modules |
| `DIVI5-WORDPRESS.md` | Creating pages programmatically via REST API |
| `DIVI5-PRESETS.md` | Global Presets — storage format, attrs key paths, REST endpoint, Python helpers |
| `DIVI5-CONNECT.md` | **(new)** Divi Connect plugin workflow — read design system, create pages live, manage tokens |
| `DIVI5-PATTERNS.md` | Real-world layout patterns + Python generation helpers |
| `DIVI5-COVERAGE.md` | What is confirmed, source-verified, and untested |
| `DIVI5-ANIMATION.md` | Motion — entrance animation, scroll effects, sticky, transform/transition (community: @spetrum) |
| `DIVI5-CUSTOM-MODULES.md` | Building your own Divi 5 module — hooks, module.json, the five module types (community: @MDHMatt) |

## Typical combinations

> **Always attach BASE + DESIGN-PROCESS.** DESIGN-PROCESS makes the model **ask focused discovery questions first** (including whether the user wants live-site mode via Divi Connect plugin), then plan the page before writing JSON.

**Build a landing page — JSON output only:**
BASE + DESIGN-PROCESS + LAYOUT + STYLING + MODULES-CONTENT + PATTERNS

**Build and publish live via Divi Connect plugin:**
BASE + DESIGN-PROCESS + CONNECT + LAYOUT + STYLING + MODULES-CONTENT + PATTERNS

**Build and import manually via REST API / WP-CLI:**
BASE + LAYOUT + STYLING + MODULES-CONTENT + WORDPRESS + PATTERNS

**Add interactive sections:** + MODULES-INTERACTIVE
**Add media/video sections:** + MODULES-MEDIA
**Add pricing or counters:** + MODULES-DATA
**Build blog / portfolio / Theme Builder templates:** + MODULES-DYNAMIC
**Build a WooCommerce store:** + MODULES-WOOCOMMERCE

## Version

> Full change history — including documentation corrections made within a version — is in [CHANGELOG.md](CHANGELOG.md).

**V0.7.1 — Builder Version 5.16.0**

**`divi/charts` now draws.** The data shape earlier versions documented — a flat list of rows, header first —
stores cleanly and renders an empty box; measured on Divi 5.16.0, the canvas never painted a pixel. The stored
shape is an object of `columns` (each with a string `label` and a `role`) and `rows` of `{"cells": [...]}`,
and the roles a chart type needs differ by family (MODULES-DATA). Two new topics: **`DIVI5-ANIMATION.md`** —
entrance animation, scroll effects, sticky, transform/transition and their traps — and
**`DIVI5-CUSTOM-MODULES.md`** — writing your own Divi 5 module. `divi/gallery` images can be set by attachment
id. Every change was verified on Divi 5.16.0 before it was merged; three came from the community (@MDHMatt,
@spetrum). See [CHANGELOG.md](CHANGELOG.md).

**V0.7.0 — Builder Version 5.16.0**

Covers what Divi 5.12–5.16 added to authoring, each one render-confirmed on Divi 5.16.0 against the same page
without it: **Show Labels** on the contact form (5.13), signup and comments (5.13.1); the **collapsible mobile
menu** (5.16); **swipe controls** — slide count, progress bar, swipe label — on Slider (5.12.1) and Post Slider
(5.13.1); the **Shop pagination** text style; and **interactions on Timeline**. Also in this release: the
`DIVI5-PAGE-FROM-HTML.md` topic (design the page as HTML first, look at it, then compose), section dividers,
icon alignment, the contact-form CAPTCHA switch, gradient stops that follow colour variables, and more — see
[CHANGELOG.md](CHANGELOG.md). Not yet covered: the 5.15 Components **Slot** module (`divi/global-slot`).

**V0.6.9 — Builder Version 5.11.1**

A design's font sizes are now a question the skill asks, not a guess. The reference ladder in
`DIVI5-CONNECT.md` taught that vision can never recover measurements — right for a photo of a
screen, and **wrong for a vector PDF exported from Figma** (real point sizes are in the file) and
for **a screenshot whose canvas width the user states** (which gives a scale factor). Those two
become a fourth rung of their own, separated from the genuinely unmeasurable case. With the sizes
knowable, CONNECT gains a **font-size gate**: ask one question, wait, then pass `size_policy`
— `exact` | `snap` | `presets` — to `divi_build_page`, and always relay which one was used. The
gap it closes is large: a heading a design states at 48px can arrive at **86px** when a fluid
preset scale decides instead. `DIVI5-DESIGN-PROCESS.md` §12 step 1 now names
`size_policy.summary` beside `warnings[]`, because a build can return "success" having quietly
discarded every size the design stated. Same Divi 5.11.1 authoring schema.
See [CHANGELOG.md](CHANGELOG.md).

**V0.6.8 — Builder Version 5.11.1**

Divi 5.11's four new modules — **`divi/charts`**, **`divi/gravity-forms`**,
**`divi/imagely-gallery`**, **`divi/payment-button`** — each render-verified on 5.11.1 and
documented with the trap that makes it store cleanly and render nothing (Charts wants the
header row first; Gravity Forms is `gravityForm.innerContent…formId`, not the CF7 path;
Imagely's key is `galleryId`, not `item`; Payment Button's `environment` **defaults to
`"sandbox"`**). Also a correction, not an addition: Divi now has a **native `backdrop-filter`
control** (STYLING §7f), so the Custom CSS workaround §9b used to teach is retired.
`builderVersion` examples move to 5.11.1. See [CHANGELOG.md](CHANGELOG.md).

**V0.6.7 — Builder Version 5.10.1**

Retarget to Divi 5.10.1 plus a corrected breakpoint model. 5.10.0/5.10.1 add no new authoring
schema, so the substance is a fix to this documentation: **`phoneWide` was described as
480–767px and used as the mobile breakpoint throughout, when 480–767px is `phone` and
`phoneWide` ships disabled and emits no CSS at all.** Every responsive example written from
those snippets silently lost its mobile rules; all ten now target `phone`, and §6 of
DIVI5-BASE carries the render-verified ladder. Also corrected before release: a `divi/menu`
without `menuId` does not render an empty bar — it falls back to listing **every published
page** (and ignores Appearance → Menus locations), which is exactly how "my menu isn't
showing" happens. See [CHANGELOG.md](CHANGELOG.md).

**V0.6.6 — Builder Version 5.9.0**

Correctness release (same Divi 5.9.0 authoring schema). Fixes two silently-failing rules that shipped in 0.6.5 and earlier: **`text-transform` is produced only by `capitalization`** (the legacy `style:["uppercase"]` stores cleanly and emits nothing), and **`htmlAttributes` puts the breakpoint outermost** — `htmlAttributes.desktop.value.{id, class}`, not `htmlAttributes.id.desktop.value`, which renders no `id` at all so in-page `#anchor` links go nowhere. Also settles rich-text escaping in one place (**raw HTML, never pre-escaped**), documents the native **Sizing → Alignment** control (`module.decoration.sizing.{bp}.value.alignSelf`) in place of the old `sizing.alignment` preset path, and corrects font-variable references to `{"type":"content"}`. Adds DESIGN-PROCESS §11b/§8c, CONNECT §5 (match a reference), PRESETS §1b, and an Adobe Typekit / non-Divi fonts section.

**V0.6.5 — Builder Version 5.9.0**

Shipped only inside the Divi Connect plugin bundle — there was no repo release or download at this version. Documented rich-text content as **raw HTML, never pre-escaped** (a JSON `\uXXXX` escape survives the MCP transport verbatim) and switched non-ASCII typography to numeric HTML entities. Folded into V0.6.6 above.

**V0.6.4 — Builder Version 5.9.0**

Documentation/patterns release (same Divi 5.9.0 authoring schema). Documents the Divi Connect **section-pattern library** — 28 ready-made, mostly-native section patterns (hero, pricing, testimonials, stats, FAQ, team, timeline, gallery, comparison, tabs, slider, blog, portfolio, contact, before/after and more) plus the `divi_list_patterns` discovery tool and the `divi_build_page` fidelity primitives (background-image overlays, badges, tilt, variable fonts). See `DIVI5-CONNECT.md`.

**V0.6.3 — Builder Version 5.9.0**

Tracks the **Divi 5.9.0** line. Adds the Divi 5.9.0 **Grid Editor** (`gridOffsetRules` — container-driven per-item grid placement; `DIVI5-LAYOUT.md` §5b) and rolls up doc improvements (an "avoid AI-design clichés" section, render-verified community gotchas).

**V0.6.2 — Builder Version 5.8.1**

Maintenance/metadata release (no authoring-schema change). Made the skill `description` version-agnostic so it no longer names a specific Divi patch (it had gone stale at "5.7.x"); the skill already targets the Divi 5.8.x line.

**V0.6.1 — Builder Version 5.8.1**

Tracks the current **Divi 5.8.x** line (latest **5.8.1**). Adds two real authoring additions, both render-confirmed on 5.8.1: the **Tooltip module** (`divi/tooltip` — hover/click/always popover that attaches to its parent module) and the **Advanced Text Styling** batch on every font group — **variable fonts** (weight fine-tune + arbitrary OpenType axes incl. Roboto Flex parametric & Bitcount custom axes + optical sizing), capitalization/small-caps, decoration-line styling, text columns, drop caps, vertical text direction, line-wrap, hyphenation, paragraph/list spacing, and stroke position. See `DIVI5-STYLING.md` §7e/§7b and `DIVI5-MODULES-INTERACTIVE.md`.

**V0.5.1 — Builder Version 5.7.4**

Tracked the **Divi 5.7.x** line (latest **5.7.4**). Patches 5.7.1–5.7.4 were maintenance/bug-fix releases — **no new authoring schema**, so only the `builderVersion` stamp moved to `"5.7.4"`. Authoring features unchanged from V0.5.0 below.

**V0.5.0 — Builder Version 5.7.0**

Updated from v0.4.0 (Divi 5.6.2) to Divi **5.7.0**. Added **text fill effects** (gradient text fill, image text fill, text stroke — `font.textEffects`), **gradient variables** (reusable global gradient tokens), and the **expanded gradient model** (conic/elliptical types, `directionRadial`, `repeat`, `length`). See `DIVI5-STYLING.md` §1, §7b, §10.

**V0.4.0 — Builder Version 5.6.2**

Updated from v0.3.0 (Divi 5.0.x/5.1.0) to Divi **5.6.2**. Added new modules (svg, timeline, breadcrumbs, table-of-contents, instagram-feed, dropdown, contact-form-7), new systems (Grid layout, aspect-ratio, image framing, Loop Builder, form pseudo-class states, variable generators, global-layout), and two new module families (dynamic content + WooCommerce).

> Entries marked **⚙ source-verified** are extracted from the Divi 5.6.2 theme source but not yet confirmed via the real-render skill loop. Everything else was real-render tested at 5.0.x and remains valid. See `DIVI5-COVERAGE.md`.
