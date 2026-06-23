---
name: divi5-patterns
description: Card pattern decision tree, real-world layout patterns (hero, features, CTA, stats, testimonials), step-by-step build workflow, and Python generation helpers for Divi 5 JSON.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Real-World Patterns & Python Generation
> **Part of the DIVI5 skill set. Attach when building full page layouts or generating JSON programmatically.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · WORDPRESS · PATTERNS (this)

---

## 1. Card Pattern Decision Tree

Three valid approaches to cards — choose by layout complexity:

**Pattern A — Column-as-card** (most common): apply `background`, `border`, and `spacing` directly on the `divi/column`. Use when the whole column IS the card.
```
Row (equal-columns_2 or _3)
  ├── Column (bg:#1f1f1f, border-radius:2rem, padding:2rem)  ← card
  │     ├── divi/heading
  │     ├── divi/text
  │     └── divi/button
  └── Column (bg:#1f1f1f, border-radius:2rem, padding:2rem)  ← card
```

**Pattern B — Row-as-card** (for full-width cards needing inner layout): apply `background`, `border`, and `spacing` on the `divi/row`. Use when the card contains multiple sub-rows (e.g. a contact section with a title row + form row).
```
Section
  └── Row (equal-columns_1, bg:#1f1f1f, border-radius:2rem, padding:2rem)  ← card
        └── Column (24_24)
              ├── Row → divi/heading + divi/text
              └── Row → divi/contact-form
```

**Pattern C — Group-as-card** (multiple stacked cards within one column): use `divi/group` when ONE column needs to contain MULTIPLE separate styled cards stacked vertically.
```
Column (8_24 sidebar)
  ├── divi/group (bg:#1f1f1f, border-radius:1rem, padding:1rem)  ← card 1
  │     ├── divi/icon
  │     └── divi/text
  └── divi/group (bg:#1f1f1f, border-radius:1rem, padding:1rem)  ← card 2
        └── divi/text
```

**Rule:** never wrap a single-card column in a `divi/group` — if the column IS the card, style the column directly (Pattern A). Only use `divi/group` when one column holds multiple distinct cards.

---

## 2. Layout Patterns

### Single-Column Centred Content Row
For section headers, CTA text, standalone headings.
```
Row (equal-columns_1, max-width 1280px)
  └── Column (24_24)
        ├── Heading (centered)
        ├── Text (centered)
        └── Button (centered, layout.justifyContent: center)
```

### Three-Feature Card Row
```
Row (equal-columns_3, nowrap desktop, wrap mobile)
  ├── Column (8_24 → 24_24 mobile) → Blurb
  ├── Column (8_24 → 24_24 mobile) → Blurb (featured)
  └── Column (8_24 → 24_24 mobile) → Blurb
```

### Hero Section (Two-Column)
```
Section (dark bg, large padding)
  └── Row (equal-columns_2, nowrap, alignItems: center, columnGap: 60px)
        ├── Column (12_24 → 24_24, column-reverse on mobile)
        │     ├── Heading (h1, white)
        │     ├── Text (subtitle)
        │     └── Button
        └── Column (12_24 → 24_24)
              └── Image (rounded)
```

Row layout for hero (column-reverse on mobile):
```json
"layout": {
  "desktop":   {"value": {"flexWrap": "nowrap", "alignItems": "center", "columnGap": "60px"}},
  "phone":     {"value": {"flexWrap": "wrap", "flexDirection": "column-reverse"}},
  "phoneWide": {"value": {"flexWrap": "wrap"}}
}
```

### Stats Bar Pattern
```
Section (light or accent bg)
  └── Row (equal-columns_3, nowrap)
        ├── Column → number-counter
        ├── Column → number-counter
        └── Column → number-counter
```

### Testimonials Pattern
```
Section (dark bg)
  ├── Row (1-col) → Heading
  └── Row (equal-columns_2 or _3)
        └── Column(s) → Testimonial (card bg, rounded)
```

### CTA Section Pattern
```
Section (accent bg)
  └── Row (1-col)
        └── Column
              └── Group
                    ├── Heading (h2, centered)
                    ├── Text (centered)
                    └── Button (contrast color, centered)
```

### Animated Background Orbs
```
Column
  ├── Code Module (HTML: orb divs, position:fixed)
  └── Code Module (CSS: .orb animation styles, zIndex: -10)
```

