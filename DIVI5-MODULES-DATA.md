---
name: divi5-modules-data
description: Confirmed JSON structures for Divi 5 data modules — number-counter, circle-counter, bar counters, pricing tables, social media follow, countdown-timer, and dynamic WordPress module reference.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Data, Counter, Pricing & Social Modules
> **Part of the DIVI5 skill set. Attach when using counters, pricing tables, social media, table-of-contents, instagram-feed, or misc modules.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA (this) · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS

---

## `divi/number-counter`

Animated number counter. **Self-closing.**

> **⚠️ `enablePercentSign` defaults to `"on"` (render-confirmed)** — every counter shows a trailing `%` unless you explicitly set `number.advanced.enablePercentSign.desktop.value` to `"off"`. Always set it `"off"` for plain numbers (users, counts, money) and `"on"` only for true percentages.

```json
{
  "number": {
    "innerContent": {"desktop": {"value": "98"}},
    "decoration": {
      "font": {"font": {"desktop": {"value": {
        "size": "64px", "weight": "800", "color": "#6B21A8", "textAlign": "center"
      }}}}
    },
    "advanced": {"enablePercentSign": {"desktop": {"value": "on"}}}
  },
  "title": {
    "innerContent": {"desktop": {"value": "Client Satisfaction"}},
    "decoration": {
      "font": {"font": {"desktop": {"value": {
        "headingLevel": "h4", "size": "18px", "weight": "700",
        "color": "#1F2937", "textAlign": "center"
      }}}}
    }
  },
  "builderVersion": "5.11.1"
}
```

---

## `divi/circle-counter`

Circular progress indicator. **Self-closing.** Confirmed working.

```json
{
  "number": {
    "innerContent": {"desktop": {"value": "98"}},
    "decoration": {"font": {"font": {"desktop": {"value": {
      "size": "36px", "weight": "800", "color": "#60a5fa", "textAlign": "center"
    }}}}}
  },
  "title": {
    "innerContent": {"desktop": {"value": "Client Satisfaction"}},
    "decoration": {"font": {"font": {"desktop": {"value": {
      "headingLevel": "h4", "size": "16px", "weight": "600",
      "color": "#e2e8f0", "textAlign": "center"
    }}}}}
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed:** Circular arc renders in the number's text color. Number appears inside the circle. Title renders below. Responsive — stacks cleanly to full-width on mobile (uses intersection observer like `number-counter`, ensure scroll-through before screenshot).

---

## `divi/counters` + `divi/counter` (Bar Counters)

Horizontal progress bars. `counters` is **NOT self-closing**. `counter` **IS self-closing**. Confirmed working.

```json
// counters (parent):
{
  "barProgress": {
    "advanced": {"usePercentages": {"desktop": {"value": "on"}}}
  },
  "builderVersion": "5.11.1"
}

