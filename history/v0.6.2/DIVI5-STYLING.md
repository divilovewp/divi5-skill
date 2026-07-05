---
name: divi5-styling
description: All decoration properties for Divi 5 JSON — background, gradients (incl. gradient variables), spacing, border, typography, text effects (gradient/image fill, stroke), sizing, position, z-index, overflow, global color/variable tokens, opacity, and HTML attributes.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Styling Properties
> **Part of the DIVI5 skill set. Attach when styling any module.**
> Skill files: BASE · LAYOUT · STYLING (this) · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS

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

### Full gradient model (expanded in 5.7.0 — ✓ render-confirmed)

The gradient object accepts these keys (all optional except `stops`):

| Key | Values | Notes |
|-----|--------|-------|
| `enabled` | `"on"` / `"off"` | turn the gradient on |
| `type` | `"linear"`, `"conic"`, `"elliptical"`, `"circular"` | `elliptical`/`circular` render as CSS `radial-gradient`; `conic` as `conic-gradient` |
| `direction` | angle `"135deg"` or keyword `"to right"` | linear direction / conic start angle |
| `directionRadial` | position `"center"`, `"top left"`, … | center point for radial/conic types |
| `stops` | array of `{position, color}` **or** a gradient-variable token string | position is a unitless number 0–100 |
| `repeat` | `"on"` / `"off"` | emits `repeating-*-gradient` |
| `length` | `"100%"` | max length of the last stop |
| `overlaysImage` | `"on"` / `"off"` | "Place Gradient Above Background Image" — paints the gradient over a background image instead of under it |

> **Direction vs position by type:** `linear` and `conic` use **`direction`** (an angle); `circular` and `elliptical` use **`directionRadial`** (a named position — one of `center`, `top left`, `top`, `top right`, `right`, `bottom right`, `bottom`, `bottom left`, `left`). You can store both; Divi reads the one matching `type`.

```json
"gradient": {
  "enabled": "on",
  "type": "conic",
  "direction": "45deg",
  "directionRadial": "center",
  "stops": [
    {"position": 0,   "color": "#f59e0b"},
    {"position": 100, "color": "#ef4444"}
  ]
}
```

### Gradient variable (NEW in 5.7.0 — ✓ render-confirmed)

Instead of an inline `stops` array, `stops` may be a **gradient-variable token string** that references a reusable global gradient. Divi resolves it to `var(--gvid-ID)`:

```json
"gradient": {
  "enabled": "on",
  "stops": "$variable({\"type\":\"gradient\",\"value\":{\"name\":\"gvid-hero-grad\",\"settings\":{}}})$"
}
```

In Python:
```python
def gradient_var(gvid):
    return '$variable({"type":"gradient","value":{"name":"' + gvid + '","settings":{}}})$'
```

The token is also accepted as `"var(--gvid-hero-grad)"` or the bare `"gvid-hero-grad"`. Define the gradient itself in `global_variables` (type `gradients`) — see §10.

**Gradient types:** `"linear"`, `"conic"`, `"elliptical"`, `"circular"`.
> ⚠️ In 5.7.0 the render switch only recognizes these four — a bare `"radial"` is **not** a distinct case and falls back to `linear`. For radial gradients use `"elliptical"` or `"circular"` and set `directionRadial`.

### Background (and its gradient) applies to nearly every module
`module.decoration.background` — and the **identical** `image` + `gradient` object documented above — works the same on container elements (`section`, `row`, `column`, `group`, `slide`) **and on essentially every content module** that has a Background option (blurb, cta, text, button, etc.). There is **one gradient model**: the same keys/values are used for a module background gradient, a text-effects fill gradient (§7b), and the `settings` embedded inside a reusable gradient variable (§10). Learn it once; it applies everywhere.

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

### Aspect ratio (NEW in 5.5.0 — ⚙ source-verified)

The sizing group on **every** module now accepts an `aspectRatio` object (width:height). Useful for images, videos, and group cards that must keep a ratio regardless of content:

```json
"sizing": {
  "desktop": {"value": {"aspectRatio": {"width": "16", "height": "9"}}}
}
```