### Hero Section with Background Image (Confirmed)
```
Section (bg image + dark gradient overlay, padding 120px top/bottom)
  └── Row (1-col, max-width 1280px)
        └── Column
              ├── Heading (white, centered)
              └── Text (light gray, centered)
```
```json
"background": {
  "desktop": {"value": {
    "image": {"url": "https://...", "size": "cover", "position": "center center", "repeat": "no-repeat"},
    "gradient": {"enabled": "on", "type": "linear", "direction": "180deg",
      "stops": [{"position": 0, "color": "rgba(0,0,0,0.6)"}, {"position": 100, "color": "rgba(0,0,0,0.6)"}]}
  }}
}
```

### Split Hero — Image Column + Text Column (Confirmed)
```
Section (dark bg, no padding)
  └── Row (2-col, nowrap, alignItems: stretch, maxWidth: 100%)
        ├── Column (12_24, bg image cover, minHeight: 400px, no content)
        └── Column (12_24, dark bg, generous padding, text + button)
```
The empty image-background column needs `minHeight` set or it collapses since it has no content.

### Group Card Pattern (Confirmed)
```
Row (equal-columns_3)
  └── Column × 3
        └── Group (white bg, border-radius, padding, flex column layout)
              ├── Heading (icon/emoji or title)
              ├── Heading (card title)
              └── Text (body)
```
Group attrs for a styled card:
```json
{
  "module": {
    "decoration": {
      "background": {"desktop": {"value": {"color": "#FFFFFF"}}},
      "border": {"desktop": {"value": {
        "radius": {"topLeft":"12px","topRight":"12px","bottomLeft":"12px","bottomRight":"12px","sync":"on"},
        "styles": {"all": {"width":"1px","color":"#e2e8f0","style":"solid"}}
      }}},
      "spacing": {"desktop": {"value": {"padding": {"top":"32px","bottom":"32px","left":"32px","right":"32px"}}}},
      "layout": {"desktop": {"value": {"flexDirection":"column","alignItems":"flex-start"}}}
    }
  },
  "builderVersion": "5.1.0"
}
```

### Group-Carousel Pattern (Confirmed)
```
Row (1-col, max-width 900px)
  └── Column
        └── group-carousel {"builderVersion": "5.1.0"}
              ├── Group (slide 1 — dark bg, border-radius, padding)
              │     └── text + attribution modules
              ├── Group (slide 2)
              └── Group (slide 3)
```
- Nav dots are auto-generated, one per group child
- Each group can have unique background color for per-slide styling
- No extra attrs needed on group-carousel for basic operation

### Nested Row Inside Group (Confirmed)
```
Section → Row → Column
  └── Group (styled card wrapper)
        └── Row (equal-columns_2)
              ├── Column → text modules + button
              └── Column → image
```
Full hierarchy confirmed: `section → row → column → group → row → column → module`

### Full SaaS Landing Page (Stress-Tested — All Modules Combined)

Real-render tested at 40KB markup with 9 sections. All modules render correctly together.

```
Hero          (dark)   — 2-col: heading + text + buttons | image
Stats         (light)  — 3-col: number-counter × 3
Feature Tabs  (white)  — 1-col: tabs/tab (3 tabs)
Feature Cards (light)  — 3-col: blurb × 3
Testimonials  (dark)   — 3-col: testimonial × 3
Pricing       (light)  — 3-col: pricing-tables/pricing-table (1 per col)
FAQ           (light)  — 1-col (800px): accordion + accordion-items
CTA           (blue)   — 1-col: cta module
Contact       (light)  — asymmetric 2-col: info + social | contact-form
```

Key rules that hold at scale:
- scroll-through in screenshot.js fires all intersection observers (number-counter)
- 1 pricing-table per pricing-tables per column stacks cleanly at all breakpoints
- No column padding on modules with their own internal padding
- `justifyContent: center` on buttons must be set for ALL breakpoints
- `innerContent.desktop.value` is never an array — only strings or objects

---

## 3. Step-by-Step Build Workflow

### Step 1: Plan the Layout
Sketch top-down:
```
[Section 1: Hero]         → 2-col row (text + image)
[Section 2: Stats]        → 3-col row (counters)
[Section 3: Features]     → 1-col header + 3-col cards
[Section 4: Testimonials] → 1-col header + 2-col testimonials
[Section 5: CTA]          → 1-col centered
```

