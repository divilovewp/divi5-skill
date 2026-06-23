---
name: divi5-base
description: Core rules, nesting hierarchy, common mistakes and validation checklist for Divi 5 JSON generation. Always attach this file alongside any other DIVI5 skill files.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Base Rules
> **Part of the DIVI5 skill set. Always attach this file. Attach module/styling files as needed.**
> Skill files: BASE (this) · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · WORDPRESS · PATTERNS

---

## 1. Non-Negotiable Rules — Always Follow These

1. **Every page content string is wrapped in `<!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder -->`.**
2. **Hierarchy is always: Section → Row → Column → Module(s).** Never skip levels.
3. **`builderVersion: "5.1.0"` must be on every single module** — section, row, column, and all content modules.
4. **Self-closing modules** end with ` /-->` (space + slash): `<!-- wp:divi/heading {...} /-->`.
5. **Container modules** (section, row, column, group, etc.) use open + close pairs.
6. **Row flex layout is driven by `flexColumnStructure` + `layout.*.value.flexWrap`** — NOT by a `display: flex` property.
7. **Column widths are set via `module.decoration.sizing.*.value.flexType`** using the `N_24` fraction system.
8. **`flexColumnStructure` count must exactly match the number of `divi/column` children** in that row.
9. **Heading `title.innerContent` is plain text only** — no HTML tags. The tag is set via `headingLevel`.
10. **Rich text content** (text, blurb body, testimonial) must HTML-encode `<` as `\u003c` and `>` as `\u003e`.
11. **Never include `groupPreset`** — it references site-specific preset IDs.
12. **Spacing is optional** — DIVI5 applies default padding when none is specified.
13. **The `data` field value is a plain string** — not a nested object.

---

## 2. Top-Level JSON Structure

```json
{
  "context": "et_builder",
  "data": {
    "11": "<!-- wp:divi/placeholder -->...PAGE_CONTENT...<!-- /wp:divi/placeholder -->"
  },
  "presets": null,
  "global_colors": [],
  "global_variables": [],
  "canvases": {"local": [], "global": []},
  "images": [],
  "thumbnails": []
}
```

### Critical: `data` Value Format

The value of `data["11"]` must be a **plain string** containing the Gutenberg markup.

❌ **Wrong** (post_type portability format):
```json
"data": {"1": {"post_content": "...", "post_title": "My Page"}}
```
✅ **Correct** (`et_builder` context — raw string):
```json
"data": {"11": "<!-- wp:divi/placeholder --><!-- wp:divi/section...<!-- /wp:divi/placeholder -->"}
```

---

## 3. Import & Export

- Upload via Divi's Import & Export UI, or create pages via the WordPress REST API (see WORDPRESS skill file).
- `context` must be `"et_builder"` — hard-validated server-side. Wrong context = import fails with `"This file should not be imported in this context."`

---

## 4. Nesting Hierarchy

```
placeholder wrapper
  └── Section
        └── Row
              └── Column
                    └── Module(s) or Group
                          └── Module(s) [if inside Group]
                          └── Nested Row → Column → Module
```

**Never place a module directly in a section or row.** Always: Section → Row → Column → Module.

### Parent–Child Rules

| Parent | Valid Children |
|--------|----------------|
| `section` | `row`, `global-layout` |
| `row` | `column` only |
| `column` | `group`, `group-carousel`, any content module, nested `row` |
| `group` | any content module, nested `row` |
| `group-carousel` | `group` |
| `accordion` | `accordion-item` |
| `counters` | `counter` |
| `contact-form` | `contact-field` |
| `pricing-tables` | `pricing-table` |
| `slider` | `slide` |
| `tabs` | `tab` |
| `social-media-follow` | `social-media-follow-network` |
| `icon-list` | `icon-list-item` |
| `video-slider` | `video-slider-item` |

---

## 5. Self-Closing vs Container Reference

**Self-closing** (end with ` /-->`):
text, heading, button, image, blurb, cta, testimonial, video, code, divider, icon, link, team-member, number-counter, circle-counter, gallery, lottie, audio, before-after-image, countdown-timer, map, menu, search, sidebar, login, canvas-portal, fullwidth-header, post-nav, accordion-item, toggle, tab, contact-field, slide, video-slider-item, counter, pricing-table, social-media-follow-network, icon-list-item, signup, blog, post-carousel, post-slider, portfolio, filterable-portfolio, comments, pagination, dropdown

