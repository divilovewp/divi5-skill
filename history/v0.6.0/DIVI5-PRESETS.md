# DIVI5-PRESETS.md — Divi 5 Global Presets (V0.6.0 / Divi 5.8.1)

Presets are saved style configurations for module types. Any module instance can reference a preset by ID; Divi merges the preset attrs with the instance's own attrs at render time.

---

## §1 Storage

WP option (logical name): **`builder_global_presets_d5`**

**IMPORTANT — actual DB key:** Divi reads/writes this option via `et_get_option()` / `et_update_option()` with `$is_product_setting=true`, which prefixes the key with `et_{shortname}_`. On a standard Divi install the actual WordPress option row is **`et_divi_builder_global_presets_d5`**. The mu-plugin endpoint uses the same Divi functions so both reads and writes hit the correct key.

### Top-level structure

```json
{
  "module": {
    "<moduleName>": {
      "default": "<preset-id>",
      "items": {
        "<preset-id>": { /* preset item — see §2 */ }
      }
    }
  },
  "group": {}
}
```

- `moduleName` = Divi block slug e.g. `"divi/heading"`, `"divi/text"`, `"divi/button"`
- `default` = ID of the preset that is auto-applied to every new instance of that module
- `items` = object keyed by preset ID

---

## §2 Preset Item Schema

```json
{
  "id":         "abc123",
  "name":       "My Heading Style",
  "moduleName": "divi/heading",
  "version": "5.8.1",
  "type":       "module",
  "created":    1749999999,
  "updated":    1749999999,
  "attrs":      { /* PRIMARY CSS bucket — drives PHP CSS generation — see §3 */ },
  "styleAttrs": { /* AUXILIARY — same structure as attrs; used by builder UI for deduplication */ },
  "renderAttrs": { /* HTML-structure attrs — see §4 */ }
}
```

**Required fields:** `id`, `name`, `moduleName`, `version`, `type`, `created`, `updated`

**Bucket priority (source-verified):**
- `attrs` is checked by `GlobalPresetItem::has_data_attrs()` → empty `attrs` means NO CSS is generated, even if `styleAttrs` has values
- `styleAttrs` is auxiliary — the builder UI reads it for deduplication; it does NOT drive PHP CSS generation
- Put all styling in **`attrs`**; mirror it in `styleAttrs` for builder-UI consistency

---

## §3 attrs / styleAttrs — Format & Key Paths

Both `attrs` and `styleAttrs` use the **same nested D5 responsive format** as page JSON:

```json
{
  "attrPath": {
    "<breakpoint>": {
      "value": { /* value object or scalar */ }
    }
  }
}
```

Breakpoints: `desktop` | `tablet` | `phone`  
State: `value` is the normal state. Hover state would add a `hover` key inside the breakpoint.

### §3a Title font attrs — `divi/heading`

Attr path root: `title.decoration.font`

| attrs key path | What it controls |
|---|---|
| `title.decoration.font.font.{bp}.value.color` | Title text color |
| `title.decoration.font.font.{bp}.value.size` | Font size (e.g. `"48px"`, `"3em"`) |
| `title.decoration.font.font.{bp}.value.family` | Font family (e.g. `"Roboto"`) |
| `title.decoration.font.font.{bp}.value.weight` | Font weight (`"700"`, `"400"`) |
| `title.decoration.font.font.{bp}.value.style` | Italic etc (`"italic"`, `"normal"`) |
| `title.decoration.font.font.{bp}.value.textAlign` | `"left"` / `"center"` / `"right"` |
| `title.decoration.font.font.{bp}.value.lineHeight` | e.g. `"1.5em"` |
| `title.decoration.font.font.{bp}.value.letterSpacing` | e.g. `"2px"` |
| `title.decoration.font.font.{bp}.value.lineColor` | Text decoration color |
| `title.decoration.font.font.{bp}.value.lineStyle` | `"underline"` / `"overline"` / etc. |
| `title.decoration.font.textShadow.{bp}.value.style` | Shadow preset name |
| `title.decoration.font.textShadow.{bp}.value.horizontal` | e.g. `"2px"` |
| `title.decoration.font.textShadow.{bp}.value.vertical` | e.g. `"2px"` |
| `title.decoration.font.textShadow.{bp}.value.blur` | e.g. `"4px"` |
| `title.decoration.font.textShadow.{bp}.value.color` | Shadow color |
| `title.decoration.font.textEffects.{bp}.value.fillType` | `"none"` / `"gradient"` / `"image"` / `"transparent"` |
| `title.decoration.font.textEffects.{bp}.value.strokeColor` | Outline/stroke color |
| `title.decoration.font.textEffects.{bp}.value.strokeWidth` | Outline width (e.g. `"2px"`) |
| `title.decoration.font.textEffects.{bp}.value.gradient` | Full gradient object |
| `title.decoration.font.textEffects.{bp}.value.imageFill.url` | Image fill URL |

