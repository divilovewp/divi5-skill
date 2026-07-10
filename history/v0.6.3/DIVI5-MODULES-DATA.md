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
  "builderVersion": "5.9.0"
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
  "builderVersion": "5.9.0"
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
  "builderVersion": "5.9.0"
}

// counter (child — self-closing):
{
  "title":       {"innerContent": {"desktop": {"value": "WordPress Development"}}},
  "barProgress": {"innerContent": {"desktop": {"value": "95"}}},
  "builderVersion": "5.9.0"
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
    "innerContent": {"desktop": {"value": {"currency": "$", "frequency": "/month"}}}
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
  "builderVersion": "5.9.0"
}
```

**Confirmed working (real-render tested):**
- `currencyFrequency.currency` renders as small superscript before the price number
- `currencyFrequency.frequency` renders as small text after the price (e.g. `/month`)
- `content` newline-separated (`\n`) lines render as a bullet list
- `button` field works with the same structure as `divi/button`

**CRITICAL — Responsive layout:** `pricing-tables` manages its own internal flex layout and does NOT respond to the row/column breakpoint system. If you put 3 `pricing-table` children in one `pricing-tables` container, they will NOT stack on mobile — they overflow and break.

✅ **Correct responsive pattern — one table per container per column:**
```
Row (3-col)
  Column → pricing-tables → pricing-table (Plan A)
  Column → pricing-tables → pricing-table (Plan B)
  Column → pricing-tables → pricing-table (Plan C)
```
The `row()` helper then handles stacking at tablet/mobile breakpoints.

❌ **Wrong — all tables in one container:**
```
Row (1-col)
  Column → pricing-tables → pricing-table × 3   ← breaks on mobile
```

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
  "builderVersion": "5.9.0"
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
  "builderVersion": "5.9.0"
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
  "builderVersion": "5.9.0"
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
  "builderVersion": "5.9.0"
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

*DIVI5 Data Modules Skill — V0.6.3 | Builder Version 5.9.0 | Created by Shashank Gupta @ divilove.com*
