# Changelog

All notable changes to the **Divi 5 Skill** are recorded here.
The format is loosely based on [Keep a Changelog](https://keepachangelog.com/).

**Versioning:** the skill version tracks the Divi Builder schema it targets (see
the `## Version` section in [README.md](README.md) and the `builderVersion` stamp
in [SKILL.md](SKILL.md)). The version is bumped only when the **authoring schema**
changes. Documentation corrections and clarifications that don't change the schema
are logged under **Unreleased** and ship within the current version without a bump.

## [Unreleased] — corrections within 0.6.9 (Divi 5.11.1)

### Fixed — the `divi/charts` data shape, and the assertion that missed it

**MODULES-DATA described `data` as a flat list of rows with the header row first.** The stored
attribute is an object of `columns` + `rows`:

```json
"data": {
  "columns": [{"label": "Quarter", "role": "category"}, {"label": "Revenue", "role": "series"}],
  "rows":    [{"cells": ["Q1", "120"]}, {"cells": ["Q2", "180"]}]
}
```

Several separate requirements were missing, and each one on its own means no chart:

- **`label` must be present and a string**, or `_normalize_chart_columns` drops that column's
  `role` (it survives only inside `is_array($column) && isset($column['label']) &&
  is_string($column['label'])`) and the whole config becomes `null`. A **numeric** label is enough
  to do it. The Visual Builder coerces a non-string label to `""` and keeps the role, so this
  renders in the builder and is blank on the front end.
- **Every column needs an explicit `role`** — `category` · `value` · `series` · `x` · `y` ·
  `size`. `_get_column_roles()` collects only persisted roles from **visible** columns; there is no
  inference and no default.
- **Rows are `{"cells": [...]}` objects.** `_get_row_cells()` returns `[]` for a bare array and
  `_to_number(null)` yields `0`, so the chart draws with empty categories and zero values.
- **The required roles differ by chart-type family** — `categorySeries` (line/area/bar/radar),
  `categoryValue` (pie/doughnut/polarArea), `scatter`, `bubble`.
- **A non-array `rows` is a fatal**, not a blank chart: `count($rows)` is unguarded.
- **Nothing assigns colours at render time** — the Visual Builder bakes the palette into the
  persisted attrs while you edit, and the server-side palette is dead code. Hand-authored JSON with
  no `color` emits `backgroundColor: ""` / `borderColor: ""`.
- `chart.innerContent` and `chart.advanced.config` are **`responsive: false`** — the `{bp}` in the
  path table implied an axis that does not exist.
- `showLegendTitle` **defaults to `"off"`**, so setting `legendTitle` alone shows nothing. There is
  no axis/scale surface at all in 5.11.1. CSV import is a builder convenience that writes the same
  shape with no roles and no colours.

🪤 **Worth recording, because it is why this shipped as "✓ render-confirmed":** the entry asserted
that "`et_pb_charts` wrapper present and the title text rendered". Both are true of a chart that
draws nothing. `render_callback()` never consults the chart config — it always emits the wrapper
and a `<canvas … aria-label="{title}">`, so the **title string is in the markup whatever the data
says**. The data travels separately via `module_script_data()`, which calls `_build_chart_config()`
and **returns early, adding no script data**, when that returns `null`. The visible result is a
200 with an empty ~300px box; the `.et_pb_charts__error` div is only written when the builder is
running.

⇒ For this module the wrapper and the title are not evidence. Assert on the emitted `charts`
script-data payload. §`divi/charts` now says so.

(The same entry also said the title is "not in the accessibility tree". It is — the canvas carries
`role="img"` and the title as its `aria-label`. That line is corrected too.)

Read from `Packages/ModuleLibrary/Charts/ChartsModule.php` on Divi 5.11.1, plus
`_all_modules_default_render_attributes.php` for the registered defaults.

## [0.6.9] — 2026-08-26 · Divi Builder 5.11.1

**A design's font sizes are now a question the AI asks, not a guess.**

No Divi schema change — 5.11.1 throughout. This is a correction to the reference ladder plus the
workflow the correction makes possible, and it ships as a version bump because every copy
downloaded at 0.6.8 or earlier teaches something false about what a design file carries.

### Changed

- **DIVI5-CONNECT §"Match a reference" — the ladder gains a fourth rung.** Rung 3 previously read
  "only an image / screenshot / Figma export … vision can't recover exact measurements". That is
  true of a photo of a screen and **false of a vector PDF exported from Figma**, which carries real
  point sizes, and of **a screenshot whose canvas width the user states**, which gives a scale
  factor. Those two are now rung 3, read at a canvas width you say out loud, with their sizes
  treated as **stated, not guessed**; the genuinely unmeasurable case — a photo of a screen, or an
  image with no known width — is rung 4 and still leans on the design system. The loop below the
  ladder now covers all four inputs and includes the size question.
- Version footers → `V0.6.9 | Builder Version 5.11.1`; `skill-version.txt` 0.6.8 → 0.6.9.
  `builderVersion` examples are unchanged at 5.11.1, as is the authoring schema.

### Added

- **DIVI5-CONNECT — a font-size gate**, built in the shape of the post-creation gate below it: ask
  **one** question, wait, then pass `size_policy` to `divi_build_page` — `"exact"` (the stated
  sizes written verbatim, fixed px, so they do not shrink on a phone), `"snap"` (each rounded to
  the nearest step on the site's own scale, fluid), or `"presets"` (the default — the preset
  library's type scale wins and the sizes sent are **discarded**). A design drawn on a fixed canvas
  and a fluid type scale cannot both be satisfied, and the difference is not small: a heading a
  Figma frame states at 48px can arrive at **86px** if the preset library decides instead.
  ⛔ **Never refuse to build over the question** — with no answer, build with the default, which is
  what a default is for. ✅ **Always say which policy was used**: the response carries a
  `size_policy` object with a plain-English `summary`, and under `presets` it also names each size
  that was replaced, the step used instead, and the range that step covers.
- **DIVI5-DESIGN-PROCESS §12 step 1** now names **`size_policy.summary`** alongside `warnings[]`.
  A build can come back "success" having quietly discarded every size the design stated, so the
  summary has to be read and relayed to the user, not just the warnings.

### Known limits

- `size_policy` is a `divi_build_page` parameter, so the gate governs the Divi Connect path only.
  Hand-authored markup and the REST / WP-CLI import path state their own sizes and have nothing to
  negotiate; the ladder correction applies to every path.
- The fourth rung is a statement about what the *file* carries, not a promise about any particular
  reader. Say the canvas width you are reading at, so the scale factor is on the record and the
  user can correct it.

## [0.6.8] — 2026-08-25 · Divi Builder 5.11.1

**Divi 5.11's four new modules, and a native `backdrop-filter` control.**

Divi 5.11.0 added four modules and three filter keys. Found by diffing `ModuleLibrary/`
between 5.10.1 and 5.11.1, then cross-checking the changelog — in that order (5.10 shipped
two modules and announced neither, so the diff stays the instrument). Every claim below is
render-verified on Divi 5.11.1, each on a page carrying a control `divi/text` that also
rendered, so "the module is missing" can never be a symptom of the page having failed.

### Added

- **`divi/charts`** (MODULES-DATA) — Chart.js. Data is a table with the **header row first**.
  Its title is drawn inside the canvas, so it is not a real heading and heading presets do
  not style it; put a `divi/heading` above it when the page needs structure.
- **`divi/gravity-forms`** (MODULES-INTERACTIVE) — 18 styleable elements. The path is NOT
  the CF7 one: `gravityForm.innerContent…formId`, not `form.advanced.formId`. The wrong
  one stores cleanly and renders an empty form.
- **`divi/imagely-gallery`** (MODULES-MEDIA) — the value key is `galleryId`, though Divi
  registers the field under the name `item`. Copying the field name stores cleanly and
  selects nothing.
- **`divi/payment-button`** (MODULES-CONTENT) — keeps `divi/button`'s whole design surface.
  **`environment` defaults to `"sandbox"`**: a button left at the default takes no real money
  and looks completely normal doing it.
- **STYLING §7f — the Filters group, properly.** Which keys emit `filter:` (the element
  itself) versus `backdrop-filter` (what is behind it): `filters.{bp}.value.backdropBlur` /
  `backdropInvert` / `backdropSepia`. Measured: Divi emits the `-webkit-` twin, several
  backdrop keys compose into ONE declaration rather than overwriting, and a control page
  with no backdrop keys emits none.
- COVERAGE: "New in v0.6.8" table for all five items.

### Changed

- **STYLING §9b corrected.** It taught that Divi has no backdrop-filter control and routed
  authors to the Custom CSS escape hatch. True through 5.10, false from 5.11. Teaching a
  workaround for a control that exists is worse than a gap: the value lands in a free-text
  field the Visual Builder cannot present, so the customer can neither see it nor change it.
- `builderVersion` examples 5.10.1 → **5.11.1** (92 values, 14 footers). Historical
  "render-verified on 5.10.1" lines are deliberately untouched — they record what was
  tested against what.
- Version footers → `V0.6.8 | Builder Version 5.11.1`; `skill-version.txt` 0.6.7 → 0.6.8.

### Known limits

- Three of the four new modules depend on a third-party plugin (Gravity Forms, NextGEN, a
  payment provider). Without it each saves cleanly, returns HTTP 200 and renders an empty
  wrapper — a response code is not evidence a module worked. Gravity Forms and Imagely were
  wrapper-asserted only, not content-asserted, for exactly that reason.
- `divi/post-filter` / `divi/post-filter-item` (added in 5.10) are still undocumented —
  `divi_get_module_schema` remains the source.

## [0.6.7] — 2026-08-12 · Divi Builder 5.10.1

**Retarget to Divi 5.10.1 + a corrected breakpoint model.**

### Fixed — folded in before release, 2026-08-21

- **`divi/menu` without `menuId` does NOT render an empty bar** — this reference claimed it
  did. Measured on a live site: the front end falls back to **listing every published page**
  (a 446-link nav on a page-heavy site), while the Visual Builder can still preview a menu,
  so builder and live page disagree and the symptom reads as "my menu isn't showing". Also
  stated now: the module does **not** follow Appearance → Menus theme locations — only its
  own `menuId` counts. Found because exactly this cost a real debugging session.
- **SKILL.md's pre-escape pitfall showed two identical examples** — the ❌ and ✅ were the
  same string, so the rule demonstrated nothing. The ❌ now shows the escaped form
  (`&lt;p&gt;…`) the rule warns against.

### Known gap — two new modules confirmed present, not yet documented

Divi 5.10 ships **`divi/post-filter`** and **`divi/post-filter-item`**: a front-end filter UI
for the Loop Builder, able to filter on taxonomy, post fields or **ACF/custom fields**. Both
are registered and return schemas on 5.10.1. No reference is written yet — `divi_get_module_schema`
is the source until one is. The **Tooltip** module also gained options in this line that
MODULES-INTERACTIVE does not cover.

🪤 **This entry originally claimed 5.10 added "no new authoring schema", concluded from
reading both changelogs end to end. That was wrong: Divi shipped two whole modules with no
changelog line announcing them.** A changelog is not an inventory of the authoring surface —
diff `ModuleLibrary/` between versions instead. Recorded because the same shortcut would
have missed them again next release.

The substance of what this release *does* fix is a defect in our own docs.

### Fixed — the breakpoint table was wrong, and every responsive example acted on it

`DIVI5-BASE.md` §6 described `phoneWide` as **480–767px** and the module/layout files used it
as the mobile breakpoint. Both halves were wrong:

- **480–767px is `phone`**, not `phoneWide`.
- **`phoneWide` ships disabled** (`Breakpoint::get_default_settings_values()` →
  `'enable' => false`, alongside `tabletWide`, `widescreen`, `ultraWide`) and therefore
  **emits no CSS whatever** on a default site.

⇒ Anyone following the examples wrote mobile rules that silently never applied — the failure
shape this skill exists to prevent. **Ten example uses across LAYOUT, PATTERNS, MODULES-MEDIA
and MODULES-INTERACTIVE now target `phone`**, and §6 carries the measured ladder plus an
explicit "only three are on by default" warning.

**Render-verified on 5.10.1 in BOTH states**, not reasoned from source. One heading carrying
a different font-size per breakpoint, published, then the emitted stylesheet parsed to find
the media query enclosing each value:

| | defaults | all four enabled |
|---|---|---|
| `ultraWide` | — | `min-width:1440px` |
| `widescreen` | — | `min-width:1280px` **and** `max-width:1439px` |
| `desktop` | base rule | base rule |
| `tabletWide` | **no rule** | `max-width:1024px` |
| `tablet` | `max-width:980px` | `max-width:980px` |
| `phoneWide` | **no rule** | `max-width:860px` |
| `phone` | `max-width:767px` | `max-width:767px` |

The ones that emitted are the control: identical attribute shape, so the two that vanished
under defaults were dropped by Divi, not malformed by the probe. **The four optional
breakpoints are real and work — they simply need enabling first**, so §6 now documents them
as usable rather than banned, with the caveat that a default site has only three.

🪤 Worth recording, since it nearly shipped: the first fix was a blind `phoneWide` → `phone`
rename, which produced **duplicate JSON keys** — every one of those examples already had a
`phone` entry. The lines were removed instead, with the preceding trailing comma repaired
where `phoneWide` had been last.

### Changed
- `builderVersion` stamp → `"5.10.1"` across all examples (90 occurrences).
- Version footers → `V0.6.7 | Builder Version 5.10.1`.

## [Unreleased] — corrections within 0.6.6 (Divi 5.9.0)

No schema change: this documents authoring rules that were always true and were simply
missing, so it ships inside 0.6.6 under the versioning policy above.

- **DIVI5-PRESETS.md §2b (new): the GROUP preset item schema.** The file previously
  documented only the *module* shape, so anyone authoring a group preset had nothing to work
  from and would reasonably model it on the module item — which fails silently. Reported by
  a customer who lost most of a day to it and had to fall back on hand-written CSS for a
  button. Three differences are load-bearing and now stated: `type: "group"`, the
  `groupName` + `groupId` pair (`moduleName` is still required *as well*), and — the one
  that actually breaks it — **`attrs` is rooted at the GROUP's key (`button`), not at
  `decoration`**. Includes a real shipped preset as a worked example, the eleven group
  buckets, and the trap that a `groupName` not matching Divi's own `presetGroup` string is
  silently ignored.
- **DIVI5-PRESETS.md §2/§4: `renderAttrs` is required, and empty means `[]`, not `{}`.** The
  schema block showed it as an object and did not list it as required. A preset without it
  can validate, save, be counted in the totals, and never appear in the builder's list, with
  no error anywhere — the only symptom is a human looking at a dropdown.
- **DIVI5-PRESETS.md §2: `order` is NOT required.** It appears on builder-created presets, so
  it shows up when diffing against one; all 490 presets Divi Connect ships omit it and list
  correctly. Stated so nobody adds it across a catalog on the strength of that diff.
- **DIVI5-PRESETS.md §2b: validation is not a render check.** A preset can pass a structural
  repair/validate pass and still not appear in the builder. "Valid" means the store will hold
  it, not that the builder will show it.

## [0.6.6] — 2026-07-30 · Divi Builder 5.9.0

- **DIVI5-STYLING.md:** corrected **§7e Capitalization**, which claimed "the legacy `style:["uppercase"]` still
  works for transform". It does not. Measured on **Divi 5.9.0** (`divi/text`, three arms on one page sharing one
  stylesheet): `capitalization:"uppercase"` → `text-transform:uppercase`; `style:["uppercase"]` → computed `none`.
  Five spellings all failed (`style:["uppercase"]`, `style:"uppercase"`, `style:["TT_UPPERCASE"]`,
  `textTransform:"uppercase"`, `textTransform:["uppercase"]`) — the attr stores cleanly and round-trips, so the
  markup looks right and emits nothing, which reads as a design choice rather than a bug. `capitalization` is now
  documented as the only route to `text-transform`. `style[]` remains correct for italic/underline/overline/
  strikethrough (all four render-confirmed, §7e status note) — only the transform value was wrong. Also fixed the
  §7 heading-font example, which taught the broken `style:["uppercase"]` route, and the §7 "Font styles (array)"
  list, which included `"uppercase"`.
- **DIVI5-STYLING.md §9 + DIVI5-LAYOUT.md §7:** corrected the **`htmlAttributes`** shape. Both files documented
  `htmlAttributes.id.desktop.value` (key first, breakpoint inside). That shape stores cleanly and **renders
  nothing** — no `id`, no class, so in-page `#anchor` links silently go nowhere. The working shape has the
  breakpoint **outermost**: `htmlAttributes.desktop.value.{id, class}`. Confirmed two ways on 5.9.0 — both
  spellings emitted on one page so exactly one could win (the documented one lost), and Divi's own reader
  `Module/Options/IdClasses/IdClassesClassnames.php` reads `$attr['desktop']['value']['id']`/`['class']`, and
  reads `desktop` only. Probed on section, row and text modules.
- **KNOWN-CAVEATS.md:** added both of the above to §1 (silent-drop table).

  *Both are docs-only: Divi's 5.9.0 authoring schema is unchanged (it never accepted either wrong shape). They
  are nevertheless shipped as a VERSION BUMP, because a copy already downloaded at 0.6.5 or earlier carries the
  incorrect guidance and only a new version number makes it re-download.*

- **DIVI5-CONNECT.md:** added **§5 "Match a reference — make it like this"** — a fidelity-ladder workflow for
  when the user wants a page to match something. (1) a page already on this site → `divi_get_tree` /
  `divi_duplicate_page` (read the real Divi tree — highest fidelity); (2) a public URL → the new
  **`divi_import_reference`** tool (fetches the page, returns structure + content: sections with role/column
  guesses and their modules — layout + content, NOT styling, so you rebuild in the user's own tokens); (3) only
  an image/mockup → read it visually into the *same* structured shape. Plus the confirm-loop (read → restate the
  structure and get the user's OK → get_design_system → build with their tokens → render and adjust) that turns
  "nowhere close" into "that's it". Answers the #1 beta ask. Docs-only; no schema change, no version bump.

- **DIVI5-STYLING.md:** corrected **§10** — a font variable reference must be wrapped `{"type":"content"}`, never
  `{"type":"font"}`, which §10 had previously documented as "verified". Divi's font-enqueue scanner
  (`DynamicAssetsUtils::extract_used_fonts_from_content`) resolves a `$variable()` font reference only under
  `'content' === $data['type']`; there is no branch for `"font"`. Both forms resolve the CSS variable — so the
  family lands in the stylesheet and the Visual Builder renders correctly — but only `content` also tells Divi
  the font is in use, so a `"font"`-typed reference never enqueues the webfont and the front end silently falls
  back. The original "verified" note only ever proved CSS resolution, never the enqueue. §10 now teaches
  `content` and explains why `font` looks right and isn't. Docs-only: Divi's 5.9.0 authoring schema is unchanged
  (it never accepted `"font"`), so no version bump — but note that skills already downloaded at 0.6.4 carry the
  incorrect guidance.
- **DIVI5-BASE.md:** corrected the button example in §"Correct (everything on `button.decoration`)", whose
  `family` reference wrapped `{"type":"font"}` — under a **✅ Correct** heading, so the most-read file in the
  skill was certifying the broken form. Now `{"type":"content"}`, matching §10. Note this is distinct from
  `type: "font"` in a `POST /variables` payload (DIVI5-CONNECT §, DIVI5-STYLING §10), which is the *variable
  kind* used to declare a font variable and remains correct — the same two words mean different things in the
  two positions.

- **DIVI5-DESIGN-PROCESS.md:** added **§11b "Post-build polish pass"** — the after-build twin of the §11
  pre-build rubric: after building, read the build's `warnings[]`, fetch `divi_get_rendered_page` (with byte
  caps), self-check the *rendered* result against §8c, then fix **surgically** (edit/add/move/delete — not a
  full rebuild) and re-render. Turns the connector's non-blocking nudges from "printed" into "acted on." Also
  noted in §8c that `divi_build_page` now caps body text at ~65ch and floors buttons at a 44px tap target.
  Docs-only.
- **DIVI5-DESIGN-PROCESS.md:** added **§8c "Landing-page heuristics (objective, checkable)"** — concrete rules
  distilled from established web-design guidance (NN/g homepage principles, best-practice): value prop above the
  fold, one primary CTA per section, high-scent CTA labels (not "Learn more"/"Click here"), one H1 + no skipped
  heading levels, ≤2 fonts / ≤3 core colours, 45–75char line length, alt text + contrast + focus. Notes that
  `divi_build_page` now warns on several of these. Added a matching line to the §11 Self-Critique Rubric. Docs-only.
- **DIVI5-BASE.md rule 10:** rewrote the rich-text rule, which read "must HTML-encode `<` as `<` and `>` as `>`"
  — a no-op as written (the entities had been decoded by an earlier sweep) and a flat contradiction of
  §"HTML content is passed RAW" 143 lines below it in the same file, which has said since 1.7.5 that escaping
  `<`/`>` "produces visibly broken pages". Now states the rule once, for both audiences: rich text takes raw
  HTML; neither HTML entities nor a JSON `\u003c` escape may be pre-applied.
- **DIVI5-PRESETS.md:** the preset attr-path table documented `module.decoration.sizing.{bp}.value.alignment`
  (`"left"`/`"center"`/`"right"`). The native control is **`alignSelf`** (`"flex-start"`/`"center"`/`"end"`)
  — Divi's Sizing → Alignment, emitting `align-self`. Use it to position a width-capped box instead of
  `margin:auto`, which does not round-trip in the Visual Builder.

- **DIVI5-PRESETS.md:** added **§1b "Preset system model — design it in levels (role-based)"** — the Divi 5
  four-level preset model (variables → Option-Group presets in the `group` bucket → nested/composable → Element
  presets with a per-module `default`), the base-then-variation stacking order, and role-based scope-prefixed
  naming ("Button: Primary Filled", "Border: Card"). Steers stacked/OGP presets over hardcoded per-module
  overrides. Docs-only.

## [0.6.4] — 2026-07-11 · Divi Builder 5.9.0

**Documentation / patterns release.** No change to the Divi 5.9.0 authoring schema
(`builderVersion` stays `"5.9.0"`); this cuts the accumulated Divi Connect
pattern-library documentation into a versioned release so the downloadable bundle
and the website track it.

- **DIVI5-CONNECT.md:** documented Divi Connect's section-pattern library and the `divi_list_patterns`
  discovery tool, with an "assemble a page by naming patterns first" nudge (free-form a raw section only when
  no pattern fits). Tier-1: `split` (case-study L/R), `pricing`, `testimonial`, `stats`. Tier-2: `faq`
  (native accordion), `team` (native person cards), `logo-strip`, `bento`, and a `cta` banner variant
  (bg_image + overlay). Tier-3: `feature-list`, `timeline` (native timeline module), `gallery`,
  `comparison` (feature table), `newsletter` (email-capture split). These use purpose-built native
  modules where they fit — gallery = native gallery module, timeline = native timeline, newsletter =
  native email opt-in (signup). Tier-4 (all native modules): `tabs`, `slider`, `social-follow`, `blog`
  (real posts), `portfolio` (real projects), `video`, `countdown`, `skills` (bar/circle counters),
  `contact` (working form), `map`, and `before-after` (native draggable image slider). 28 patterns total.
- **DIVI5-CONNECT.md:** documented Divi Connect v1.7.3's `divi_build_page` fidelity primitives
  (background image + overlay on sections/columns, the `badge` module, `rotate`/`scale` tilt, and
  variable-font axes) as an "editorial / premium looks" subsection, plus a "Design nudges" note under
  Build guardrails (the non-blocking slop warnings that point back to DESIGN-PROCESS §8b). Field-level
  detail stays in the tool's own description; the Skill just steers when to reach for them.

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