### §3b Module decoration attrs (apply to ALL modules)

| attrs key path | What it controls |
|---|---|
| `module.decoration.background.{bp}.value.color` | Background color |
| `module.decoration.background.{bp}.value.gradient` | Gradient object |
| `module.decoration.background.{bp}.value.image` | Background image object |
| `module.decoration.spacing.{bp}.value.margin` | Margin (object with top/right/bottom/left) |
| `module.decoration.spacing.{bp}.value.padding` | Padding |
| `module.decoration.sizing.{bp}.value.width` | Module width |
| `module.decoration.sizing.{bp}.value.maxWidth` | Max width |
| `module.decoration.sizing.{bp}.value.alignment` | `"left"` / `"center"` / `"right"` |
| `module.decoration.border.{bp}.value.radius` | Border radius |
| `module.decoration.border.{bp}.value.styles` | Border styles object |
| `module.decoration.boxShadow.{bp}.value.style` | Shadow style preset |
| `module.decoration.boxShadow.{bp}.value.color` | Shadow color |
| `module.decoration.filters.{bp}.value.opacity` | `"50%"` etc. |
| `module.decoration.filters.{bp}.value.blur` | `"4px"` etc. |
| `module.decoration.transform.{bp}.value.scale` | Scale object |
| `module.decoration.transform.{bp}.value.rotate` | Rotate object |
| `module.decoration.animation.{bp}.value.style` | `"fade"`, `"slide"`, etc. |
| `module.decoration.animation.{bp}.value.direction` | `"left"`, `"right"`, etc. |
| `css.{bp}.value.mainElement` | Custom CSS for main element |
| `css.{bp}.value.headingContainer` | Custom CSS for `.et_pb_heading_container` (heading only) |

### §3c Text module font attrs — `divi/text`

Attr path root: `content.decoration.bodyFont`

| attrs key path | What it controls |
|---|---|
| `content.decoration.bodyFont.body.font.{bp}.value.color` | Body text color |
| `content.decoration.bodyFont.body.font.{bp}.value.size` | Font size |
| `content.decoration.bodyFont.body.font.{bp}.value.family` | Font family |
| `content.decoration.bodyFont.body.font.{bp}.value.lineHeight` | Line height |
| `content.decoration.bodyFont.link.font.{bp}.value.color` | Link color |
| `content.decoration.bodyFont.h1.font.{bp}.value.size` | H1 size inside text module |

---

## §4 renderAttrs — HTML-Affecting Attrs

Same nested format as `attrs`. Controls HTML structure/attributes, not CSS styles.

| renderAttrs key path | What it controls |
|---|---|
| `title.decoration.font.font.{bp}.value.headingLevel` | HTML tag: `"h1"` / `"h2"` / `"h3"` etc. |
| `module.advanced.html.{bp}.value.elementType` | Heading's wrapping HTML element |
| `module.decoration.sizing.{bp}.value.flexType` | Flex type (layout) |

---

## §5 REST Endpoint (mu-plugin)

Endpoint: `POST /wp-json/skill-loop/v1/global-presets`  
Auth: Application Password (same as all other skill-loop endpoints)

### Create / merge presets

```python
import requests, time

PRESETS_URL = "https://your-site.example/wp-json/skill-loop/v1/global-presets"
AUTH = ("claude", "If1f Vre2 moxv iXmE NDxX riYP")

ts = int(time.time())
preset_id = "skill-heading-dark-01"

# attrs is the PRIMARY bucket — MUST be non-empty for CSS to be generated.
# styleAttrs mirrors attrs for builder UI consistency.
style = {
    "title": {
        "decoration": {
            "font": {
                "font": {
                    "desktop": {"value": {"color": "#ffffff", "size": "48px", "weight": "700"}},
                    "tablet":  {"value": {"size": "36px"}},
                    "phone":   {"value": {"size": "28px"}}
                }
            }
        }
    },
    "module": {
        "decoration": {
            "background": {
                "desktop": {"value": {"color": "#1a1a2e"}}
            },
            "spacing": {
                "desktop": {"value": {"padding": {"top": "40px", "bottom": "40px"}}}
            }
        }
    }
}

presets = {
    "module": {
        "divi/heading": {
            "default": preset_id,
            "items": {
                preset_id: {
                    "id": preset_id,
                    "name": "Dark Heading",
                    "moduleName": "divi/heading",
                    "version": "5.8.1",
                    "type": "module",
                    "created": ts,
                    "updated": ts,
                    "attrs": style,        # PRIMARY — drives CSS generation
                    "styleAttrs": style,   # AUXILIARY — mirrors attrs for builder UI
                    "renderAttrs": {}
                }
            }
        }
    }
}

r = requests.post(PRESETS_URL, json={"presets": presets, "merge": True}, auth=AUTH)
print(r.json())
```

### Read current presets

```python
r = requests.get(PRESETS_URL, auth=AUTH)
print(r.json())
```

