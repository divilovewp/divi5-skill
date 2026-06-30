# Module deep-dive template — "definition of done" for one module

Copy this checklist when you start a module branch (`module/<name>`). A module is
**fully covered** only when every box is real (source-verified AND render-verified,
not assumed). This is the unit of work for the per-module workflow — see
[WORKFLOW.md](WORKFLOW.md).

> **Architecture reminder — do NOT re-document the shared panels here.**
> In Divi 5 the Design and Advanced panels are ~90% the *same* across every module
> (background, spacing, sizing, border, box-shadow, filters, transforms, position,
> sticky, scroll effects, visibility). That shared system lives **once** in
> `DIVI5-STYLING.md` / `DIVI5-LAYOUT.md`. A module deep-dive documents only what is
> **unique** to the module, and pushes any *newly discovered* shared behaviour UP
> into STYLING/LAYOUT so every module benefits. Don't copy the panel into 50 files.

---

## Verification protocol — human-in-the-loop, every setting (STRICT)

A module is not "done" when the assistant *thinks* it works — it is done when a
human has confirmed **every** setting. The rules:

1. **Exhaustive checklist, auto-generated from the module's Divi source.** At the
   start of a module branch, enumerate **every** Content / Design / Advanced setting
   from `…/module-library/src/components/<name>/module.json` into
   `modules/<name>/CHECKLIST.md`. One row per *actual* setting — nothing invented,
   nothing skipped. Row shape:

   | # | Setting | Attr path | Test value | Evidence | Human ✓ |
   |---|---------|-----------|------------|----------|---------|
   | 17 | Icon placement | `imageIcon.advanced.placement` | top → left | `blurb_p17.png` | ☐ |

2. **The assistant ticks NOTHING on its own.** Each row is verified =
   render at desktop/tablet/mobile **+ the user's explicit visual sign-off**
   (+ HTML-confirmed for non-visual attrs like links/classes/IDs).

3. **Sign-off cadence = per-panel batch.** Work one panel at a time
   (Content → Design → Advanced). For each panel: build ONE render exercising all
   its settings, present the screenshot(s) + a numbered list mapping each setting to
   *what to look at*; the user approves or flags **per row**; only then are those
   rows ticked. Every setting is still listed and ticked individually — just grouped
   to keep round-trips sane.

4. **Merge gate.** `module/<name>` may not merge to `main` until **every** row is
   ✓-by-the-user or explicitly marked **N/A** with a reason. A render isn't enough;
   the human ✓ is the gate.

5. Shared-panel settings that visibly behave identically to other modules may be
   ticked as "shared — confirmed in STYLING/LAYOUT" rather than re-shot, but the row
   still exists and still needs the human ✓.

---

## Module: `divi/<name>`

**Branch:** `module/<name>` · **Family file:** `DIVI5-MODULES-<FAMILY>.md` ·
**Divi version verified:** 5.8.1 · **Date:** ____

### 1. Content tab (module-specific) — REQUIRED
- [ ] Every `innerContent` field: exact path + shape (string / object / array) + which are required + defaults.
- [ ] String-vs-object-vs-array rule noted per field (arrays in `innerContent.*.value` crash WP — confirm each field's type).
- [ ] Child modules (if any): slug, self-closing or not, required attrs, nesting order.
- [ ] Dynamic-content / loop tokens this module's fields accept (if applicable).

### 2. Design tab — only the module-UNIQUE elements
- [ ] List the module's own styleable **elements** beyond `module` (e.g. `button`, `imageIcon`, `title`, `number`) and the decoration each exposes.
- [ ] For each: the element-specific path that differs from the generic `module.decoration` (e.g. standalone button bg → `button.decoration.background`).
- [ ] Note which **shared** Design groups visibly apply/render for this module, and any that silently no-op.

### 3. Advanced tab
- [ ] Module-specific advanced attrs (e.g. `number.advanced.enablePercentSign`, `menu.advanced.menuId`, query/`post.advanced`).
- [ ] Which generic Advanced features are confirmed for this module: position, transforms, scroll effects, sticky, visibility/`disabledOn`, CSS ID/class, conditions, loop.
- [ ] Custom-CSS selector hooks the module exposes (if documented).

### 4. Responsive
- [ ] Breakpoint behaviour (desktop/tablet/phone) confirmed by screenshot.
- [ ] Any **non-stacking / self-managed-layout** gotcha (e.g. grid, pricing-tables, tabs bar) called out explicitly.

### 5. Render verification — REQUIRED (this is the ground truth)
- [ ] Scenario script: `scenarios/scenario_<n>_<name>.py`
- [ ] Page id: ____ · screenshots at desktop/tablet/mobile committed/linked.
- [ ] Created via plain REST (server-rendered) — or note if it needs builder-UI/dynamic-assets/post-context to render.

### 6. Gotchas
- [ ] Anything that crashed (HTTP 500), silently failed, or rendered wrong — with the root cause and the fix.

### 7. Native recipe(s)
- [ ] Any reusable pattern this module enables → add to `DIVI5-PATTERNS.md` (and reference a reusable native-recipe helper if one matches).

### 8. Landing the branch — files touched
- [ ] Module section updated in its family file.
- [ ] New shared behaviour pushed UP to `DIVI5-STYLING.md` / `DIVI5-LAYOUT.md` (not duplicated).
- [ ] `DIVI5-COVERAGE.md` row flipped to ✓ with the verification note.
- [ ] `DIVI5-PATTERNS.md` recipe added (if any).
- [ ] Version footer / `builderVersion` consistent.
- [ ] `pwsh ./build-skill-zip.ps1` runs clean; merge `module/<name>` → `main`.