Common ratios: `{"width":"1","height":"1"}` (square), `{"width":"4","height":"3"}`, `{"width":"16","height":"9"}`, `{"width":"3","height":"4"}` (portrait).

### Grid placement keys

When the parent container uses `display:"grid"` (see LAYOUT §5b), the sizing group also takes `gridColumnSpan`, `gridRowSpan`, `gridColumnStart/End`, `gridRowStart/End`, `gridAlignSelf`, `gridJustifySelf` to place this item within the grid.

---

## 3b. Image Framing — object-fit / object-position (NEW in 5.5.0 — ⚙ source-verified)

All modules that render an image (`image`, `blurb`, `testimonial`, `team-member`, `gallery`, `blog`, `audio`, `instagram-feed`, etc.) now expose a **framing** group under the *image element's* decoration as `fit`. It controls how the image fills its box:

```json
"image": {
  "decoration": {
    "fit": {
      "desktop": {"value": {"objectFit": "cover", "objectPosition": "center center"}}
    }
  }
}
```

- `objectFit`: `"fill"` (default), `"cover"`, `"contain"`, `"scale-down"`, `"none"`.
- `objectPosition`: any CSS position, e.g. `"center center"`, `"top center"`, `"50% 25%"`.
- The path is on the **image sub-element** of the module (e.g. `portrait.decoration.fit` on testimonial, `image.decoration.fit` on the Image module), paired with an `aspectRatio` in that element's `sizing` to crop cleanly.

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

**Font weights:** `"100"` – `"900"`, `"normal"`, `"bold"` (or `"variable"` + `weightFineTune` — §7e)
**Font styles (array):** `"italic"`, `"uppercase"`, `"underline"`, `"overline"`, `"strikethrough"`
**Text align:** `"left"`, `"center"`, `"right"`, `"justify"`

> **NEW in 5.8.0:** variable fonts, capitalization/small-caps, drop caps, text columns, vertical text direction, line-wrap/hyphenation, and decoration-line styling — all on this same `font` object. See **§7e**.

---

## 7b. Text Effects — gradient / image text fill + stroke (NEW in 5.7.0 — ✓ render-confirmed)

> Render-confirmed via REST page creation (scenarios 27–28): **linear / conic / elliptical gradient fill**, **image fill**, **stroke-only (hollow)**, **solid fill + stroke**, **gradient fill on a Text-module body**, and **gradient-variable tokens on text fill** all render with no builder-UI save — text effects are pure server-rendered CSS (unlike script-dependent modules). Gradient variables need their `--gvid-*` custom property in `:root` for REST workflows (see §10).

Every font group now has a sibling **`textEffects`** group at `<element>.decoration.font.textEffects`. It clips a gradient or image *into* the text glyphs and/or draws a stroke. It sits **next to** `font` (not inside it):

```
<element>.decoration.font.font          ← family/size/weight/color (as in §7)
<element>.decoration.font.textEffects   ← fill + stroke (this section)
```

### Keys

| Key | Values |
|-----|--------|
| `fillType` | `"none"` (default), `"transparent"`, `"gradient"`, `"image"` |
| `strokeWidth` | CSS length, e.g. `"2px"` |
| `strokeColor` | any color / color-variable |
| `gradient` | full gradient object (same model as §1) — used when `fillType: "gradient"` |
| `imageFill` | `{url, size, width, height, position, horizontalOffset, verticalOffset, repeat, blend}` — used when `fillType: "image"` |

When `fillType` is `gradient` or `image`, Divi sets `-webkit-background-clip:text` + `-webkit-text-fill-color:transparent`, so the fill replaces the normal `font.color`. `transparent` makes the text see-through (shows background through glyphs). Stroke works with any `fillType`, including alongside a fill.

### Gradient text fill (heading)

```json
"title": {
  "decoration": {
    "font": {
      "font": {"desktop": {"value": {"size": "64px", "weight": "800", "headingLevel": "h1"}}},
      "textEffects": {
        "desktop": {
          "value": {
            "fillType": "gradient",
            "gradient": {
              "enabled": "on",
              "type": "linear",
              "direction": "90deg",
              "stops": [
                {"position": 0,   "color": "#6366f1"},
                {"position": 100, "color": "#ec4899"}
              ]
            }
          }
        }
      }
    }
  }
}
```