// counter (child — self-closing):
{
  "title":       {"innerContent": {"desktop": {"value": "WordPress Development"}}},
  "barProgress": {"innerContent": {"desktop": {"value": "95"}}},
  "builderVersion": "5.11.1"
}
```

**Confirmed:** `barProgress.innerContent.desktop.value` is the progress amount (string number 0–100). `usePercentages: "on"` on the parent container shows "%" suffix. Constrain to `max_width: '800px'` row for best readability.

---

## `divi/pricing-tables` + `divi/pricing-table`

`pricing-tables` is **NOT self-closing**. `pricing-table` **IS self-closing**.

```json
// pricing-table (child — self-closing):
{
  "currencyFrequency": {
    "innerContent": {"desktop": {"value": {"currency": "$", "per": "month"}}}
  },
  "title":    {"innerContent": {"desktop": {"value": "Pro Plan"}}},
  "subtitle": {"innerContent": {"desktop": {"value": "For growing teams"}}},
  "price":    {"innerContent": {"desktop": {"value": "99"}}},
  "content":  {"innerContent": {"desktop": {"value": "Feature A\nFeature B\nFeature C"}}},
  "button": {
    "innerContent": {"desktop": {"value": {
      "text": "Get Started", "linkUrl": "#", "linkTarget": "off"
    }}}
  },
  "module": {
    "decoration": {
      "background": {"desktop": {"value": {"color": "#FFFFFF"}}},
      "border": {"desktop": {"value": {"radius": {
        "topLeft": "16px", "topRight": "16px",
        "bottomLeft": "16px", "bottomRight": "16px", "sync": "on"
      }}}},
      "spacing": {"desktop": {"value": {"padding": {
        "top": "48px", "bottom": "48px", "left": "40px", "right": "40px"
      }}}}
    }
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed working (real-render tested):**
- `currencyFrequency.currency` renders as small superscript before the price number
- `currencyFrequency.per` renders as small text after the price; Divi prepends a `/` separator, so pass `"month"` / `"mo"` (NOT `"/mo"`, which would double the slash). *(The key is `per`, not `frequency`.)*
- `content` newline-separated (`\n`) lines render as a bullet list; a leading `-` marks a feature **unavailable** (greyed/struck). Bullet colour = `content.advanced.bulletColor.desktop.value`.
- `button` field works with the same structure as `divi/button`
- **Header background** = `title.decoration.background.desktop.value.color` (the title element IS the header bar). Header text colour = `title.decoration.font.font.desktop.value.color`.
- Card padding on the module is applied to **each inner block** (heading/price/features), so a large value gaps everything — prefer Divi's defaults. Each inner element (`title`, `price`, `content`) also takes its own `decoration.spacing.padding` for fine control.

**Responsive layout:** `pricing-tables` manages its own internal flex and does NOT respond to the row/column breakpoint system. Two ways to make it stack on mobile:

✅ **Simplest — set the parent's own flex to wrap on phone** (Design-tab layout): put all tables in ONE container and set
```json
"module": {"decoration": {"layout": {
  "desktop": {"value": {"flexWrap": "nowrap"}},
  "phone":   {"value": {"flexWrap": "wrap"}}
}}}
```
✅ **Alternative — one table per container per column** (the row/column grid then handles stacking):
```
Row (3-col) → each Column → pricing-tables → one pricing-table
```
❌ **Wrong — multiple tables in one container with no wrap** → they overflow and don't stack on mobile.

---

## `divi/social-media-follow` + `divi/social-media-follow-network`

`social-media-follow` is **NOT self-closing**. Network items **ARE self-closing**.

```json
// social-media-follow (parent — container):
{
  "module": {
    "decoration": {
      "layout": {"desktop": {"value": {"justifyContent": "center"}}}
    }
  },
  "builderVersion": "5.11.1"
}

// network item (child — self-closing):
{
  "socialNetwork": {
    "innerContent": {
      "desktop": {"value": {"title": "facebook", "label": "Facebook"}}
    }
  },
  "module": {
    "decoration": {"background": {"desktop": {"value": {"color": "#1877f2"}}}}
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed `title` values (real-render tested):** `facebook`, `twitter`, `instagram`, `linkedin`, `youtube`

| Network | `title` | Suggested `color` |
|---------|---------|-------------------|
| Facebook | `facebook` | `#1877f2` |
| Twitter/X | `twitter` | `#1da1f2` |
| Instagram | `instagram` | `#e1306c` |
| LinkedIn | `linkedin` | `#0077b5` |
| YouTube | `youtube` | `#ff0000` |

**Centering:** Set `layout.justifyContent: center` on the `social-media-follow` container to center the icon row.

---

## `divi/table-of-contents` (NEW in 5.6.0 — ✓ render-confirmed)

Auto-builds a linked list from the headings of the current post. Self-closing. **Confirmed working** — rendered an ordered list (1. Getting Started, 2. Key Features, 3. Conclusion) linking to the post's `<h2>` headings.

> **Working recipe (confirmed):**
> 1. A **Theme Builder body template** (e.g. *All Posts*) containing `table-of-contents` + `post-content` (TOC reads the headings that `post-content` outputs).
> 2. The post itself written in **Gutenberg/classic** with `<h2>/<h3>` headings — the TOC reads `the_content` headings, **not** `divi/heading` modules on a Divi-built page.
> 3. The template **saved through the builder UI** (see caveat below).
>
> **⚠️ Programmatic/REST caveat (important):** the TOC builds its list via a **frontend script** (`divi-module-library-script-table-of-contents`) that Divi 5's dynamic-assets system only enqueues when the module is saved through the **builder UI**. Inserting the layout as raw block markup via REST/DB **does not enqueue that script**, so the TOC stays on its "No headings found" server placeholder. (This is what made it appear broken in earlier raw-insert tests — not the module.) The list is also populated **client-side**, so it only appears in a real browser, not in a raw HTML fetch. **Build TOC-containing layouts through the Theme Builder UI.**

```json
{
  "title": {
    "innerContent": {"desktop": {"value": "Table of Contents"}},
    "decoration": {"font": {"font": {"desktop": {"value": {"headingLevel": "h2"}}}}}
  },
  "list": {
    "advanced": {
      "layout":      {"desktop": {"value": {"markerStyle": "ordered"}}},
      "interaction": {"desktop": {"value": {"smoothScroll": "on", "scrollOffsetPx": "0"}}}
    }
  },
  "emptyState": {"innerContent": {"desktop": {"value": "No headings found in this post."}}},
  "builderVersion": "5.11.1"
}
```
| Field | Path | Notes |
|-------|------|-------|
| Heading | `title.innerContent.desktop.value` | plain text |
| Heading level | `title.decoration.font.font.desktop.value.headingLevel` | `h1`–`h6` |
| Marker style | `list.advanced.layout.desktop.value.markerStyle` | `"ordered"` / `"unordered"` / `"none"` |
| Smooth scroll | `list.advanced.interaction.desktop.value.smoothScroll` | `"on"` / `"off"` |
| Scroll offset | `list.advanced.interaction.desktop.value.scrollOffsetPx` | px to offset for sticky headers |
| Empty message | `emptyState.innerContent.desktop.value` | shown when no headings exist |

- Entries are generated from the page's `h1`–`h6` at render time; hidden headings are ignored and the list resyncs after responsive breakpoint changes.

---

## `divi/instagram-feed` (NEW in 5.6.0 — ⚙ source-verified)

Displays an Instagram account's recent posts in a grid. Self-closing. Requires a connected Instagram account (the `accountId` references the connection configured on the site).

```json
{
  "feed": {
    "innerContent": {"desktop": {"value": {"accountId": "", "postCount": "6"}}},
    "decoration": {"layout": {"desktop": {"value": {
      "display": "grid", "gridColumnWidths": "equal", "gridColumnCount": "3",
      "rowGap": "16px", "columnGap": "16px"
    }}}},
    "advanced": {"config": {"desktop": {"value": {"lightbox": "on"}}}}
  },
  "followButton": {"advanced": {"show": {"desktop": {"value": "on"}}}},
  "builderVersion": "5.11.1"
}
```
| Field | Path | Notes |
|-------|------|-------|
| Account | `feed.innerContent.desktop.value.accountId` | connected IG account id |
| Post count | `feed.innerContent.desktop.value.postCount` | number of posts (string) |
| Grid columns | `feed.decoration.layout.desktop.value.gridColumnCount` | grid layout (see LAYOUT §5b) |
| Lightbox | `feed.advanced.config.desktop.value.lightbox` | `"on"` / `"off"` |
| Follow button | `followButton.advanced.show.desktop.value` | `"on"` / `"off"` |

---

## `divi/charts` (NEW in 5.11.0 — ✓ render-confirmed)

Chart.js-backed data chart. **Self-closing.** No third-party plugin — Chart.js ships with Divi.

The data is a **table**, entered through Divi's `divi/table-editor` field. The stored attribute is
an **object of `columns` + `rows`** — not a flat list of rows:

```json
{
  "chart": {
    "innerContent": {"desktop": {"value": {
      "title": "Revenue by quarter",
      "data": {
        "columns": [
          {"label": "Quarter", "role": "category"},
          {"label": "Revenue", "role": "series", "color": "#5b8def"}
        ],
        "rows": [
          {"cells": ["Q1", "120"]},
          {"cells": ["Q2", "180"]}
        ]
      }
    }}},
    "advanced": {"config": {"desktop": {"value": {"type": "bar"}}}}
  },
  "builderVersion": "5.11.1"
}
```

⚠️ **These attributes are DESKTOP-ONLY.** `chart.innerContent` and `chart.advanced.config` declare
`features.responsive: false`, and `_resolve_mode_value` takes the first of `desktop`. A
`tablet`/`phone` branch is dead JSON.

### Column shape

| Key | Required | Notes |
|---|---|---|
| `label` | **yes — and must be a string** | see the trap below |
| `role` | **yes**, per column you want used | `category` · `value` · `series` · `x` · `y` · `size` |
| `visible` | no (default `true`) | only a **strict boolean `false`** hides it |
| `color` | effectively yes | per-series colour for the categorySeries family |

`highlight` / `overline` / `type` appear in the Visual Builder's column schema but the PHP render
path never reads them. Rows are `{"cells": [...]}`, positionally indexed to `columns`;
`rows[].color` sets the per-slice colour for `categoryValue` / `scatter` / `bubble`.

### The ways a chart silently draws nothing

🪤 **`label` must be present AND a string, or the column silently loses its `role`.**
`_normalize_chart_columns` keeps `role` only inside the branch guarded by
`is_array($column) && isset($column['label']) && is_string($column['label'])`. A missing, null or
**numeric** label falls to a fallback entry labelled `"Column N"` with **no role**, role
resolution fails, and the whole chart is `null`. `""` is fine; `123` is not. This is the most
likely way a hand-authored chart fails.

🪤 **PHP/VB divergence on that rule:** the Visual Builder coerces a non-string label to `""` and
*keeps* the role — so the chart renders in the builder and is blank on the front end.

🪤 **Every column needs an explicit `role`.** `_get_column_roles()` collects only roles persisted
on **visible** columns — no inference, no default.

🪤 **A row must be `{"cells": [...]}`.** `_get_row_cells()` returns `[]` for anything else and
`_to_number(null)` yields **`0`**, so a bare `["Q1","120"]` row gives empty categories and values
of zero — not an error.

🪤 **The roles a type needs differ by family:**

| Family | Chart types | Required roles |
|---|---|---|
| `categorySeries` | `line` · `area` · `bar` · `radar` | ≥1 `category` + ≥1 `series` |
| `categoryValue` | `pie` · `doughnut` · `polarArea` | ≥1 `category` + ≥1 `value` |
| `scatter` | `scatter` | `x` + `y` |
| `bubble` | `bubble` | `x` + `y` + `size` |

A `type` outside that table resolves to no family, which is also nothing. `area` is drawn as a
`line` with `fill: true`.

🚨 **A non-array `rows` is a FATAL, not a blank chart.** `count($rows)` is unguarded, so a string
there is a PHP 8 `TypeError` once role columns resolve.

🎨 **Nothing assigns colours at render time.** The Visual Builder bakes palette colours into the
persisted attrs while you edit; server-side the default palette is dead code. Hand-authored JSON
with no `color` emits datasets carrying `backgroundColor: ""` / `borderColor: ""`.

### Config toggles (`chart.advanced.config.desktop.value`)

`type` (default `"line"`) · `showTitle` · `showSubtitle` · `showLegend` · `showTooltip` (all
default `"on"`, compared as `'off' !== $value`) · **`showLegendTitle` (default `"off"`)** — the
only toggle defaulting off, so setting `legendTitle` alone shows nothing.

⛔ **There is no axis or scale surface at all in 5.11.1.** `_build_chart_options` emits only
`responsive`, `maintainAspectRatio` and `plugins`.

⛔ **CSV is a builder convenience, not an attribute.** A CSV import writes the same
`{columns:[{label}], rows:[{cells}]}` shape with **no roles and no colours**.

### ⚠️ Why "the wrapper rendered" does not prove a chart rendered

`render_callback()` never consults the chart config. It always emits the `et_pb_charts` wrapper and
a `<canvas class="et_pb_charts__canvas" role="img" aria-label="{title}">` — so the **title text is
in the markup whatever the data says** (and the chart *is* in the accessibility tree, as an image).
The data travels separately through `module_script_data()`, which calls `_build_chart_config()` and
**returns early, adding no script data at all**, when that returns `null`.

⇒ A broken chart is a 200 with a visible empty ~300px box and no error text — the
`.et_pb_charts__error` div is only written when the builder is running. **Assert on the emitted
`charts` script-data payload**, not the wrapper or the title.

⛔ The title is drawn by Chart.js **inside the canvas**: not a heading element, not selectable
text, not styled by heading presets. For real structure or SEO put a `divi/heading` above it.

> **Render-confirmed on Divi 5.11.1.** A probe page carried four valid charts — `bar` (two
> series), `line`, `pie`, `scatter` — plus a deliberately broken control using the flat
> header-row-first array, and a live `divi/text` so "the module is missing" could never be a
> symptom of the page having failed.
>
> `diviModuleChartsData` emitted **four entries, not five**. Each valid chart carried real
> numeric data and colours (`bar`: `[120,180,150,210]` and `[90,140,160,175]`); `pie` and
> `scatter` carried a per-row colour **list**, confirming the colour-axis rule. **The broken
> control emitted no entry at all — while its `et_pb_charts` wrapper and its `<canvas>` were
> both present in the HTML.**
>
> Contract read from `Packages/ModuleLibrary/Charts/ChartsModule.php` (`_build_chart_config`,
> `_normalize_chart_columns`, `_get_row_cells`, `_get_column_roles`, `_get_visible_chart_columns`,
> `_get_chart_column_role_family`, `_to_number`, `render_callback`, `module_script_data`) plus
> `_all_modules_default_render_attributes.php` for the defaults.

---

## Dynamic WordPress Modules → see MODULES-DYNAMIC

Blog, portfolio family, post* family, menu, search, login, sidebar, comments, map, breadcrumbs, and the **Loop Builder** system are documented in their own file: **DIVI5-MODULES-DYNAMIC.md**. WooCommerce modules are in **DIVI5-MODULES-WOOCOMMERCE.md**.

---

## Misc Modules

| Tag | Description | Self-closing | See |
|-----|-------------|--------------|-----|
| `divi/countdown-timer` | Countdown to a date — `date.innerContent.desktop.value: "MM/DD/YYYY HH:MM:SS"` | Yes | here |
| `divi/canvas-portal` | Off-page canvas display | Yes | MODULES-INTERACTIVE |
| `divi/fullwidth-header` | Full-width hero | Yes | MODULES-CONTENT |
| `divi/dropdown` | Dropdown / flyout panel | Yes | MODULES-INTERACTIVE |
| `divi/map`, `divi/menu`, `divi/search`, `divi/sidebar`, `divi/login`, `divi/post-nav` | dynamic / site modules | Yes | MODULES-DYNAMIC |

---

*DIVI5 Data Modules Skill — V0.6.9 | Builder Version 5.11.1 | Created by Shashank Gupta @ divilove.com*
