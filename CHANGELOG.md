# Changelog

All notable changes to the **Divi 5 Skill** are recorded here.
The format is loosely based on [Keep a Changelog](https://keepachangelog.com/).

**Versioning:** the skill version tracks the Divi Builder schema it targets (see
the `## Version` section in [README.md](README.md) and the `builderVersion` stamp
in [SKILL.md](SKILL.md)). The version is bumped only when the **authoring schema**
changes. Documentation corrections and clarifications that don't change the schema
are logged under **Unreleased** and ship within the current version without a bump.

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

- Earlier baseline (real-render tested at 5.0.x).