### Step 2: Select Modules
| Content type | Module |
|-------------|--------|
| Paragraph / rich text | `divi/text` |
| Standalone heading | `divi/heading` |
| Button only | `divi/button` |
| Image only | `divi/image` |
| Icon + title + text | `divi/blurb` |
| Title + body + button combined | `divi/cta` |
| Quote with attribution | `divi/testimonial` |
| Animated number | `divi/number-counter` |
| FAQ expandable | `divi/accordion` |
| Custom HTML/CSS | `divi/code` |
| Grouped modules | `divi/group` |
| Carousel of groups | `divi/group-carousel` |

### Step 3: Build Each Section
1. Open section tag with attrs
2. For each row: open row → columns with modules → close row
3. Close section

### Step 4: Assemble Export JSON
1. Wrap in `<!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder -->`
2. Place as `data["11"]` string value
3. Build root JSON with `context: "et_builder"`

---

## 4. Python Generation Helpers

```python
import json
BV = "5.1.0"

# Container modules
def section(attrs, children):
    a = json.dumps(attrs, ensure_ascii=False, separators=(',', ':'))
    return f'<!-- wp:divi/section {a} -->\r\n{children}<!-- /wp:divi/section -->\r\n'

def row(attrs, children):
    a = json.dumps(attrs, ensure_ascii=False, separators=(',', ':'))
    return f'<!-- wp:divi/row {a} -->\r\n{children}<!-- /wp:divi/row -->\r\n'

def column(attrs, children):
    a = json.dumps(attrs, ensure_ascii=False, separators=(',', ':'))
    return f'<!-- wp:divi/column {a} -->\r\n{children}<!-- /wp:divi/column -->\r\n'

def group(attrs, children):
    a = json.dumps(attrs, ensure_ascii=False, separators=(',', ':'))
    return f'<!-- wp:divi/group {a} -->\r\n{children}<!-- /wp:divi/group -->\r\n'

# Self-closing module
def module(name, attrs):
    a = json.dumps(attrs, ensure_ascii=False, separators=(',', ':'))
    return f'<!-- wp:divi/{name} {a} /-->\r\n'

def make_equal_row(col_count, children_list, max_width="1280px"):
    """Build equal-column flex row. children_list = list of markup strings."""
    flex_map = {1: "24_24", 2: "12_24", 3: "8_24", 4: "6_24"}
    flex = flex_map.get(col_count, "24_24")
    row_attrs = {
        "module": {
            "advanced": {
                "flexColumnStructure": {"desktop": {"value": f"equal-columns_{col_count}"}}
            },
            "decoration": {
                "layout": {
                    "desktop":   {"value": {"flexWrap": "nowrap"}},
                    "phone":     {"value": {"flexWrap": "wrap"}},
                    "phoneWide": {"value": {"flexWrap": "wrap"}}
                },
                "sizing": {"desktop": {"value": {"maxWidth": max_width}}}
            }
        },
        "builderVersion": BV
    }
    cols = ""
    for child in children_list:
        col_attrs = {
            "module": {"decoration": {"sizing": {
                "desktop":   {"value": {"flexType": flex}},
                "phone":     {"value": {"flexType": "24_24"}},
                "phoneWide": {"value": {"flexType": "24_24"}}
            }}},
            "builderVersion": BV
        }
        cols += column(col_attrs, child)
    return row(row_attrs, cols)

def build_export(page_markup):
    """Wrap markup in root export JSON structure."""
    full = f"<!-- wp:divi/placeholder -->{page_markup}<!-- /wp:divi/placeholder -->"
    return {
        "context": "et_builder",
        "data": {"11": full},
        "presets": None,
        "global_colors": [],
        "global_variables": [],
        "canvases": {"local": [], "global": []},
        "images": [],
        "thumbnails": []
    }
```

> **HTML encoding note:** Write HTML tags in Python source normally (`"<p>Text</p>"`). `json.dumps()` handles escaping correctly. The final JSON contains properly parseable block markup.

---

*DIVI5 Patterns Skill — V0.3.0 | Builder Version 5.1.0 | Created by Shashank Gupta @ divilove.com*
