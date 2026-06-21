# Contributing workflow — one module at a time

This repo uses the simplest real git workflow: **feature branches** (a.k.a.
GitHub Flow). `main` is always the stable, known-good skill that can be built into
a zip and shipped. You never edit `main` directly for module work — you branch,
do the work, then merge back.

The unit of work is **one Divi module**, fully covered per
[MODULE-TEMPLATE.md](MODULE-TEMPLATE.md). A module's changes may touch several
files (its family file + `DIVI5-STYLING.md` + `DIVI5-COVERAGE.md` + maybe
`DIVI5-PATTERNS.md`) — that's expected. You branch **per module**, not per file.

---

## The loop, every module

```bash
# 0. start from an up-to-date main
git checkout main
git pull                      # if a remote exists

# 1. make a branch for this module
git checkout -b module/blurb

# 2. do the deep-dive work (edit the .md files, run scenarios, screenshot)
#    commit in small steps as you go:
git add -A
git commit -m "blurb: document imageIcon shape + render-verify (page 142)"
# ...more commits as the checklist fills in...

# 3. when MODULE-TEMPLATE.md is fully ticked, rebuild + sanity-check the bundle
pwsh ./build-skill-zip.ps1

# 4. merge the finished module back into main
git checkout main
git merge --no-ff module/blurb     # --no-ff keeps the module as one visible unit
git branch -d module/blurb         # delete the finished branch
```

If you tagged a release batch:

```bash
git tag v0.6.0 -m "Modules fully covered: blurb, icon, number-counter"
git push origin main --tags
```

---

## Rules of thumb

- **`main` always builds.** Never merge a half-covered module into `main`.
- **Branch per module, not per file.** Name them `module/<slug>` (e.g.
  `module/accordion`, `module/contact-form`).
- **Don't commit the zip.** It's gitignored. Rebuild it from the `.md` sources with
  `build-skill-zip.ps1` at release/tag time.
- **Push shared findings up.** A new background/spacing/position behaviour goes in
  `DIVI5-STYLING.md` once — not copied into each module section.
- **Render-verify before merging.** A claim isn't "done" until a screenshot proves
  it. Source-verified-only items stay marked Partial in `DIVI5-COVERAGE.md`.

---

## First-time GitHub setup (when you create the org repo)

The repo lives under the **`divilovewp`** GitHub org, lowercase-hyphenated name
(e.g. `divi5-skill`), private to start. Once you've created the empty repo on
GitHub:

```bash
git remote add origin https://github.com/divilovewp/divi5-skill.git
git push -u origin main
```

After that, `git push` / `git pull` keep your machine and GitHub in sync. Branches
you push (`git push -u origin module/blurb`) can become Pull Requests, which give
you a clean per-module review/diff before merging.
