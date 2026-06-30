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

0.3.0+ are multi-file, so each is provided both as browseable files under `vX.Y.Z/` and as a
downloadable `vX.Y.Z.zip` (mirrors the original "Upload these to Claude" / reference layout). The current
release lives in the repo root; **0.6.0** is the latest.

**Not archived:** 0.4.0 (Divi 5.6.2) and 0.5.0 (Divi 5.7.0) have no surviving snapshot — those skill
files were edited in place during development, so no standalone copy was kept; they exist only as entries
in `../CHANGELOG.md`. (0.5.0 → 0.5.1 was only a `builderVersion` stamp bump; 0.5.1 is now snapshotted above.)

> Notes: `v0.1.0.md` was reconstructed from the original document (character-encoding repaired).
> Third-party/client-site references in the early files were removed; the project's own
> divilove.com brand attribution is retained.
