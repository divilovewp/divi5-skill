---
name: divi5-styling
description: All decoration properties for Divi 5 JSON — background, spacing, border, typography, sizing, position, z-index, overflow, global color/variable tokens, opacity, and HTML attributes.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Styling Properties
> **Part of the DIVI5 skill set. Attach when styling any module.**
> Skill files: BASE · LAYOUT · STYLING (this) · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · WORDPRESS · PATTERNS

---

## 1. Background

### Solid color
```json
"background": {
  "desktop": {"value": {"color": "#0f172a"}}
}
```

### Background image (confirmed working on sections, rows, columns, groups, slides)
```json
"background": {
  "desktop": {
    "value": {
      "image": {
        "url": "https://example.com/photo.jpg",
        "size": "cover",
        "position": "center center",
        "repeat": "no-repeat"
      }
    }
  }
}
```

**`size` options:** `"cover"`, `"contain"`, `"auto"`, or explicit e.g. `"1920px 800px"`
**`position` options:** `"center center"`, `"top center"`, `"bottom left"`, etc.
**`repeat` options:** `"no-repeat"`, `"repeat"`, `"repeat-x"`, `"repeat-y"`

### Background image + gradient overlay (confirmed)
Gradient renders on top of the image — use semi-transparent gradient stops for a dark overlay:
```json
"background": {
  "desktop": {
    "value": {
      "image": {
        "url": "https://example.com/photo.jpg",
        "size": "cover",
        "position": "center center",
        "repeat": "no-repeat"
      },
      "gradient": {
        "enabled": "on",
        "type": "linear",
        "direction": "180deg",
        "stops": [
          {"position": 0,   "color": "rgba(15,23,42,0.75)"},
          {"position": 100, "color": "rgba(15,23,42,0.75)"}
        ]
      }
    }
  }
}
```
Use uniform stop colors for a flat overlay. Use two different stops for a directional fade.

### Gradient only
```json
"background": {
  "desktop": {
    "value": {
      "gradient": {
        "enabled": "on",
        "type": "linear",
        "direction": "135deg",
        "stops": [
          {"position": 0,   "color": "#0f172a"},
          {"position": 100, "color": "#1e293b"}
        ]
      }
    }
  }
}
```

**Gradient types:** `"linear"`, `"radial"`, `"circular"`

### Background applies to all container elements
`module.decoration.background` works identically on: `section`, `row`, `column`, `group`, `slide`. The same `image` + `gradient` format applies everywhere.

---

## 2. Spacing (Padding & Margin)

```json
"spacing": {
  "desktop": {
    "value": {
      "padding": {
        "top": "80px", "bottom": "80px",
        "left": "20px", "right": "20px",
        "syncVertical": "off", "syncHorizontal": "off"
      },
      "margin": {"top": "0px", "bottom": "40px"}
    }
  },
  "tablet": {"value": {"padding": {"top": "60px", "bottom": "60px"}}},
  "phone":  {"value": {"padding": {"top": "40px", "bottom": "40px"}}}
}
```

---

## 3. Sizing

```json
"sizing": {
  "desktop": {
    "value": {
      "width": "100%",
      "maxWidth": "1280px",
      "minHeight": "100vh",
      "flexType": "12_24"
    }
  }
}
```

---

## 4. Border

```json
"border": {
  "desktop": {
    "value": {
      "styles": {
        "all": {"width": "1px", "color": "rgba(255,255,255,0.1)", "style": "solid"}
      },
      "radius": {
        "topLeft": "16px", "topRight": "16px",
        "bottomLeft": "16px", "bottomRight": "16px",
        "sync": "on"
      }
    }
  }
}
```

---

## 5. Box Shadow

```json
"boxShadow": {
  "desktop": {
    "value": {
      "horizontal": "0px",
      "vertical": "9px",
      "blur": "15px",
      "spread": "0px",
      "position": "outer",
      "color": "#2563eb"
    }
  }
}
```

---

## 6. Layout (on Modules / Columns / Groups — NOT Rows)

Controls flex behavior inside a column or group. On rows, only `flexWrap` is relevant.