### Clear all presets

```python
r = requests.delete(PRESETS_URL, auth=AUTH)
print(r.json())
```

---

## §6 Applying a Preset to a Module in Page JSON

Add `modulePreset` at the top level of the module's attrs object (not nested under any decoration key):

```python
# Single preset
m('heading', {
    'modulePreset': 'skill-heading-dark-01',
    'title': {'innerContent': {'desktop': {'value': 'My Heading'}}},
    'builderVersion': '5.8.1'
})

# Stacked presets — last item wins on conflict
m('heading', {
    'modulePreset': ['base-preset-id', 'accent-preset-id'],
    'title': {'innerContent': {'desktop': {'value': 'My Heading'}}},
    'builderVersion': '5.8.1'
})

# Inline override beats preset — inline attr value wins over preset attr value
m('heading', {
    'modulePreset': 'skill-heading-dark-01',
    'title': {
        'innerContent': {'desktop': {'value': 'Red text despite preset'}},
        'decoration': {'font': {'font': {'desktop': {'value': {'color': '#ef4444'}}}}}
    },
    'builderVersion': '5.8.1'
})
```

---

## §7 Common Preset Patterns

### Typography preset (heading)
```python
def make_heading_typography_preset(id, name, color, size_desktop, size_tablet, size_phone,
                                    family=None, weight="700", align="left"):
    ts = int(time.time())
    font_val = {"color": color, "size": size_desktop, "weight": weight, "textAlign": align}
    if family:
        font_val["family"] = family
    style = {
        "title": {"decoration": {"font": {"font": {
            "desktop": {"value": font_val},
            "tablet":  {"value": {"size": size_tablet}},
            "phone":   {"value": {"size": size_phone}}
        }}}}
    }
    return {
        "id": id, "name": name, "moduleName": "divi/heading",
        "version": "5.8.1", "type": "module", "created": ts, "updated": ts,
        "attrs": style,       # PRIMARY
        "styleAttrs": style,  # AUXILIARY
        "renderAttrs": {}
    }
```

### Background + spacing preset (any module)
```python
def make_section_style_preset(id, name, module_name, bg_color, padding="60px"):
    ts = int(time.time())
    style = {
        "module": {"decoration": {
            "background": {"desktop": {"value": {"color": bg_color}}},
            "spacing":    {"desktop": {"value": {"padding": {
                "top": padding, "bottom": padding, "left": padding, "right": padding
            }}}}
        }}
    }
    return {
        "id": id, "name": name, "moduleName": module_name,
        "version": "5.8.1", "type": "module", "created": ts, "updated": ts,
        "attrs": style,       # PRIMARY
        "styleAttrs": style,  # AUXILIARY
        "renderAttrs": {}
    }
```

---

## §8 Critical Rules

1. **`attrs` is the PRIMARY CSS bucket** — `GlobalPresetItem::has_data_attrs()` checks `attrs`, not `styleAttrs`. If `attrs` is empty or missing, Divi skips CSS generation entirely for that preset, even if `styleAttrs` has values. Always put styling in `attrs`.

2. **`styleAttrs` is auxiliary** — mirrors `attrs` for builder UI deduplication. Has no effect on PHP CSS generation.

3. **Actual DB option key is `et_divi_builder_global_presets_d5`** — Divi reads/writes via `et_get_option()` / `et_update_option()` with `$is_product_setting=true`, which prepends `et_{shortname}_`. Saving with native `update_option('builder_global_presets_d5', ...)` writes to the wrong key and causes `get_selected_preset()` to return `is_exist:false`. The mu-plugin endpoint uses `et_update_option()` so this is handled correctly.

4. **Preset ID uniqueness is global** — IDs must be unique across ALL module types in the option, not just per-module.

5. **`modulePreset` is a top-level attr** — not nested under `decoration` or `advanced`. It sits at the same level as `title`, `module`, `builderVersion` etc.

6. **Stacked presets** — `modulePreset` accepts a string (single) or array (stacked). Last preset in the array wins on conflict.

7. **Inline attrs override preset attrs** — module-level inline styling always wins over preset styling.

8. **`default` preset** — setting `default` to a preset ID auto-applies it to all NEW instances in the builder. Existing instances without `modulePreset` are not affected.

9. **Cache flush** — The mu-plugin endpoint calls `ET_Core_PageResource::remove_static_resources()` to flush Divi's CSS cache after saving. Static CSS is regenerated on next page load.

---

*Real-render verified at Divi 5.7.0. Source-verified from: `GlobalPreset.php` (`get_data()`, `save_data()`, `get_selected_preset()`), `GlobalPresetItem.php` (`has_data_attrs()`, `get_data_attrs()`), `GlobalPresetItemUtils.php` (`generate_preset_class_name()`), `Module.php` (`render_styles_preset()`), `epanel/custom_functions.php` (`et_get_option()`, `et_update_option()`) — V0.5.1 / 2026-06-09*
