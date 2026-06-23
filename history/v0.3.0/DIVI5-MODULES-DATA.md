---
name: divi5-modules-data
description: Confirmed JSON structures for Divi 5 data modules — number-counter, circle-counter, bar counters, pricing tables, social media follow, countdown-timer, and dynamic WordPress module reference.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Data, Counter, Pricing & Social Modules
> **Part of the DIVI5 skill set. Attach when using counters, pricing tables, social media, dynamic WordPress modules, or misc modules.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA (this) · WORDPRESS · PATTERNS

---

## `divi/number-counter`

Animated number counter. **Self-closing.**

> `enablePercentSign` uses `"on"` / `"off"` string values.

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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
}

// counter (child — self-closing):
{
  "title":       {"innerContent": {"desktop": {"value": "WordPress Development"}}},
  "barProgress": {"innerContent": {"desktop": {"value": "95"}}},
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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

## Dynamic WordPress Modules

These require WordPress content to be present on the target site.

| Tag | Description |
|-----|-------------|
| `divi/blog` | Blog post grid |
| `divi/post-carousel` | Posts in carousel |
| `divi/post-slider` | Posts in slider |
| `divi/post-title` | For single post templates |
| `divi/portfolio` | Divi Project CPT |
| `divi/filterable-portfolio` | With category filters |
| `divi/comments` | WordPress comments |
| `divi/pagination` | Loop pagination |

All are **self-closing**. Minimal: `{"builderVersion": "5.1.0"}`

---

## Misc Modules

| Tag | Description | Self-closing |
|-----|-------------|--------------|
| `divi/countdown-timer` | Countdown to a date — use `date.innerContent.desktop.value: "MM/DD/YYYY HH:MM:SS"` | Yes |
| `divi/map` | Google Maps embed | Yes |
| `divi/menu` | Navigation menu | Yes |
| `divi/search` | Search box | Yes |
| `divi/sidebar` | Widget sidebar | Yes |
| `divi/login` | Login form | Yes |
| `divi/dropdown` | Dropdown content | Yes |
| `divi/canvas-portal` | Off-page canvas display | Yes |
| `divi/fullwidth-header` | Full-width hero | Yes |
| `divi/post-nav` | Previous/next navigation | Yes |

---

*DIVI5 Data Modules Skill — V0.3.0 | Builder Version 5.1.0 | Created by Shashank Gupta @ divilove.com*
