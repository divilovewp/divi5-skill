# Overview

## What this is
The Divi 5 Skill is a **modular knowledge base** for an AI assistant. A small router
file (`SKILL.md`) points to focused reference files; the model reads only what a task
needs:

- **`DIVI5-BASE.md`** — non-negotiable rules, nesting hierarchy, validation, common mistakes (always attach)
- **`DIVI5-DESIGN-PROCESS.md`** — discovery questions + page planning before any JSON (always attach)
- **`DIVI5-LAYOUT.md`** — section/row/column/group, the flexbox system, Grid, global-layout
- **`DIVI5-STYLING.md`** — backgrounds, gradients (+ gradient variables), spacing, border, typography, text effects, aspect-ratio, framing, the token/variable system
- **`DIVI5-MODULES-*.md`** — every module family (content, interactive, media, data, dynamic, WooCommerce)
- **`DIVI5-PRESETS.md`**, **`DIVI5-PATTERNS.md`**, **`DIVI5-WORDPRESS.md`**, **`DIVI5-CONNECT.md`**, **`DIVI5-COVERAGE.md`**

The core authoring knowledge is **plugin-agnostic** — it produces valid Divi 5 markup
regardless of how you publish it.

## The two ways to use it
1. **JSON only.** The model generates the Divi 5 builder markup; you import it yourself
   (Divi's Import/Export, the WordPress REST API, or WP-CLI — see
   [Building a Page](3-Building-a-Page.md) and `DIVI5-WORDPRESS.md`).
2. **Publish live.** With the [Divi Connect](https://divilove.com/) plugin installed,
   the model reads your site's real design system (colors, variables, presets) and
   publishes the page directly — see
   [Publishing Live](4-Publishing-Live-with-Divi-Connect.md).

You can use the skill entirely on the JSON-only path; the live path is an optional
convenience.

## What makes the output correct
Divi 5 builder markup has a few rules that, if broken, silently produce **blank**
modules. The skill encodes them up front (full list in `DIVI5-BASE.md`):
- module attributes go at the top level — never wrapped in an `attrs` key
- text content lives under the exact `content` key
- HTML inside a value is unicode-escaped (`<`/`>`)
- every module carries `"builderVersion": "5.8.1"`
- the page is wrapped in `<!-- wp:divi/placeholder --> … <!-- /wp:divi/placeholder -->`