```json
"layout": {
  "desktop": {
    "value": {
      "justifyContent": "center",
      "alignItems": "center",
      "flexDirection": "column",
      "rowGap": "20px",
      "columnGap": "20px"
    }
  }
}
```

---

## 7. Typography

### Heading / Title font (`title.decoration.font.font`)

```json
"font": {
  "desktop": {
    "value": {
      "family":        "Outfit",
      "size":          "48px",
      "weight":        "800",
      "style":         ["uppercase"],
      "lineHeight":    "1.2",
      "letterSpacing": "0.05em",
      "textAlign":     "center",
      "color":         "#FFFFFF",
      "headingLevel":  "h2"
    }
  }
}
```

### Body / Content font (`content.decoration.bodyFont.body.font`)

```json
"font": {
  "desktop": {
    "value": {
      "family":     "Inter",
      "size":       "18px",
      "weight":     "400",
      "lineHeight": "1.7",
      "color":      "#64748b",
      "textAlign":  "left"
    }
  }
}
```

**Font weights:** `"100"` – `"900"`, `"normal"`, `"bold"`
**Font styles (array):** `"italic"`, `"uppercase"`, `"underline"`, `"line-through"`
**Text align:** `"left"`, `"center"`, `"right"`, `"justify"`

---

## 8. Z-Index

```json
"zIndex": {"desktop": {"value": "-10"}}
```

---

## 9. Admin Label & Custom CSS Class

```json
"module": {
  "meta": {
    "adminLabel": {"desktop": {"value": "Hero Section"}}
  },
  "advanced": {
    "htmlAttributes": {
      "class": {"desktop": {"value": "my-custom-class"}},
      "id":    {"desktop": {"value": "hero-section"}}
    }
  }
}
```

---

## 10. Global Design Tokens (Variables) — Confirmed

### Color variable syntax

```
$variable({"type":"color","value":{"name":"gcid-ID","settings":{}}})$
```

In Python (avoid f-strings with nested braces — use string concatenation):
```python
def color_var(gcid):
    return '$variable({"type":"color","value":{"name":"' + gcid + '","settings":{}}})$'

def color_var_opacity(gcid, opacity):
    return '$variable({"type":"color","value":{"name":"' + gcid + '","settings":{"opacity":' + str(opacity) + '}}})$'
```

### Color variable with opacity

Add `"opacity": N` to `settings` to apply opacity (1–100) to a global color token:

```json
"color": "$variable({\"type\":\"color\",\"value\":{\"name\":\"gcid-panel-bg\",\"settings\":{\"opacity\":40}}})$"
```

`opacity: 40` renders the color at 40% opacity. Works on any color property (background, font, border).

**Critical:** Always include `"settings":{}` (or `"settings":{"opacity":N}`). When JSON-serialized, inner quotes become `\"`:
```json
"color": "$variable({\"type\":\"color\",\"value\":{\"name\":\"gcid-brand-dark\",\"settings\":{}}})}$"
```

### How color variables resolve (confirmed)

Divi converts `$variable({"type":"color",...})$` into CSS custom property references:
```css
background-color: var(--gcid-brand-dark) !important;
color: var(--gcid-brand-white) !important;
```

For these to resolve, the CSS custom property values must be defined in `:root`. Divi's builder UI handles this automatically. **For REST API workflows**, you must inject the definitions manually.

### REST API global colors workflow (confirmed working)

**Step 1** — Store colors in WP options via the `skill-loop/v1/global-colors` mu-plugin endpoint:
```python
colors = [
    ["gcid-brand-primary", {"color": "#2563eb", "status": "active", "label": "Brand Primary"}],
    ["gcid-brand-dark",    {"color": "#0f172a", "status": "active", "label": "Brand Dark"}],
    # ...
]
requests.post("http://site.local/wp-json/skill-loop/v1/global-colors",
              headers=auth_headers, json={"global_colors": colors})
```

**Step 2** — The `divi-global-colors-rest.php` mu-plugin injects into `wp_head`:
```html
<style>:root{--gcid-brand-primary:#2563eb;--gcid-brand-dark:#0f172a;...}</style>
```

