# Contributing

Modules are covered **one at a time**, thoroughly, with a strict human-in-the-loop
verification protocol. The repo uses a simple feature-branch workflow.

## Branch workflow (see `WORKFLOW.md`)
`main` always builds. For each module:

```bash
git checkout main && git pull
git checkout -b module/<name>
# ...do the deep-dive, commit in small steps...
git checkout main
git merge --no-ff module/<name>
git branch -d module/<name>
```

A module deep-dive documents only what is **unique** to that module, and pushes any
newly discovered **shared** behaviour up into `DIVI5-STYLING.md` / `DIVI5-LAYOUT.md` —
the Design and Advanced panels are ~90% shared, so they live once, not in 50 files.

## Per-module verification protocol (see `MODULE-TEMPLATE.md`)
1. **Exhaustive checklist** auto-generated from the module's Divi source
   (`module.json`) into `modules/<name>/CHECKLIST.md` — one row per real setting
   (Content / Design / Advanced), nothing invented or skipped.
2. **Render at desktop/tablet/mobile** + a human visually confirms each row
   (+ HTML-confirmed for non-visual attributes like links/classes/IDs).
3. **Per-panel cadence** — work Content → Design → Advanced, one render per panel.
4. **Merge gate** — a module branch may not merge to `main` until every checklist row
   is human-confirmed or explicitly marked N/A with a reason.

## Definition of done
A claim isn't "done" until a render proves it. Source-verified-only items stay marked
in `DIVI5-COVERAGE.md` until render-verified.

## Building the bundle
`build-skill-zip.ps1` packages the `.md` files into a distributable zip (rebuilt from
source at release time). The zip is not committed.
