# DIVI5 Skill Files

Modular skill files for generating Divi 5 page layouts via JSON.

📖 **New here? Start with the [Wiki](docs/wiki/Home.md)** — what this is, how to attach
it to Claude, building a page, publishing live, module coverage, and contributing.

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

**V0.5.1 — Builder Version 5.7.4**

Tracks the current **Divi 5.7.x** line (latest **5.7.4**). Patches 5.7.1–5.7.4 were maintenance/bug-fix releases (builder-UI workspace system + Visual-Builder/migration/front-end render fixes) — **no new authoring schema**, so only the `builderVersion` stamp moved to `"5.7.4"`. The authoring features are unchanged from V0.5.0 below.

**V0.5.0 — Builder Version 5.7.0**

Updated from v0.4.0 (Divi 5.6.2) to Divi **5.7.0**. Added **text fill effects** (gradient text fill, image text fill, text stroke — `font.textEffects`), **gradient variables** (reusable global gradient tokens), and the **expanded gradient model** (conic/elliptical types, `directionRadial`, `repeat`, `length`). See `DIVI5-STYLING.md` §1, §7b, §10.

**V0.4.0 — Builder Version 5.6.2**

Updated from v0.3.0 (Divi 5.0.x/5.1.0) to Divi **5.6.2**. Added new modules (svg, timeline, breadcrumbs, table-of-contents, instagram-feed, dropdown, contact-form-7), new systems (Grid layout, aspect-ratio, image framing, Loop Builder, form pseudo-class states, variable generators, global-layout), and two new module families (dynamic content + WooCommerce).

> Entries marked **⚙ source-verified** are extracted from the Divi 5.6.2 theme source but not yet confirmed via the real-render skill loop. Everything else was real-render tested at 5.0.x and remains valid. See `DIVI5-COVERAGE.md`.