**Step 3** — Use variable syntax in markup. Divi processes it to `var(--gcid-*)` which resolves via the injected CSS.

Works on: `background.color`, `font.color`, `border.color`, and any other string color property.

### Font size / numeric variable

```
$variable({"type":"content","value":{"name":"gvid-ID","settings":{}}})$
```

**⚠️ Behavior:** Content variables are NOT converted to CSS `var(--gvid-*)` references. Divi inlines a simplified literal value instead. For `clamp(2.5rem, 5vw, 4rem)`, Divi uses `2.5rem` (the minimum). Use color variables freely — avoid numeric variables if precise clamp() values are needed.

### Global font family variable

```
$variable({"type":"content","value":{"name":"--et_global_heading_font","settings":{}}})$
$variable({"type":"content","value":{"name":"--et_global_body_font","settings":{}}})$
```

### Defining `global_colors` in export JSON

```json
"global_colors": [
  ["gcid-primary-color", {"color": "#0f172a", "status": "active", "label": "Primary Color"}],
  ["gcid-body-color",    {"color": "#e2e8f0", "status": "active", "label": "Body Text"}]
]
```

### Defining `global_variables` (font sizes)

```json
"global_variables": [
  {
    "id": "gvid-1ndmhhes58",
    "label": "Big Heading",
    "value": "clamp(2.5rem, 6vw, 5rem)",
    "status": "active",
    "lastUpdated": "2026-03-28T12:00:00.000Z",
    "order": "1",
    "type": "numbers"
  }
]
```

---

## 11. Most-Used Style Property Paths (Quick Reference)

| Property | Path |
|----------|------|
| Background color | `module.decoration.background.desktop.value.color` |
| Background image URL | `module.decoration.background.desktop.value.image.url` |
| Background image size | `module.decoration.background.desktop.value.image.size` (e.g. `"cover"`) |
| Section padding | `module.decoration.spacing.desktop.value.padding` |
| Border radius | `module.decoration.border.desktop.value.radius` |
| Box shadow | `module.decoration.boxShadow.desktop.value` |
| Max width | `module.decoration.sizing.desktop.value.maxWidth` |
| Column width | `module.decoration.sizing.desktop.value.flexType` |
| Row flex wrap | `module.decoration.layout.desktop.value.flexWrap` |
| Row col structure | `module.advanced.flexColumnStructure.desktop.value` |
| Heading text | `title.innerContent.desktop.value` (plain text) |
| Heading level | `title.decoration.font.font.desktop.value.headingLevel` |
| Body font color | `content.decoration.bodyFont.body.font.desktop.value.color` |
| Text alignment | `...font.desktop.value.textAlign` |
| Admin label | `module.meta.adminLabel.desktop.value` |
| Z-index | `module.decoration.zIndex.desktop.value` |
| HTML anchor id | `module.decoration.attributes.desktop.value.attributes[].value` |

---

## 12. HTML Attributes (Anchor IDs)

Use `module.decoration.attributes` to set HTML attributes on any module — most commonly an `id` for anchor link navigation:

```json
"attributes": {
  "desktop": {
    "value": {
      "attributes": [
        {
          "id": "UNIQUE_ITEM_ID",
          "name": "id",
          "value": "my-section",
          "adminLabel": "Section anchor",
          "targetElement": "main"
        }
      ]
    }
  }
}
```

- `name`: HTML attribute name — `"id"`, `"class"`, `"data-*"`
- `value`: the rendered value (e.g. `"my-section"` → `<section id="my-section">`)
- `targetElement`: `"main"` targets the module's outer wrapper element
- `id`: any short unique string (internal Divi ID, not rendered)

In Python:
```python
def html_attr(attr_name, attr_value, label=''):
    return {
        'attributes': {
            'desktop': {
                'value': {
                    'attributes': [{
                        'id': uid(),
                        'name': attr_name,
                        'value': attr_value,
                        'adminLabel': label,
                        'targetElement': 'main'
                    }]
                }
            }
        }
    }
```

---

*DIVI5 Styling Skill — V0.3.0 | Builder Version 5.1.0 | Created by Shashank Gupta @ divilove.com*
