# Version history (archive)

These are earlier, superseded versions of the Divi 5 Skill, kept for transparency so you
can see how the skill evolved. **They are not maintained — use the current skill in the
repo root.** See [`../CHANGELOG.md`](../CHANGELOG.md) for the change history.

Early releases were originally labelled "V1" and "V2"; the project later adopted semantic
versioning, so those are recorded here as **0.1.0** and **0.2.0**.

**Going forward:** every new version is snapshotted here on release — a folder `vX.Y.Z/` with the
skill files, plus a downloadable `vX.Y.Z.zip`. (Earlier 0.4.0/0.5.0 were lost because files were
edited in place; this policy prevents that recurring.)

| Version | Files | Divi Builder | Notes |
|---------|-------|--------------|-------|
| 0.1.0 (was "V1") | [v0.1.0.md](v0.1.0.md) | 5.0.1 | First version. Single-file skill, JSON import/export workflow. |
| 0.2.0 (was "V2") | [v0.2.0.md](v0.2.0.md) | 5.0.1 | Reorganized; added flexbox/row deep-dive, card patterns, Python generator. |
| 0.2.1 (Beta) | [v0.2.1-beta.md](v0.2.1-beta.md) | 5.0.1 | Adds nested-rows, row/column/group card patterns, contact-form submit button. |
| 0.3.0 | [v0.3.0/](v0.3.0/) (browse) · [v0.3.0.zip](v0.3.0.zip) (download) | 5.1.0 | First **multi-file** split (BASE / LAYOUT / MODULES-\* / PATTERNS / STYLING + COVERAGE reference). |
| 0.5.1 | [v0.5.1/](v0.5.1/) (browse) · [v0.5.1.zip](v0.5.1.zip) (download) | 5.7.4 | Divi 5.7.x line — text fill effects, gradient variables, expanded gradient model (snapshotted at the 0.6.0 bump). |
| 0.6.0 | [v0.6.0/](v0.6.0/) (browse) · [v0.6.0.zip](v0.6.0.zip) (download) | 5.8.1 | Divi 5.8.x — **Tooltip module** + **Advanced Text Styling** (variable fonts, drop caps, text columns, vertical text, line-wrap, hyphenation, paragraph spacing, stroke position). |
| 0.6.1 | [v0.6.1/](v0.6.1/) (browse) · [v0.6.1.zip](v0.6.1.zip) (download) | 5.8.1 | Docs release (no schema change) — Divi Connect **v1.6.5** live-site sync (post auto-detect, `divi_duplicate_page`/`divi_list_pages`, `mode`/`needs_builder_repair`) + **off-canvas mobile menu** pattern. |
| 0.6.2 | [v0.6.2/](v0.6.2/) (browse) · [v0.6.2.zip](v0.6.2.zip) (download) | 5.8.1 | Metadata release (no schema change) — made the skill `description` version-agnostic (was stale at "5.7.x"; skill targets 5.8.x). |
| 0.6.3 | [v0.6.3/](v0.6.3/) (browse) · [v0.6.3.zip](v0.6.3.zip) (download) | 5.9.0 | Divi 5.9.0 — **Grid Editor** (`gridOffsetRules` container-driven per-item placement, LAYOUT §5b, render-confirmed) + doc roll-up ("avoid AI-design clichés" §8b, render-verified community gotchas, connector-tailored bundling). No new modules vs 5.8.x. |
| 0.6.4 | [v0.6.4/](v0.6.4/) (browse) · [v0.6.4.zip](v0.6.4.zip) (download) | 5.9.0 | Documentation/patterns release (no schema change) — documents the Divi Connect **section-pattern library** (28 mostly-native patterns) + the `divi_list_patterns` tool + `divi_build_page` fidelity primitives (bg-image overlays, badges, tilt, variable fonts). |
| 0.6.6 | [v0.6.6/](v0.6.6/) (browse) · [v0.6.6.zip](v0.6.6.zip) (download) | 5.9.0 | Correctness release (no schema change) — fixes two silently-failing rules (`text-transform` only via `capitalization`; `htmlAttributes` breakpoint outermost), settles rich-text escaping (raw HTML, never pre-escaped), documents `sizing.alignSelf`, and corrects font-variable refs to `type:"content"`. (0.6.5 shipped only inside the Divi Connect plugin bundle and has no snapshot.) |
| 0.6.7 | [v0.6.7/](v0.6.7/) (browse) · [v0.6.7.zip](v0.6.7.zip) (download) | 5.10.1 | Retarget to Divi 5.10.1 + corrected breakpoint model (`phoneWide` is disabled and emits no CSS; mobile rules target `phone`), plus the `divi/menu` no-`menuId` fallback correction (lists every page, not an empty bar). |
| 0.6.8 | [v0.6.8/](v0.6.8/) (browse) · [v0.6.8.zip](v0.6.8.zip) (download) | 5.11.1 | Divi 5.11 — four new modules (`divi/charts`, `divi/gravity-forms`, `divi/imagely-gallery`, `divi/payment-button`, all render-verified) + native `backdrop-filter` (STYLING §7f) replacing the old Custom CSS workaround. |
| 0.6.9 | [v0.6.9/](v0.6.9/) (browse) · [v0.6.9.zip](v0.6.9.zip) (download) | 5.11.1 | Docs release (no schema change) — the reference ladder gains a **fourth rung** (a vector Figma PDF, or an export at a stated canvas width, DOES carry exact type sizes; only a photo of a screen cannot) and a **font-size gate**: ask once, then pass `size_policy` `exact`/`snap`/`presets` to `divi_build_page` and relay which was used. DESIGN-PROCESS §12 step 1 names `size_policy.summary`. |
| 0.7.0 | [v0.7.0/](v0.7.0/) (browse) · [v0.7.0.zip](v0.7.0.zip) (download) | 5.16.0 | Divi 5.12–5.16 authoring additions, render-confirmed on 5.16.0 (Show Labels, collapsible mobile menu, swipe controls, Shop pagination text, Timeline interactions) + the PAGE-FROM-HTML topic and every doc change since 0.6.9. Not yet: the Components Slot module. |
| 0.7.1 | [v0.7.1/](v0.7.1/) (browse) · [v0.7.1.zip](v0.7.1.zip) (download) | 5.16.0 | `divi/charts` data shape fixed (the documented one never drew); new topics ANIMATION + CUSTOM-MODULES; gallery by attachment id — community PRs #6–#9, verified on 5.16.0. |
| 0.7.2 | [v0.7.2/](v0.7.2/) (browse) · [v0.7.2.zip](v0.7.2.zip) (download) | 5.16.0 | Components and Slots (`divi/global-layout` + `divi/global-slot`), learned from Visual Builder markup and render-confirmed on 5.16.0. |

0.3.0+ are multi-file, so each is provided both as browseable files under `vX.Y.Z/` and as a
downloadable `vX.Y.Z.zip` (mirrors the original "Upload these to Claude" / reference layout). The current
release lives in the repo root; **0.7.2** is the latest.

**Not archived:** 0.4.0 (Divi 5.6.2) and 0.5.0 (Divi 5.7.0) have no surviving snapshot — those skill
files were edited in place during development, so no standalone copy was kept; they exist only as entries
in `../CHANGELOG.md`. (0.5.0 → 0.5.1 was only a `builderVersion` stamp bump; 0.5.1 is now snapshotted above.)

> Notes: `v0.1.0.md` was reconstructed from the original document (character-encoding repaired).
> Third-party/client-site references in the early files were removed; the project's own
> divilove.com brand attribution is retained.
