# Changelog

All notable changes to the **Divi 5 Skill** are recorded here.
The format is loosely based on [Keep a Changelog](https://keepachangelog.com/).

**Versioning:** the skill version tracks the Divi Builder schema it targets (see
the `## Version` section in [README.md](README.md) and the `builderVersion` stamp
in [SKILL.md](SKILL.md)). The version is bumped only when the **authoring schema**
changes. Documentation corrections and clarifications that don't change the schema
are logged under **Unreleased** and ship within the current version without a bump.

## [Unreleased]

- **DIVI5-CONNECT.md:** documented Divi Connect v1.7.4's section-pattern library and the `divi_list_patterns`
  discovery tool, with an "assemble a page by naming patterns first" nudge (free-form a raw section only when
  no pattern fits). Tier-1: `split` (case-study L/R), `pricing`, `testimonial`, `stats`. Tier-2: `faq`
  (native accordion), `team` (native person cards), `logo-strip`, `bento`, and a `cta` banner variant
  (bg_image + overlay). Tier-3: `feature-list`, `timeline` (native timeline module), `gallery`,
  `comparison` (feature table), `newsletter` (email-capture split). These use purpose-built native
  modules where they fit — gallery = native gallery module, timeline = native timeline, newsletter =
  native email opt-in (signup). Tier-4 (all native modules): `tabs`, `slider`, `social-follow`, `blog`
  (real posts), `portfolio` (real projects), `video`, `countdown`, `skills` (bar/circle counters),
  `contact` (working form), `map`. 27 patterns total. Docs-only, no version bump.
- **DIVI5-CONNECT.md:** documented Divi Connect v1.7.3's `divi_build_page` fidelity primitives
  (background image + overlay on sections/columns, the `badge` module, `rotate`/`scale` tilt, and
  variable-font axes) as an "editorial / premium looks" subsection, plus a "Design nudges" note under
  Build guardrails (the non-blocking slop warnings that point back to DESIGN-PROCESS §8b). Field-level
  detail stays in the tool's own description; the Skill just steers when to reach for them. Docs-only,
  no version bump.

## [0.6.3] — 2026-07-10 · Divi Builder 5.9.0

**Divi 5.9.0 line.** One new authoring feature + a roll-up of doc improvements.
`builderVersion` stamp moves to `"5.9.0"` (older values still import via backward-
compat; the connector auto-stamps the site's installed version regardless).

- **NEW (Divi 5.9.0) — Grid Editor / `gridOffsetRules`:** container-driven per-item
  grid placement, documented in **DIVI5-LAYOUT.md §5b** + **DIVI5-COVERAGE.md**.
  Set `gridOffsetRules:{rules:[…]}` on a `display:"grid"` container's `layout` to
  place children by position (`first-child`/`last-child`/nth/`custom`) via
  `columnStart`/`columnEnd`/`columnSpan` + `rowStart`/`rowEnd`/`rowSpan`. **Render-
  confirmed on local Divi 5.9.0 (page 983):** `columnSpan:"2"` → `:nth-of-type(1)
  {grid-column-end:span 2}`; `rowSpan:"2"` on `last-child` → `:last-of-type
  {grid-row-end:span 2}`. Offset values also accept number-variable (`gvid-`) tokens
  (source-noted). (Divi 5.9.0 added no new modules — same 84 as 5.8.x.)
- **DIVI5-CONNECT.md:** added a "Create a Portfolio PROJECT" section covering Divi
  Connect v1.7.0's project (Portfolio CPT) support — `divi_create_project`, that
  all id-based tools accept a project id, and the **clone-a-reference-project →
  edit** workflow for a consistent case-study look.
- **Community contributions from @MDHMatt** (render-verified against live front-end
  renders; reviewed + re-checked on Divi 5.9.0 before merge):
  - **DIVI5-WORDPRESS.md** (#1): warn that `page-template-blank.php` suppresses
    Theme Builder chrome — use the `default` template + `_et_pb_page_layout:
    et_full_width_page` for full-width pages *with* a TB header/footer, plus the
    three wiring conditions for imported TB layouts.
  - **DIVI5-MODULES-MEDIA.md / KNOWN-CAVEATS.md** (#2): document the stale
    `_divi_dynamic_assets_cached_modules` post-meta that stops slider/animation/
    scroll/sticky/TOC scripts from enqueuing on programmatically-imported pages.
  - **DIVI5-STYLING.md / DIVI5-PRESETS.md** (#3): `boxShadow` needs a `style` key
    or it emits no CSS; gradient/image text-fill can render invisible on
    `divi/heading` (positioned container paint layer); and a preset-store note
    (`_d5` created lazily, full `divi/<type>` buckets, CSS gated on `attrs`).
- **DIVI5-DESIGN-PROCESS.md §8b "Avoid AI-design clichés":** a tight, Divi-specific
  do/don't table (the "AI default" cream+serif+terracotta reflex, rainbow gradients,
  emoji-as-UI, left-border cards, Inter-everywhere, dead interaction states,
  decoration-as-crutch) + a "3-brands test" + a matching Self-Critique checkbox.
  Framed around **grounding in the real brand/tokens**, not banning any one style
  (so it never fights a genuinely warm/editorial brand). Addresses beta design-
  quality feedback.

## [0.6.2] — 2026-07-05 · Divi Builder 5.8.1

No authoring-schema change (`builderVersion` stays `"5.8.1"`). Maintenance/metadata release:

- Made the skill `description` **version-agnostic** — it had gone stale reading "Divi Builder 5.7.x"
  while the skill targets the Divi 5.8.x line. Removed the hardcoded patch from the description so it
  won't rot on future Divi updates. No content/schema change.

## [0.6.1] — 2026-07-01 · Divi Builder 5.8.1

No authoring-schema change (`builderVersion` stays `"5.8.1"`) — this release syncs the
**Divi Connect live-site docs** to the plugin's v1.6.5 behaviour and adds a real-world pattern.

### Changed
- **`DIVI5-CONNECT.md` — post-creation mode synced to Divi Connect v1.6.5.** Divi-builder posts
  are now **auto-detected** (send Divi markup → the plugin sets `_et_pb_use_builder` for you);
  `"builder":"divi"|"gutenberg"` documented as an explicit override rather than a "verify in review"
  TODO. Documented the **VB-wipe-on-save fix**: `divi_get_page` now returns `mode` + `needs_builder_repair`,
  and editing an older broken post auto-repairs it (with a graceful fallback for plugin <1.6.5).

### Added
- **`DIVI5-CONNECT.md` — `divi_duplicate_page` + `divi_list_pages`** (Divi Connect v1.6.5+): clone a
  page/post into a draft (content + meta + featured image + taxonomies) and resolve a page by name → id,
  with the clone-then-edit flow.
- **`DIVI5-PATTERNS.md` — Off-canvas mobile menu (hamburger drawer)** built from native Divi Interactions
  + `disabledOn` responsive hiding (no Canvas / no code module), with wiring and the known tradeoffs
  (instant show/hide, no backdrop). Live-verified on the divilove.com Theme-Builder header.

## [0.6.0] — 2026-06-30 · Divi Builder 5.8.1

Tracks the **Divi 5.8.x** line (5.8.0 + 5.8.1). Two new authoring additions, both
render-confirmed on local Divi 5.8.1 (page 276). `builderVersion` stamp moved to `"5.8.1"`.

### Added
- **Tooltip module (`divi/tooltip`)** (`DIVI5-MODULES-INTERACTIVE.md`): hover / click /
  always-on popover that **attaches to its parent module** (emits `data-et-tooltip-parent-id`).
  Documented `module.advanced.tooltip` config (trigger, positionMode anchored/followCursor,
  placement grid, skid/distance, open/close delays, showArrow + arrowColor/placement/offset/size)
  and bubble styling. Render-confirmed: SSR markup + `trigger:"always"` visible without JS;
  script-dependent for hover/click and final (floating-ui) placement.
- **Advanced Text Styling — §7e** (`DIVI5-STYLING.md`): the 5.8.0 batch on every font group —
  **variable fonts** (`weight:"variable"`, `weightFineTune`, `variationSettings` for any OpenType
  axis incl. Roboto Flex parametric `GRAD`/`YOPQ`/`XOPQ`/`XTRA`/`YTLC`/`YTUC`/`YTAS`/`YTDE`/`YTFI`
  and Bitcount `ELSH`/`ELXP`, `opticalSizing`), **capitalization/small-caps**, **decoration-line
  styling** (`overline` + `lineColor`/`lineStyle`/`lineThickness`/`underlineOffset`), **text
  columns** (`columnCount`/`columnGap`/`columnRule*`), **drop caps** (dedicated `bodyFont.dropCap`
  group → `::first-letter`), **vertical text** (`writingMode`), **line-wrap** (`textWrap`) +
  **hyphenation** (`hyphens`), and **paragraph/list spacing** (`bodyFont.body.list`). All
  render-confirmed (CSS + visual).
- **Stroke position** (`DIVI5-STYLING.md` §7b): `textEffects.strokePosition` → `paint-order`.

### Notes / gotchas
- Text columns do **not** auto-stack on mobile — set a responsive `columnCount:"1"` (like the grid rule).
- Variable-font *visual* interpolation needs the chosen family to be an actual variable font (Divi 5.8
  ships them via Google Fonts); the authoring CSS emits regardless.

## [Unreleased] — corrections within 0.5.1 (Divi 5.7.4)

### Fixed
- **Gradient variables** (`DIVI5-STYLING.md` §10): corrected the stored shape. A
  `gradients` global variable's `value` is **not** a CSS gradient string and not a
  bare settings object — Divi's sanitizer forces it to a scalar, so it must be a
  `$variable(...)$` payload string embedding the settings, and `enabled:"on"` is
  required (a raw CSS string saves but renders nothing and shows empty in the
  Variable Manager). Documented the Divi Connect `POST /variables` object form
  (v1.6.2+) and the type→direction/position rule (linear/conic use `direction`;
  circular/elliptical use one of the 9 `directionRadial` named positions).
  _(2026-06-23)_
- **Divider** (`DIVI5-MODULES-CONTENT.md`): the `divi/divider` native line is
  `show:"on"` by default — recolor it via `divider.advanced.line`, don't add a CSS
  border (which stacks a visible double line). _(2026-06-23)_

### Added
- **`KNOWN-CAVEATS.md`**: consolidated, user-facing limitations of the skill
  (hard failures, not-covered, render gotchas, source-only/untested, version &
  scope), distilled from `DIVI5-COVERAGE.md`. _(2026-06-23)_
- **`history/`**: archived the earlier skill versions for transparency on how the
  skill evolved — 0.1.0, 0.2.0, 0.2.1-beta (single-file), and 0.3.0 (first multi-file
  split, provided both browseable under `history/v0.3.0/` and as `history/v0.3.0.zip`).
  Early "V1"/"V2" labels normalized to semantic 0.1.0/0.2.0. Third-party/client-site
  references removed; divilove.com brand attribution retained. 0.4.0 (5.6.2) and 0.5.0
  (5.7.0) were not archived — no standalone snapshots exist. _(2026-06-23)_

### Documentation
- **Gradient model unified** (`DIVI5-STYLING.md` §1): added the `overlaysImage`
  key, the direction-vs-position-by-type note, and made explicit that one gradient
  model is shared across module backgrounds, text-effects fills (§7b), and gradient
  variable `settings` (§10); backgrounds + gradients apply to nearly every module.
  _(2026-06-23)_
- **Image/block centering rule** (`DIVI5-MODULES-CONTENT.md`, `DIVI5-LAYOUT.md`):
  center a block module by setting the column's `layout.alignItems:"center"`, not
  image margins/alignment/text-align. _(2026-06-21)_
- **Chrome menu pattern** (`DIVI5-LAYOUT.md`) and a note on the Divi Connect live
  build/render tools (`DIVI5-CONNECT.md` §5: `divi_build_page` /
  `divi_get_rendered_page`, gated v1.6.0+). _(2026-06-21)_

## [0.5.1] — 2026-06-21 · Divi Builder 5.7.4

- Public release. Tracks the Divi 5.7.x line. Patches 5.7.1–5.7.4 were
  maintenance/bug-fix releases with **no new authoring schema**, so only the
  `builderVersion` stamp moved to `"5.7.4"` from 0.5.0.

## [0.5.0] — Divi Builder 5.7.0

- Added **text fill effects** (gradient/image text fill, text stroke —
  `font.textEffects`), **gradient variables** (reusable global gradient tokens),
  and the **expanded gradient model** (conic/elliptical types, `directionRadial`,
  `repeat`, `length`). See `DIVI5-STYLING.md` §1, §7b, §10.

## [0.4.0] — Divi Builder 5.6.2

- Added new modules (svg, timeline, breadcrumbs, table-of-contents,
  instagram-feed, dropdown, contact-form-7), new systems (Grid layout,
  aspect-ratio, image framing, Loop Builder, form pseudo-class states, variable
  generators, global-layout), and two new module families (dynamic content +
  WooCommerce).

## [0.3.0] — Divi Builder 5.0.x / 5.1.0

- **Earliest recorded version.** Foundational baseline of the skill: core Divi 5
  JSON authoring (block-markup structure — section / row / column / modules with
  the `builderVersion` stamp), the decoration / styling model, global color and
  variable tokens, and the initial module coverage. Built and real-render tested
  against Divi **5.0.x**, importable through **5.1.0**.

> No 0.1.0 / 0.2.0 entries exist — those predate the skill's recorded history and
> were superseded before this public lineage began. 0.3.0 is the historical floor.