A gradient-variable token string works here too: `"gradient": {"enabled":"on","stops":"$variable({...})$"}`.

### Image text fill

```json
"textEffects": {
  "desktop": {
    "value": {
      "fillType": "image",
      "imageFill": {
        "url": "https://example.com/texture.jpg",
        "size": "cover",
        "position": "center",
        "repeat": "no-repeat"
      }
    }
  }
}
```

`imageFill.url` also accepts a `var(--gvid-...)` image-variable reference.

### Text stroke (outline) — with no fill, or combined

```json
"textEffects": {
  "desktop": {
    "value": {
      "fillType": "transparent",
      "strokeWidth": "2px",
      "strokeColor": "#0f172a"
    }
  }
}
```

`fillType:"transparent"` + a stroke gives a hollow/outlined headline. Drop `fillType` (or keep `"none"`) to add a stroke *over* the normal solid text.

**Stroke position (NEW in 5.8.0)** — `strokePosition` controls `paint-order`: `"stroke-fill"` paints the stroke first (sits *outside* the glyph, fill on top — a clean outline that doesn't eat the letterform); any other value paints the fill first (stroke *centered* on the glyph edge, the old default). With no `strokePosition` set, Divi auto-applies `paint-order:stroke` when `strokeWidth > 1px`.

```json
"textEffects": {"desktop": {"value": {
  "strokeWidth": "3px", "strokeColor": "#0f172a", "strokePosition": "stroke-fill"
}}}
```

**Applies to** any module with a font group: heading, text (`content.decoration.bodyFont.body.font.textEffects`), blurb title, CTA, pricing, etc. — path mirrors that element's existing `font` group.

---

## 7e. Advanced Text Styling — variable fonts + new presentation options (NEW in 5.8.0 — ⚙ source-verified)

> Divi 5.8.0 added a large batch of new typography controls to **every** font group. All keys below are **siblings of `family`/`size`/`weight`** inside the same `font` value object you already use (§7) — e.g. heading = `title.decoration.font.font.desktop.value`, Text-module body = `content.decoration.bodyFont.body.font.desktop.value`, link/ul/ol/quote sub-elements = `content.decoration.bodyFont.{link,ul,ol,quote}.font`. The **only** exception is paragraph/list spacing, which lives on the sibling `list` group (see the last sub-section). Verified from `Declarations/Font/Font.php` + `Text/TextPresetAttrsMap.php` (5.8.1).

### Variable fonts
Smoothly interpolate a font's OpenType axes instead of picking a discrete weight. Requires a **variable font family** (Divi 5.8 ships the latest Google Fonts collection incl. variable fonts; a static font ignores the axes).

```json
"font": {"desktop": {"value": {
  "family": "Roboto Flex",
  "weight": "variable",
  "weightFineTune": "450",
  "variationSettings": {"WDTH": "125", "SLNT": "-6", "GRAD": "80"},
  "opticalSizing": "auto"
}}}
```
| Key | Effect |
|-----|--------|
| `weight: "variable"` | switches the field into variable-weight mode (enables `weightFineTune`) |
| `weightFineTune` | precise WGHT value (e.g. `"450"`) → `font-weight` |
| `variationSettings` | map of **axis-tag → value**. **WGHT** → `font-weight`, **WDTH** → `font-stretch` (as %), every **other** axis → `font-variation-settings: "TAG" value, …`. Values are clamped to the font's axis range. |
| `opticalSizing` | `"auto"` (default) or `"none"`/`"off"` → emits `font-optical-sizing: none`. Control optical size here — do **not** pass `OPSZ` in `variationSettings` (it's intentionally skipped). |

**Any axis the chosen font exposes works** — not just weight/width/slant. The Divi builder reads the font's axis metadata and shows one control per axis; in JSON you pass its 4-char OpenType tag. **Casing in `font-variation-settings`:** the 5 registered axes (`wght`,`wdth`,`opsz`,`slnt`,`ital`) are lower-cased; **custom/parametric axes keep their uppercase tag**. Builder-label → tag for two common variable fonts (all render-confirmed for Roboto Flex):

| Roboto Flex (builder label) | tag | Bitcount | tag |
|---|---|---|---|
| Grade | `GRAD` | Element Shape | `ELSH` |
| Thin Stroke | `YOPQ` | Element Expansion | `ELXP` |
| Thick Stroke | `XOPQ` | | |
| Counter Width | `XTRA` | | |
| Lowercase Height | `YTLC` | | |
| Uppercase Height | `YTUC` | | |
| Ascender Height | `YTAS` | | |
| Descender Depth | `YTDE` | | |
| Figure Height | `YTFI` | | |

```json
"variationSettings": {"GRAD": "120", "XTRA": "500", "YOPQ": "40", "slnt": "-6"}
```
→ `font-variation-settings:"GRAD" 120,"XTRA" 500,"YOPQ" 40,"slnt" -6`. **Bitcount's `ELSH`/`ELXP` render-confirmed too** (`variationSettings:{"ELSH":"61","ELXP":"67"}` → `font-variation-settings:"ELXP" 67,"ELSH" 61`, visible as the changed dotted-grid glyphs) — so any font's custom axes flow through identically.

### Capitalization (`capitalization`) — separate from the `style[]` array
```json
"font": {"desktop": {"value": {"capitalization": "smallCaps"}}}
```
| Value | CSS |
|-------|-----|
| `"uppercase"` / `"lowercase"` / `"capitalize"` | `text-transform` |
| `"smallCaps"` / `"allSmallCaps"` | `font-variant-caps: small-caps` / `all-small-caps` |

(The legacy `style:["uppercase"]` still works for transform; `capitalization` is the new dedicated control and is the only way to get small-caps.)

### Text-decoration line styling
The `style[]` array now also accepts **`"overline"`** (alongside `"underline"`, `"strikethrough"`, `"italic"`). New sibling keys style the line itself:
| Key | CSS |
|-----|-----|
| `lineColor` | `text-decoration-color` |
| `lineStyle` | `text-decoration-style` (`solid`/`dashed`/`dotted`/`double`/`wavy`) |
| `lineThickness` | `text-decoration-thickness` |
| `underlineOffset` | `text-underline-offset` |

### Text columns (CSS multi-column)
```json
"font": {
  "desktop": {"value": {
    "columnCount": "2", "columnGap": "2rem",
    "columnRuleWidth": "1px", "columnRuleStyle": "solid", "columnRuleColor": "#cbd5e1"
  }},
  "phone": {"value": {"columnCount": "1"}}
}
```
`columnCount` only emits when **> 1** (`1` is treated as UI-only). `columnGap` of `0` is ignored. The rule (divider line between columns) only applies when `columnCount > 1`; default rule = `solid #333` if a width is set without style/color. **⚠️ Columns do NOT auto-stack on mobile** (render-confirmed — 2 columns stayed 2-up at 390px): set a responsive `columnCount:"1"` on `phone`/`phoneWide`, same as the grid rule.

### Drop caps — dedicated `dropCap` group (NOT on `body.font`)
Drop cap is its **own group** under `bodyFont`, rendered to the `::first-letter` pseudo. Putting `dropCapLineSize` on `body.font` is wrong — it then scales the **whole paragraph** (the giant-paragraph bug). Correct path:
```json
"content": {"decoration": {"bodyFont": {"dropCap": {"font": {"desktop": {"value": {
  "dropCapLineSize": "3", "dropCapSpacing": "0.1em",
  "weight": "700", "color": "#6366f1"
}}}}}}}
```
`dropCapLineSize` → `initial-letter` (lines tall). `dropCapSpacing` → `margin-inline-end` (gap to body). The `dropCap.font` group also takes its own `family`/`weight`/`color`/`capitalization`/`style`/line-decoration + a `textShadow` — all scoped to the first letter only. Text-module only (`content.decoration.bodyFont.dropCap.font`).

### Text direction (`writingMode`)
| Value | Render |
|-------|--------|
| `"horizontal-tb"` | normal horizontal (default) |
| `"vertical-lr"` | Divi emits `writing-mode: vertical-rl` **+ `transform: rotate(180deg)`** (top-to-bottom, left column first) |

### Line wrap style (`textWrap`) + Hyphenation (`hyphens`)
```json
"font": {"desktop": {"value": {"textWrap": "balance", "hyphens": "on"}}}
```
`textWrap` → CSS `text-wrap` (`"balance"`, `"pretty"`, `"nowrap"`, `"wrap"`, `"stable"`). `hyphens: "on"` → `hyphens: auto` + `word-wrap: break-word`; `"off"` → `hyphens: none`.

### Paragraph & list spacing — on the `list` group (NOT `font`)
Controls the gap between paragraphs / list items in body copy. Lives one level over, on the sibling `list` group:
```json
"content": {"decoration": {"bodyFont": {"body": {
  "list": {"desktop": {"value": {"paragraphSpacing": "1.5em"}}}
}}}}
```
Path: `content.decoration.bodyFont.body.list.paragraphSpacing` (also `listSpacing` for list-item gaps, `itemIndent` for list padding). Render-confirmed: `paragraphSpacing` → `margin-block-end` on each paragraph (with the **last** paragraph reset to `0`), `listSpacing` → `margin-block-end` on `> *`, `itemIndent` → `padding-left` on `li`. Verified from `ListFontStyle.php`.

> ✓ **Status (render-confirmed on local Divi 5.8.1):** Every key above emitted exactly the expected CSS and rendered visually — variable axes — `font-stretch:140%/75%` (WDTH), `font-weight:650/220` (`weightFineTune`), and all 9 Roboto Flex parametric/custom axes via `font-variation-settings` (`GRAD`,`YOPQ`,`XOPQ`,`XTRA`,`YTLC`,`YTUC`,`YTAS`,`YTDE`,`YTFI`) plus `slnt` — `font-variant-caps:small-caps`, decoration lines (italic/underline/overline/strikethrough + `text-decoration-*`), `column-count`+`column-rule-*`, drop cap `initial-letter`+`margin-inline-end` (via the `dropCap` group), `writing-mode:vertical-rl`, `paint-order:stroke`, `hyphens:auto`, `text-wrap` (default/balance/pretty), paragraph spacing `margin-block-end`. All pure server-rendered CSS from `Font.php`/`ListFontStyle.php` — **no builder-UI save needed** (like Text Effects §7b). One caveat: variable-font *visual* interpolation needs the chosen family to actually be a variable font (Divi 5.8 ships them via Google Fonts).

---

## 7c. Hover (and sticky) states — nest INSIDE the breakpoint

A hover style is a **`hover` key nested inside the breakpoint, a SIBLING of `value`, with the content UN-wrapped** (no inner `value`). This is the single most common reason "my hover does nothing" — putting it at `background.hover.value.color` emits **no** `:hover` CSS at all. (Source: `MultiViewUtils.php` → each breakpoint is `{value, hover, sticky}`.)

❌ Wrong: `"background": {"hover": {"value": {"color": "#111"}}}`
✅ Correct (sibling of `value`, content un-wrapped):
```json
"background": {"desktop": {"value": {"color": "#2563eb"}, "hover": {"color": "#1e4fd0"}}},
"font": {"font": {"desktop": {"value": {"color": "#fff"}, "hover": {"color": "#fff"}}}},
"border": {"desktop": {"value": {"styles": {"all": {"width": "2px", "color": "#2563eb", "style": "solid"}}},
                       "hover":  {"styles": {"all": {"color": "#1e4fd0"}}}}}
```
Same shape for `sticky`. Works on any decoration group (background, font, border, spacing…). Render-confirmed on 5.7.4 (buttons fill on hover).

---

## 7d. Position (Advanced ▸ Position) — absolute / relative + the center-origin trap

Absolute-position an element (badge, sticker, overlay) via `module.decoration.position`:
```json
"position": {"desktop": {"value": {
  "mode": "absolute",
  "origin": {"absolute": "bottom left"},
  "offset": {"vertical": "56px", "horizontal": "-28px"}
}}},
"zIndex": {"desktop": {"value": "2"}}
```
- `origin` is keyed **by mode** (`origin.absolute` / `origin.relative`); value is `"vertical horizontal"` (top/bottom/center + left/right/center).
- `offset` = distance from those sides; **negative = overhang**.
- The **parent** must establish a positioning context: `position.mode:"relative"`.

**⚠️ Center-origin trap (render-confirmed bug):** make the parent's origin **`"top left"` with offsets 0** — NOT `"center center"`. A center origin makes Divi add `transform:translate(-50%,-50%)`, which shifts the **whole** element (it offset an entire hero image in a production build, not just the badge). `top left` + 0 = plain `position:relative` (top:0/left:0, no transform). (Source: `Position.php`.)
```json
// PARENT column/group — anchor only, no transform:
"position": {"desktop": {"value": {"mode": "relative", "origin": {"relative": "top left"},
                                   "offset": {"vertical": "0px", "horizontal": "0px"}}}}
```

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

### Font size / numeric (size) variable

```
$variable({"type":"content","value":{"name":"gvid-ID","settings":{}}})$
```

**✅ Behavior (verified on Divi 5.7.4 — supersedes the old "inlines to minimum" note):**
size/numeric variables **DO** emit a real CSS custom property. Divi writes the full
value to `:root` — e.g. `:root{--gvid-ID:clamp(2.5rem,5vw,4rem)}` — and the field
resolves to `var(--gvid-ID)`, so the size stays **fluid** (the whole `clamp()`, not
the minimum). The old Divi-5.0 finding that numeric vars collapsed to their minimum
is **false on 5.7.x** — use size/width/spacing variables freely and prefer them (see
§10b "Variables-everywhere"). *(For REST/portable pages the `:root` declaration must
exist — the builder writes it automatically; otherwise inject it via the wp_head
mu-plugin / Divi-Connect CSS injector, same as colors. The Divi Connect plugin's
free tier intentionally **bakes** size tokens to a literal — that's licensing, not a
Divi limitation; see DIVI5-CONNECT.)*

### Global font-family variable

A font-family field can reference a reusable **font variable** (`type:"font"`,
created via `POST /variables` type `font`, stored under `global_variables` →
`fonts`). Verified on 5.7.4: `Font.php` resolves it to `var(--gvid-NAME)`
and Divi emits e.g. `:root{--gvid-font-display:'Cormorant Garamond'}`.
```
$variable({"type":"font","value":{"name":"gvid-font-display","settings":{}}})$
$variable({"type":"font","value":{"name":"gvid-font-body","settings":{}}})$
```
Place it in a `font.family` value (heading, text bodyFont, button, etc.):
`"font":{"font":{"desktop":{"value":{"family":"$variable({...font...})$"}}}}`.
(The older `type:"content"` + `--et_global_heading_font` / `--et_global_body_font`
names still reference Divi's built-in theme font slots; use the `gvid-font-*` form
for your own named font tokens.)

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

### Gradient variables (NEW in 5.7.0)

Reusable gradients are stored as global variables of **type `gradients`**, keyed by `gvid-` id.

> ⚠️ **The stored `value` is NOT a CSS gradient string** (e.g. `"linear-gradient(…)"`) and **not** a bare settings object. Divi's variable sanitizer forces a gradient's `value` to a scalar, so it must be a **`$variable(...)$` payload STRING that embeds the gradient settings**. A raw CSS string saves but renders nothing and shows **empty** in the Variable Manager — this is the #1 gradient-variable mistake.

The settings inside the payload are **exactly the §1 module gradient model** (same `type` / `direction` / `directionRadial` / `stops` / `repeat` / `length` / `overlaysImage` keys) — plus `enabled` must be `"on"`. The wrapper also carries a literal `value.name: "gradient"`:

```json
"global_variables": {
  "gradients": {
    "gvid-hero-grad": {
      "label":  "Hero Gradient",
      "value":  "$variable({\"type\":\"gradient\",\"value\":{\"name\":\"gradient\",\"settings\":{\"enabled\":\"on\",\"stops\":[{\"position\":\"0\",\"color\":\"#6366f1\"},{\"position\":\"100\",\"color\":\"#ec4899\"}],\"length\":\"100%\",\"type\":\"linear\",\"direction\":\"90deg\",\"directionRadial\":\"center\",\"overlaysImage\":\"off\",\"repeat\":\"off\"}}})$",
      "status": "active",
      "order":  1
    }
  }
}
```

> **`enabled: "on"` matters:** the front-end PHP ignores it (so a gradient missing it may still render in CSS), but the builder's **Variable Manager swatch treats `enabled` ≠ `"on"` as empty**. Always include it.

**Via Divi Connect (v1.6.2+):** don't hand-build the payload — `POST /variables` (`divi_set_variables`) accepts a plain settings **object** and wraps it for you, filling defaults:
```json
{"variables":[{"id":"gvid-hero-grad","label":"Hero Gradient","type":"gradient",
  "value":{"type":"linear","direction":"90deg",
    "stops":[{"color":"#6366f1","position":0},{"color":"#ec4899","position":100}]}}]}
```
A raw CSS-gradient string is rejected with an error. (On older plugin versions, gradient variables created via REST save empty — upgrade to 1.6.2+.)

Reference the variable from any `gradient.stops` (background **or** `textEffects`) with the token:
```
$variable({"type":"gradient","value":{"name":"gvid-hero-grad","settings":{}}})$
```
Divi resolves the token to `var(--gvid-hero-grad)` and, when the value is stored in the correct payload shape above, **automatically emits the `:root{--gvid-…: linear-gradient(…)}` definition on the front end** (no mu-plugin injection needed, unlike size variables).

### Variable generators (NEW in 5.4–5.5.2)

The builder can now auto-generate whole token systems. These produce ordinary `global_colors` / `global_variables` entries — **the `$variable(...)$` reference syntax above is unchanged**; there are just more tokens to reference:

- **Fluid sizing system** — one generator spins up a full responsive `clamp()`-based size scale (numeric variables).
- **Relative color system** — derives tints/shades from a base color.
- **Color Scale generator** — a stepped scale (e.g. 50→900) from one seed color.
- **Color Harmony generator** — complementary / triadic / **tetradic** (now includes the quaternary color) palettes.

For REST-API/portable workflows you still declare the resulting tokens in `global_colors` / `global_variables` (see below) and reference them the same way. (Size/numeric tokens emit their full `clamp()` to `:root` on 5.7.x — no minimum-collapse caveat; see "Font size / numeric variable" above.)

---

## 10b. Variables-everywhere — the default, gated on availability

**Prefer tokens for every color, font-size, width/max-width, padding, margin, gap, and radius.** Tokens keep the design editable from one place and fluid (size tokens carry their `clamp()`). A stray literal where a token exists is an authoring defect (self-audit §9). This *supersedes* the obsolete advice to avoid numeric variables.

**But it is gated — never assume the site has tokens:**
1. **Check first.** `GET /design-system` returns the site's `colors` / `variables` (sizes, spacing, fonts, gradients) / presets buckets. Read what actually exists; **never invent** `gcid-*` / `gvid-*` names.
2. **If the needed tokens are absent, ASK the user** (the plugin is headless — it can't prompt): *generate a variable system, or build with inline numeric values?* Wait for the answer.
   - **Yes →** create them (`POST /colors` for `gcid-*`, `POST /variables` for `gvid-*` sizes/spacing/fonts/gradients), then build with tokens.
   - **No →** build with **inline numeric/literal values** — an accepted, consistent path (not a defect).
3. **Free/Pro reality (Divi Connect):** size-variable *generation* is Pro-gated and the free tier bakes size tokens to literal anyway. On free / a `402`, tell the user and fall back to inline for **sizes**; colors + gradients still generate on free. (See DIVI5-CONNECT.)
4. Sub-token hairlines (1–2px gaps, border widths, a 44px icon circle) may stay literal when no token that small exists — that's fine.

### Undefined `var()` renders nothing — silently
A token reference only works if the custom property is actually declared in `:root`. An **unmapped/misspelled** token (or an alias your recolor helper forgot, e.g. mapping `--brand` but not `--brand-mid`) leaves an **undefined `var()`**, and on `color` / `stroke` / `fill` that computes to the initial value (often *nothing*) — the element vanishes with **no error**. (Real bug: an SVG icon stroked with an unmapped `var(--espresso-mid)` rendered invisible.) When you alias/recolor tokens, cover **every** variant incl. `-mid` / `-soft` / `-deep`, and verify the `:root` declaration exists for every token you reference.

---

## 10c. Pseudo-class states — focus / checked / active (NEW in 5.3.0)

Form-based modules (contact-form, contact-field, signup, comments, search, login, WooCommerce fields) gained dedicated **pseudo-class editing states** in addition to `hover`. Styles for an input's focused/checked/active state are nested under `advanced.<state>` on the field element:

```json
"field": {
  "advanced": {
    "focusUseBorder": {"desktop": {"value": "on"}},
    "focus": {
      "border": {"desktop": {"value": {"styles": {"all": {"color": "#2563eb", "style": "solid", "width": "2px"}}}}}
    }
  }
}
```

- `focus` — input focus state, gated by `focusUseBorder: "on"`.
- `checked` — checkbox/radio checked state.
- `active` — pressed/active state.
- Legacy Divi 4 focus settings are auto-migrated into the new `focus` pseudo-state. See MODULES-INTERACTIVE for the harmonized form-field structure.

---

## 11. Most-Used Style Property Paths (Quick Reference)

| Property | Path |
|----------|------|
| Background color | `module.decoration.background.desktop.value.color` |
| Background image URL | `module.decoration.background.desktop.value.image.url` |
| Background image size | `module.decoration.background.desktop.value.image.size` (e.g. `"cover"`) |
| Aspect ratio | `<element>.decoration.sizing.desktop.value.aspectRatio` (`{width,height}`) |
| Image object-fit | `<imageElement>.decoration.fit.desktop.value.objectFit` |
| Image object-position | `<imageElement>.decoration.fit.desktop.value.objectPosition` |
| Text gradient/image fill | `<element>.decoration.font.textEffects.desktop.value.fillType` (+ `gradient`/`imageFill`) |
| Text stroke | `<element>.decoration.font.textEffects.desktop.value.strokeWidth` / `strokeColor` / `strokePosition` (§7b) |
| Variable font axes | `<element>.decoration.font.font.desktop.value.{weight:"variable",weightFineTune,variationSettings,opticalSizing}` (§7e) |
| Capitalization / small-caps | `...font.font.desktop.value.capitalization` (§7e) |
| Drop cap | `...font.font.desktop.value.dropCapLineSize` / `dropCapSpacing` (§7e) |
| Text columns | `...font.font.desktop.value.columnCount` / `columnGap` / `columnRule*` (§7e) |
| Text direction (vertical) | `...font.font.desktop.value.writingMode` = `"vertical-lr"` (§7e) |
| Line wrap / hyphens | `...font.font.desktop.value.textWrap` / `hyphens` (§7e) |
| Paragraph/list spacing | `content.decoration.bodyFont.body.list.desktop.value.paragraphSpacing` (§7e) |
| Gradient variable ref | `...gradient.stops` = `$variable({"type":"gradient",...})$` |
| Grid display | `module.decoration.layout.desktop.value.display` (`"grid"`) |
| Grid columns | `module.decoration.layout.desktop.value.gridColumnCount` |
| Loop enable | `<element>.advanced.loop.desktop.value.enable` (see DYNAMIC) |
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
| Hover state | `<group>.<breakpoint>.hover` (sibling of `value`, un-wrapped — §7c) |
| Position (absolute) | `module.decoration.position.desktop.value` (`mode`/`origin[mode]`/`offset`; parent `relative`+`top left` — §7d) |
| Font-family variable | `...font.font.desktop.value.family` = `$variable({"type":"font",...})$` (§10 / §10b) |
| Standalone button styling | `button.decoration.{background,border,spacing,font.font}` (NOT `module.decoration` — BASE §7) |

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

*DIVI5 Styling Skill — V0.6.2 | Builder Version 5.8.1 | Created by Shashank Gupta @ divilove.com*