**Container** (require open + close tags):
section, row, column, group, group-carousel, accordion, tabs, contact-form, counters, pricing-tables, social-media-follow, icon-list, slider, video-slider

---

## 6. Responsive Breakpoints

| Key | Screen Width |
|-----|-------------|
| `desktop` | ≥ 981px — **always required** |
| `tablet` | 768–980px |
| `phoneWide` | 480–767px |
| `phone` | < 480px |

Always provide `desktop` values. Add other breakpoints only when behavior should differ.

---

## 7. Common Mistakes & Fixes

### `innerContent.desktop.value` Must Never Be an Array
❌ `"value": [{"src": "..."}, {"src": "..."}]` — WordPress `formatting.php:ltrim()` crashes on array values → **500 Server Error**.
✅ `"value": "string"` or `"value": {"key": "string"}` — strings and objects are safe.

This affects gallery images and any field where you might try to pass a list. Arrays as `innerContent` values are not supported anywhere in the Divi 5 REST API.

### Wrong `data` field structure
❌ Nested object. ✅ Plain string (see Section 2).

### Missing `builderVersion`
❌ Any module without `"builderVersion": "5.1.0"` will fail to render or import.

### Row Flex Not Working
❌ Setting `display: flex` or `"display": "flex"` — ignored by Divi.
✅ Set `flexColumnStructure` in `module.advanced` + `flexWrap` in `module.decoration.layout`.

### HTML Tags in Heading Content
❌ `"value": "<h2>My Title</h2>"` — renders as literal text.
✅ `"value": "My Title"` — plain text. Control tag with `headingLevel: "h2"`.

### Self-Closing Syntax Error
❌ `<!-- wp:divi/text {...} -->` — opens a container, never closes.
✅ `<!-- wp:divi/text {...} /-->` — note the space before `/`.

### Missing Closing Tags
Every container needs a close: `<!-- /wp:divi/section -->`, `<!-- /wp:divi/row -->`, `<!-- /wp:divi/column -->`

### `flexColumnStructure` Mismatch
If row declares `equal-columns_3` but has only 2 `divi/column` children → broken layout. Count must match exactly.

### Missing `<!-- wp:divi/placeholder -->` Wrapper
Entire page content must be wrapped. Missing this = import failure.

### Wrong Button Attribute Names
❌ Divi 4: `url`, `newWindow`
✅ Divi 5: `linkUrl`, `linkTarget`

### Missing `settings: {}` in Variable References
❌ `$variable({"type":"color","value":{"name":"gcid-primary-color"}})$`
✅ `$variable({"type":"color","value":{"name":"gcid-primary-color","settings":{}}})$`

### Blurb Title Format
❌ `"innerContent": {"desktop": {"value": "Feature Title"}}` (plain string)
✅ `"innerContent": {"desktop": {"value": {"text": "Feature Title"}}}` (object with `text` key)

### Invalid Module Nesting
❌ Module directly in section · Module directly in row · Section nested inside column

### Number Counter — 3rd Column Hidden on Mobile
When a 3-column stats row wraps to single column on mobile, the 3rd `number-counter` can appear invisible if it ends up on a white background with default text color. Always explicitly set `color` on `number.decoration.font` and `title.decoration.font`. Never rely on defaults when sections alternate backgrounds.

### Transparent Button Background Is Invisible
❌ `"background": {"color": "transparent"}` — button text has no visible container on any background.
✅ For ghost/outline buttons, use a `border` instead:
```json
"module": {
  "decoration": {
    "background": {"desktop": {"value": {"color": "transparent"}}},
    "border": {"desktop": {"value": {"styles": {"all": {
      "width": "2px", "color": "#FFFFFF", "style": "solid"
    }}, "radius": {"topLeft": "8px", "topRight": "8px",
      "bottomLeft": "8px", "bottomRight": "8px", "sync": "on"
    }}}}
  }
}
```

### Button Centering — Use `module.advanced.alignment`

The simplest and most reliable way to center a `divi/button` is `module.advanced.alignment`. It works standalone without touching the parent column:

```json
"module": {
  "advanced": {
    "alignment": {
      "desktop": {"value": "center"},
      "tablet":  {"value": "center"},
      "phone":   {"value": "center"}
    }
  }
}
```

Set it on every breakpoint — alignment does not inherit across breakpoints. Omitting tablet/phone causes the button to fall back to left-aligned on those sizes.

**Alternative (flex-based):** `module.decoration.layout` with `display: "flex"` and `justifyContent: "center"` also works but requires the same values set on the parent column for every breakpoint. Prefer `module.advanced.alignment` — it is self-contained and avoids column coordination.

### Column Padding + Module Internal Padding Double-Up
Modules like `testimonial`, `blurb`, and `cta` have their own internal padding (typically 40px). If you also add padding to the wrapping `column`, both compound and the usable text area shrinks significantly — cards look cramped even though the column width is adequate. **Rule:** let modules define their own internal spacing; columns should only provide structural layout (flex widths, responsive stacking). Do not set `spacing.padding` on columns unless the child module has no internal padding.

### `divi/audio` src Must Be a Plain String, Not an Object
❌ `"audio": {"innerContent": {"desktop": {"value": {"src": "https://...mp3"}}}}` — crashes WP with 500 (`ltrim(): array given` in AudioModule.php)
✅ `"audio": {"innerContent": {"desktop": {"value": "https://...mp3"}}}` — plain string URL

This differs from `divi/video` which uses `{"src": "..."}` as an object. Audio uses a bare string.

### Standalone Button — Styling Goes Under `module.decoration`, Not `button.decoration`
For `divi/button`, background color, font color, border, and padding are set at `module.decoration`, not inside the `button` field:

❌ Wrong:
```json
"button": {
  "innerContent": {"desktop": {"value": {...}}},
  "decoration": {"background": {"desktop": {"value": {"color": "#2563eb"}}}}
}
```
✅ Correct:
```json
"button": {
  "innerContent": {"desktop": {"value": {"text": "...", "linkUrl": "...", "linkTarget": "off"}}}
},
"module": {
  "decoration": {
    "background": {"desktop": {"value": {"color": "#2563eb"}}},
    "layout": {"desktop": {"value": {"justifyContent": "center"}}}
  }
}
```
Note: the `button.decoration` path is used by sub-button fields inside other modules (e.g., `divi/cta`), not on a standalone `divi/button`.

### Side-by-Side Buttons

Two `divi/button` modules in a column stack vertically by default. To place them side by side, set `flexDirection: "row"` on the **column**:

```json
"module": {
  "decoration": {
    "layout": {
      "desktop": {"value": {"flexDirection": "row", "alignItems": "center"}},
      "phone":   {"value": {"flexDirection": "column"}}
    }
  }
}
```

Set `phone` back to `"column"` so buttons stack on mobile.

### Spacing Sync Fields Are Strings, Not Booleans

`syncVertical` and `syncHorizontal` must be the string `"on"` or `"off"`, not `true`/`false`:

✅ `"padding": {"top": "1rem", "bottom": "1rem", "syncVertical": "on", "left": "2rem", "right": "2rem", "syncHorizontal": "on"}`
❌ `"padding": {"top": "1rem", "syncVertical": true}` — booleans silently ignored

### `divi/blurb` Without Icon/Image Source
If `imageIcon.innerContent.desktop.value.src` is an empty string `""`, Divi may render a blank space above the title. Either provide a valid image URL, or omit the `imageIcon` block entirely to render title+text only without an icon placeholder.

---

## 8. Validation Checklist

**Root structure:**
- [ ] `"context": "et_builder"` present
- [ ] `"data"` has one key (integer string), value is plain string

**Content string:**
- [ ] Starts with `<!-- wp:divi/placeholder -->`
- [ ] Ends with `<!-- /wp:divi/placeholder -->`
- [ ] Every section → row → column chain is intact

**Modules:**
- [ ] Every module has `"builderVersion": "5.1.0"`
- [ ] Every container has matching close tag
- [ ] Every self-closing ends with ` /-->`
- [ ] `flexColumnStructure` count matches actual column count
- [ ] Mobile breakpoints set for columns + row `flexWrap: "wrap"`

**Content:**
- [ ] Heading `title.innerContent` is plain text
- [ ] Rich text uses `\u003c` / `\u003e` encoding
- [ ] Blurb title uses `{"text": "..."}` object format
- [ ] Button uses `linkUrl` / `linkTarget`
- [ ] Variable refs include `"settings": {}`
- [ ] No `groupPreset` keys

---

*DIVI5 Base Skill — V0.3.0 | Builder Version 5.1.0 | Created by Shashank Gupta @ divilove.com*
