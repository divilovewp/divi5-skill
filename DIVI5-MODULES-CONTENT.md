---
name: divi5-modules-content
description: Confirmed JSON structures for Divi 5 content modules — heading, text, button, image, blurb, CTA, testimonial, team-member, link (with menu loop), icon, icon-list, divider, code, and fullwidth-header.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Content Modules
> **Part of the DIVI5 skill set. Attach when using heading, text, button, image, blurb, CTA, testimonial, team-member, link, icon, divider, code, svg, timeline, breadcrumbs.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT (this) · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS

---

## `divi/heading`

Renders a standalone heading element. **Self-closing.**

> `"inlineEditor": "plainText"` — title value MUST be plain text. HTML tag set via `headingLevel`.

```json
{
  "title": {
    "innerContent": {
      "desktop": {"value": "Your Heading Text Here"}
    },
    "decoration": {
      "font": {
        "font": {
          "desktop": {
            "value": {
              "headingLevel": "h2",
              "size": "48px",
              "weight": "800",
              "color": "#FFFFFF",
              "textAlign": "center"
            }
          }
        }
      }
    }
  },
  "builderVersion": "5.7.4"
}
```

**`headingLevel` options:** `"h1"`, `"h2"`, `"h3"`, `"h4"`, `"h5"`, `"h6"`

❌ `"value": "<h2>My Title</h2>"` — renders as literal text
✅ `"value": "My Title"` — plain text + `headingLevel: "h2"`

---

## `divi/text`

Renders HTML content (paragraphs, lists, etc.). **Self-closing.**

> Uses `"inlineEditor": "richtext"` — HTML content expected, must be unicode-escaped.

```json
{
  "content": {
    "innerContent": {
      "desktop": {"value": "\u003cp\u003eYour paragraph text here.\u003c/p\u003e"}
    },
    "decoration": {
      "bodyFont": {
        "body": {
          "font": {
            "desktop": {
              "value": {
                "color": "#e2e8f0",
                "size": "18px",
                "textAlign": "center"
              }
            }
          }
        }
      }
    }
  },
  "builderVersion": "5.7.4"
}
```

---

## `divi/button`

Renders a styled CTA button. **Self-closing.**

> Uses `linkUrl` and `linkTarget` — NOT `url`/`newWindow` (those are Divi 4 names).

> **⚠️ All visible styling goes on `button.decoration` — NOT `module.decoration`** (corrected 2026-06-20, render-verified on 5.7.4; supersedes older examples that put background/border/padding on `module.decoration`). Background, border, radius, spacing(padding), and label font ALL live on the `button` element. `module.decoration` left holding the background leaves the builder's **Design ▸ Button ▸ Background** field empty. Use `module` only for the wrapper (e.g. `module.advanced.alignment` to center). See BASE §7 + STYLING §7c.

```json
{
  "button": {
    "innerContent": {
      "desktop": {"value": {"text": "Get Started", "linkUrl": "/contact", "linkTarget": "off"}}
    },
    "decoration": {
      "background": {"desktop": {"value": {"color": "#2563eb"}, "hover": {"color": "#1e4fd0"}}},
      "border": {"desktop": {"value": {"radius": {
        "topLeft": "8px", "topRight": "8px", "bottomLeft": "8px", "bottomRight": "8px", "sync": "on"
      }}}},
      "spacing": {"desktop": {"value": {"padding": {
        "top": "18px", "bottom": "18px", "left": "48px", "right": "48px"
      }}}},
      "font": {"font": {"desktop": {"value": {"color": "#FFFFFF", "weight": "700"}}}}
    }
  },
  "module": {"advanced": {"alignment": {"desktop": {"value": "center"}}}},
  "builderVersion": "5.7.4"
}
```

**`linkTarget`:** `"off"` = same tab, `"on"` = new tab.
**Hover:** the `hover` key is nested inside the breakpoint, sibling of `value` (see the `background` above) — not `background.hover.value`. (STYLING §7c.)

---

## `divi/image`

Displays an image. **Self-closing.**

```json
{
  "image": {
    "innerContent": {
      "desktop": {
        "value": {
          "src": "https://example.com/image.jpg",
          "alt": "Description of image"
        }
      }
    }
  },
  "module": {
    "decoration": {
      "sizing": {"desktop": {"value": {"width": "100%", "maxWidth": "500px"}}},
      "border": {
        "desktop": {"value": {"radius": {
          "topLeft": "1rem", "topRight": "1rem",
          "bottomLeft": "1rem", "bottomRight": "1rem", "sync": "on"
        }}}
      }
    }
  },
  "builderVersion": "5.7.4"
}
```

### Centering an image (or any block module)
`text-align:center` only centers **text** modules — it does **not** center an image, and
`module.advanced.alignment` emits no centering rule for `divi/image`. To center an image (or
any block module) horizontally, set it on the **parent column**:
`column.module.decoration.layout.desktop.value.alignItems = "center"`. The column is a flex
container, so `alignItems:center` centers its children on the cross-axis. (For a single image
you can alternatively give it a fixed `width` plus `margin-left/right:"auto"` on
`module.decoration.spacing`, but the column `alignItems:center` rule is the reliable general
one — it also centers buttons and any other block module.) Render-confirmed 5.8.0.

---

## `divi/blurb`  ✅ deep-dive render-verified (5.7.4, page 253)

Icon/image + title + content. Feature cards. **Self-closing.** Three styleable
elements beyond `module`: **`imageIcon`**, **`title`**, **`content`** (+ a
**`contentContainer`** wrapper that owns content width).

### Content — `imageIcon` (image OR font icon, toggled by `useIcon`)
`imageIcon.innerContent.desktop.value` is an **object**. `useIcon` picks which sub-field renders:

- **Image** (`"useIcon": "off"`, the default): `{"src": "<url>", "alt": "...", "id": <media-id?>}`.
  `src` supports responsive + hover + image dynamic-content.
- **Icon** (`"useIcon": "on"`): `{"icon": {"unicode": "&#xf0e7;", "type": "fa", "weight": "900"}}`
  — same `{unicode,type,weight}` shape as `divi/icon`. `type` `"fa"` (FontAwesome,
  weight `900`/`400`) or `"divi"` (Divi icon font). Render-verified with FA.

> ⚠️ **Don't leave `src: ""`.** Empty `src` with `useIcon` off renders a blank
> image box / gap. Give a real `src`, or set `useIcon: "on"` + an `icon`.

### Content — `title` is a **headingLink** (link keys are `url`/`target`)
`title.innerContent.desktop.value` is an object: `{"text": "...", "url": "...", "target": "on"|"off"}`.

- `text` is **required** and must be the object form — a plain string is wrong.
- Link the title with **`url`** + **`target`** (`"on"` → `target="_blank"`).
  ❌ `linkUrl`/`linkTarget` (the *button* keys) produce **no anchor** on a blurb.
- Renders as `<h3 class="et_pb_module_header">`; default heading level **h4** — override via
  `title.decoration.font.font…headingLevel`.
- To link the **whole blurb** instead, use the shared **`module.advanced.link`** group.

### Content — `content` (body)
`content.innerContent.desktop.value` = an **HTML string** (escape `<`/`>`),
rendered into `<div class="et_pb_blurb_description">`. Body styling →
`content.decoration.bodyFont.body.font…`; body-link styling → `content.decoration.bodyFont.link`.

### Design — blurb-UNIQUE controls (everything else = the shared panels)
| Control | Path | Notes |
|---|---|---|
| Icon color | `imageIcon.advanced.color.desktop.value` | **Defaults to the `gcid-primary-color` variable** → with no global color injected the icon takes the theme primary; set an explicit color to be safe. |
| Image/Icon placement | `imageIcon.advanced.placement.desktop.value` | `"top"` (default) or `"left"`. Emits `et_pb_blurb_position_top`/`_left`. Responsive-capable but **does NOT auto-switch** — `left` stays left on phone unless you set a `…phone.value`. |
| Image/Icon box style | `imageIcon.decoration.{background,spacing,sizing,border,animation}` | Styles the image/icon box (`.et_pb_main_blurb_image`). |
| **Content Width** | `contentContainer.decoration.sizing.maxWidth.desktop.value` | Caps the inner content block (e.g. `"260px"` → `max-width:260px`; max 1100). |
| Text color scheme | `module.advanced.text.text.desktop.value.color` | `"light"`/`"dark"` for legibility over light/dark backgrounds. |

**Custom-CSS selector hooks:** `.et_pb_main_blurb_image` (image/icon),
`.et_pb_module_header` (title), `.et_pb_blurb_content` (content wrapper),
`.et_pb_blurb_description` (body text).

```json
// Image blurb, top placement, linked title
{
  "imageIcon": {"innerContent": {"desktop": {"value": {
    "useIcon": "off", "src": "https://example.com/feature.jpg", "alt": "Feature"
  }}}},
  "title": {
    "innerContent": {"desktop": {"value": {"text": "Feature Title", "url": "/learn-more", "target": "off"}}},
    "decoration": {"font": {"font": {"desktop": {"value": {
      "headingLevel": "h3", "size": "20px", "weight": "700", "color": "#0f172a", "textAlign": "center"
    }}}}}
  },
  "content": {
    "innerContent": {"desktop": {"value": "<p>Feature description here.</p>"}},
    "decoration": {"bodyFont": {"body": {"font": {"desktop": {"value": {"color": "#475569", "textAlign": "center"}}}}}}
  },
  "module": {"decoration": {"background": {"desktop": {"value": {"color": "#FFFFFF"}}}}},
  "builderVersion": "5.7.4"
}
```

```json
// Icon blurb, left placement, custom icon color
{
  "imageIcon": {
    "innerContent": {"desktop": {"value": {"useIcon": "on", "icon": {"unicode": "&#xf0e7;", "type": "fa", "weight": "900"}}}},
    "advanced": {"color": {"desktop": {"value": "#7c3aed"}}, "placement": {"desktop": {"value": "left"}}}
  },
  "title": {"innerContent": {"desktop": {"value": {"text": "Fast"}}}},
  "content": {"innerContent": {"desktop": {"value": "<p>Blazing performance.</p>"}}},
  "builderVersion": "5.7.4"
}
```

❌ `"title.innerContent.desktop.value": "Feature Title"` — plain string, WRONG (use `{"text": …}`)
❌ blurb title link via `{"linkUrl": …, "linkTarget": …}` — those are BUTTON keys → no anchor
✅ `{"text": "Feature Title"}` + (optional) `"url"`/`"target"` for the title link

---

## `divi/cta` (Call to Action)

Title + body + button combined. **Self-closing.** Confirmed working.

```json
{
  "title": {
    "innerContent": {"desktop": {"value": "Ready to Begin?"}},
    "decoration": {"font": {"font": {"desktop": {"value": {
      "headingLevel": "h2", "size": "2.5rem", "weight": "800",
      "color": "#FFFFFF", "textAlign": "center"
    }}}}}
  },
  "content": {
    "innerContent": {"desktop": {"value": "\u003cp\u003eJoin thousands of customers.\u003c/p\u003e"}},
    "decoration": {"bodyFont": {"body": {"font": {"desktop": {"value": {
      "color": "#bfdbfe", "size": "18px", "textAlign": "center"
    }}}}}}
  },
  "button": {
    "innerContent": {"desktop": {"value": {
      "text": "Get Started", "linkUrl": "/signup", "linkTarget": "off"
    }}},
    "decoration": {
      "background": {"desktop": {"value": {"color": "#FFFFFF"}}},
      "font": {"font": {"desktop": {"value": {"color": "#2563eb", "weight": "700"}}}}
    }
  },
  "builderVersion": "5.7.4"
}
```

**Confirmed (real-render tested):** All three fields render — title with font styling, body text, and button with background + text color. The `cta` is a convenient single-module alternative to separate heading + text + button modules.

> **⚠️ `divi/cta` ALWAYS renders a default background** (Divi's theme primary color — `var(--gcid-primary-color)`), even when you set none. This is a Divi quirk. If the CTA should **not** have its own background panel (e.g. it sits inside a section that already has a background, or should blend in), you **must explicitly set the background to transparent** to remove the default:
> ```json
> "module": {"decoration": {"background": {"desktop": {"value": {"color": "rgba(0,0,0,0)"}}}}}
> ```
> Only skip this if you actually want the CTA to be its own colored panel (then set the color/gradient you want). Rule of thumb: **every `divi/cta` needs an explicit `module.decoration.background`** — either a real color or `rgba(0,0,0,0)`.

---

## `divi/testimonial`

Testimonial quote with author and optional portrait. **Self-closing.**

```json
{
  "content": {
    "innerContent": {
      "desktop": {"value": "\u003cp\u003eThis service transformed our business entirely.\u003c/p\u003e"}
    }
  },
  "author": {
    "innerContent": {"desktop": {"value": "Jane Smith"}},
    "decoration": {
      "font": {"font": {"desktop": {"value": {"color": "#F59E0B", "weight": "700"}}}}
    }
  },
  "jobTitle": {
    "innerContent": {"desktop": {"value": "CEO, Acme Corp"}}
  },
  "portrait": {
    "innerContent": {"desktop": {"value": {"url": "https://example.com/portrait.jpg"}}}
  },
  "module": {
    "decoration": {
      "background": {"desktop": {"value": {"color": "#374151"}}},
      "border": {"desktop": {"value": {"radius": {
        "topLeft": "16px", "topRight": "16px",
        "bottomLeft": "16px", "bottomRight": "16px", "sync": "on"
      }}}},
      "spacing": {"desktop": {"value": {"padding": {
        "top": "40px", "bottom": "40px", "left": "40px", "right": "40px"
      }}}}
    }
  },
  "builderVersion": "5.7.4"
}
```

---

**Testimonial portrait field uses `url`, NOT `src`** — this differs from the image module. Confirmed working in real-render testing. Portrait renders as a circular avatar above the quote.

**Confirmed fields (real-render tested):** `content` (italic quote text), `author` (name, styled in color), `jobTitle` (subtitle line), `portrait` (circular avatar). All render correctly.

---

## `divi/team-member`

Team member card with photo, name, position. **Self-closing.** (Tag is `divi/team-member`, not `divi/person`.)

```json
{
  "name":     {"innerContent": {"desktop": {"value": "Jane Smith"}}},
  "position": {"innerContent": {"desktop": {"value": "Lead Designer"}}},
  "image": {
    "innerContent": {"desktop": {"value": {"url": "https://example.com/photo.jpg"}}}
  },
  "content": {"innerContent": {"desktop": {"value": "\u003cp\u003eBio text here.\u003c/p\u003e"}}},
  "builderVersion": "5.7.4"
}
```

**Confirmed (real-render tested):** All four fields render. Default layout: image on the left with name/position/bio beside it. For portrait-style team cards, use square images (`400×400`). Bio text can wrap tightly in narrow 3-column layouts — keep bios short or use a 2-column row instead.

**Image field uses `url` (not `src`)** — same as `testimonial.portrait`. This differs from the `image` module which uses `src`.

---

## `divi/link`

A text hyperlink. **Self-closing.**

### Static link

```json
{
  "content": {
    "innerContent": {
      "desktop": {"value": {"text": "Click here", "linkUrl": "/page", "linkTarget": "off"}}
    },
    "decoration": {
      "font": {
        "font": {
          "desktop": {"value": {"weight": "400", "color": "#e2e8f0", "size": "14px"}}
        }
      }
    }
  },
  "builderVersion": "5.7.4"
}
```

Font styling goes under `content.decoration.font.font`, not `module.decoration`.

### Menu loop — renders one link per menu item (confirmed)

Use `module.advanced.loop` to loop a WordPress menu. Each item in the menu becomes a separate rendered link. **Do not use a text module with hardcoded `<a>` tags for navigation lists — use a looped link module instead.**

```json
{
  "module": {
    "advanced": {
      "loop": {
        "desktop": {
          "value": {
            "enable": "on",
            "loopId": "loop-UNIQUE10ID",
            "queryType": "menus",
            "orderBy": "menu_order",
            "subTypes": [
              {"value": "MENU_WP_ID", "label": "Menu Name"}
            ],
            "includePostWithSpecificTerms": "",
            "excludePostWithSpecificTerms": "",
            "includeSpecificPosts": "",
            "excludeSpecificPosts": ""
          }
        }
      }
    },
    "decoration": {
      "sizing": {"desktop": {"value": {"size": ["flexShrink"]}}},
      "layout": {"desktop": {"value": {"justifyContent": "start", "alignItems": "center"}}}
    }
  },
  "content": {
    "innerContent": {
      "desktop": {
        "value": {
          "text":       "$variable({\"type\":\"content\",\"value\":{\"name\":\"loop_menu_text\",\"settings\":{\"before\":\"\",\"after\":\"\",\"loop_position\":\"\"}}})$",
          "linkUrl":    "$variable({\"type\":\"content\",\"value\":{\"name\":\"loop_menu_link\",\"settings\":{\"before\":\"\",\"after\":\"\",\"loop_position\":\"\"}}})$",
          "linkTarget": "off"
        }
      }
    },
    "decoration": {
      "font": {
        "font": {
          "desktop": {"value": {"weight": "400", "color": "#e2e8f0", "size": "14px"}}
        }
      }
    }
  },
  "builderVersion": "5.7.4"
}
```

**Loop fields:**
| Field | Value | Notes |
|-------|-------|-------|
| `queryType` | `"menus"` | Loops a WordPress nav menu |
| `subTypes[].value` | `"35"` | WP menu ID (integer as string) |
| `subTypes[].label` | `"Footer Main Menu"` | Human label — not rendered |
| `loopId` | `"loop-XXXXXXXXXX"` | Unique ID — generate with `"loop-" + uid()` |
| `orderBy` | `"menu_order"` | Preserve menu order |

**Dynamic variables in `content.innerContent`:**
| Variable name | Resolves to |
|---------------|-------------|
| `loop_menu_text` | Menu item label |
| `loop_menu_link` | Menu item URL |

In Python:
```python
def loop_menu_var(name):
    return '$variable({"type":"content","value":{"name":"' + name + '","settings":{"before":"","after":"","loop_position":""}}}' + ')$'

def link_menu_loop(menu_id, menu_label, font_color='#e2e8f0', font_size='14px'):
    return {
        'module': {
            'advanced': {
                'loop': {
                    'desktop': {
                        'value': {
                            'enable': 'on',
                            'loopId': 'loop-' + uid(),
                            'queryType': 'menus',
                            'orderBy': 'menu_order',
                            'subTypes': [{'value': str(menu_id), 'label': menu_label}],
                            'includePostWithSpecificTerms': '',
                            'excludePostWithSpecificTerms': '',
                            'includeSpecificPosts': '',
                            'excludeSpecificPosts': '',
                        }
                    }
                }
            },
            'decoration': {
                'sizing': {'desktop': {'value': {'size': ['flexShrink']}}},
                'layout': {'desktop': {'value': {'justifyContent': 'start', 'alignItems': 'center'}}},
            }
        },
        'content': {
            'innerContent': {
                'desktop': {
                    'value': {
                        'text':       loop_menu_var('loop_menu_text'),
                        'linkUrl':    loop_menu_var('loop_menu_link'),
                        'linkTarget': 'off',
                    }
                }
            },
            'decoration': {
                'font': {'font': {'desktop': {'value': {'weight': '400', 'color': font_color, 'size': font_size}}}}
            }
        },
        'builderVersion': '5.7.4',
    }
```

**Note:** `MENU_WP_ID` is the WordPress database ID of the nav menu — find it at WP Admin → Appearance → Menus, or via `GET /wp-json/wp/v2/menus`.

---

## `divi/icon`

Renders a single Divi icon. **Self-closing.** **Confirmed working (real-render tested).**

```json
{
  "icon": {
    "innerContent": {
      "desktop": {"value": {"unicode": "&#xf00c;", "type": "fa", "weight": "900"}}
    },
    "advanced": {
      "color": {"desktop": {"value": "#22c55e"}},
      "size":  {"desktop": {"value": "48px"}}
    }
  },
  "builderVersion": "5.7.4"
}
```

**Icon format** — `icon.innerContent.desktop.value`:
| Key | Values | Notes |
|-----|--------|-------|
| `unicode` | `"&#xf00c;"` | HTML entity format (hex). FontAwesome: `&#xf00c;`=✓, `&#xf005;`=★, `&#xf0e0;`=✉, `&#xf095;`=☎ |
| `type` | `"fa"` / `"divi"` | `fa` = FontAwesome, `divi` = Divi icon font |
| `weight` | `"900"` / `"400"` | `900` = FA Solid, `400` = FA Regular / Divi icons |

**Icon color/size** — `icon.advanced`:
- `color.desktop.value` — any CSS color string
- `size.desktop.value` — e.g. `"24px"`, `"48px"`

---

## `divi/icon-list` + `divi/icon-list-item`

Icon list. `icon-list` is **NOT self-closing**. `icon-list-item` **IS self-closing**. **Confirmed working (real-render tested).**

```json
// icon-list (parent — container):
{"builderVersion": "5.7.4"}

// icon-list-item (child — self-closing):
{
  "icon": {
    "innerContent": {
      "desktop": {"value": {"unicode": "&#xf00c;", "type": "fa", "weight": "900"}}
    },
    "advanced": {
      "color": {"desktop": {"value": "#22c55e"}},
      "size":  {"desktop": {"value": "20px"}}
    }
  },
  "content": {
    "innerContent": {"desktop": {"value": "List item text (plain string, not HTML)"}}
  },
  "builderVersion": "5.7.4"
}
```

**`content.innerContent.desktop.value` is a plain text string** (not HTML markup).

**Pattern for a features/benefits list:**
```
Section → Row (1 col, max 800px) → Column → icon-list → icon-list-items
```

---

## `divi/divider`

A horizontal rule / decorative divider. **Self-closing.**

The divider draws its **own** line via `divider.advanced.line`, which is **`show:"on"` by default** — a line always renders. Style *that* native line; do **not** add a CSS border to recolor it.

```json
{
  "divider": {
    "advanced": {
      "line": {"desktop": {"value": {
        "show": "on", "color": "#C5622E", "style": "solid", "position": "top", "weight": "1px"
      }}}
    }
  },
  "module": {
    "decoration": {
      "spacing": {"desktop": {"value": {"margin": {"top": "16px", "bottom": "16px"}}}}
    }
  },
  "builderVersion": "5.7.4"
}
```

**⚠️ Do NOT add a `module.decoration.border` to "color" the divider — it stacks a SECOND line.** The native line is `show:"on"` by default using the theme's stock global color (`gcid-primary-color`, a blue/teal that's often wrong or invisible on colored/dark sections). A CSS border draws your line *on top of* the still-visible native one → a visible **double line**. Always recolor via `divider.advanced.line.color`. To render no line at all, set `divider.advanced.line.show` to `"off"`.

---

## `divi/code`

Renders raw HTML/CSS/JS. **Self-closing.**

```json
{
  "content": {
    "innerContent": {
      "desktop": {"value": "\u003cstyle\u003e.custom { color: red; }\u003c/style\u003e"}
    }
  },
  "module": {
    "decoration": {
      "zIndex": {"desktop": {"value": "-10"}}
    }
  },
  "builderVersion": "5.7.4"
}
```

### Animated Background Orbs (Code Module Pattern)

```html
<!-- HTML code module: -->
<div style="position:fixed;top:0;left:0;width:100%;height:100%;pointer-events:none;overflow:hidden;z-index:-10;">
  <div class="orb orb-1"></div>
  <div class="orb orb-2"></div>
</div>
```
```css
/* CSS code module: */
<style>
.orb { position:absolute; border-radius:50%; filter:blur(80px); z-index:-10; opacity:0.6; }
.orb-1 { width:300px; height:300px; background:#3b82f6; top:-50px; left:-100px; }
.orb-2 { width:400px; height:400px; background:#6366f1; bottom:10%; right:-100px; }
</style>
```

---

## `divi/fullwidth-header`

Full-width hero header with title, subhead, content, and up to 2 buttons. **Self-closing.** **Confirmed working (real-render tested).**

**Requires a fullwidth section** — the parent `divi/section` must have `module.advanced.type.desktop.value: "fullwidth"`.

```json
// Parent section (fullwidth type):
{
  "module": {
    "advanced": {"type": {"desktop": {"value": "fullwidth"}}},
    "decoration": {
      "background": {"desktop": {"value": {"color": "#0f172a"}}}
    }
  },
  "builderVersion": "5.7.4"
}

// fullwidth-header (self-closing, goes directly inside the fullwidth section — no row/column):
{
  "module": {
    "advanced": {
      "text": {"text": {"desktop": {"value": {"orientation": "center"}}}}
    },
    "decoration": {
      "spacing": {"desktop": {"value": {"padding": {"top": "120px", "bottom": "120px"}}}}
    }
  },
  "title": {
    "innerContent": {"desktop": {"value": "Hero Title Here"}},
    "decoration": {"font": {"font": {"desktop": {"value": {
      "headingLevel": "h1", "size": "3.5rem", "weight": "800",
      "color": "#FFFFFF", "textAlign": "center"
    }}}}}
  },
  "subhead": {
    "innerContent": {"desktop": {"value": "Subtitle text here"}},
    "decoration": {"font": {"font": {"desktop": {"value": {
      "size": "1.25rem", "color": "#94a3b8", "textAlign": "center"
    }}}}}
  },
  "content": {
    "innerContent": {"desktop": {"value": "\u003cp\u003eBody paragraph text.\u003c/p\u003e"}}
  },
  "buttonOne": {
    "innerContent": {"desktop": {"value": {"text": "Primary CTA", "linkUrl": "#"}}}
  },
  "buttonTwo": {
    "innerContent": {"desktop": {"value": {"text": "Secondary CTA", "linkUrl": "#"}}}
  },
  "builderVersion": "5.7.4"
}
```

**⚠️ Button structure is unique to fullwidth-header.** Both the label AND the URL go in `innerContent.desktop.value` as a single object `{text, linkUrl}`. Using a plain string for `innerContent` or putting the link in `advanced.link` crashes WordPress with a MultiView TypeError.

**`module.advanced.text.text.desktop.value.orientation`:**
- `"center"` — full-width centered text layout (no image split). Use for text-only heroes.
- `"left"` — text on left, image on right (default split layout). Provide an `image.innerContent.desktop.value.src` for the right side.

**Nesting:** `fullwidth-header` goes directly inside a fullwidth section — no `divi/row` or `divi/column` wrapper.

---

## `divi/svg` (NEW in 5.5.0 — ✓ render-confirmed)

Renders sanitized inline SVG, either from pasted markup or an uploaded `.svg` URL. Self-closing. **Confirmed (scenario 20):** inline `code` with a `<polygon>` rendered correctly; set `module.decoration.sizing.width` to size it.

```json
{
  "svg": {
    "innerContent": {
      "desktop": {"value": {
        "sourceType": "code",
        "code": "<svg viewBox='0 0 24 24'><path d='M12 2 2 22h20z'/></svg>",
        "linkUrl": "",
        "linkTarget": "off"
      }}
    }
  },
  "builderVersion": "5.7.4"
}
```

| Field (`svg.innerContent.desktop.value`) | Purpose |
|------|---------|
| `sourceType` | `"code"` (paste markup) or `"upload"` (use `src`) |
| `code` | the SVG markup — **HTML-encode** `<`/`>` as `<`/`>` like rich text |
| `src` | URL of an uploaded `.svg` file (when `sourceType:"upload"`) |
| `linkUrl` | optional URL to wrap the SVG in a link |
| `linkTarget` | `"off"` (same tab) / `"on"` (new tab) |

- Color/size: style via the SVG element selector or set `fill`/`width` in the markup. Standard `module.decoration` (spacing, animation, etc.) applies to the wrapper.
- The SVG is sanitized server-side — scripts/`on*` handlers are stripped.

---

## `divi/timeline` + `divi/timeline-item` (NEW in 5.5.2 — ✓ render-confirmed)

A vertical/horizontal timeline. **`timeline` is a container**; each `timeline-item` is a self-closing child. **Confirmed (scenario 20):** vertical timeline with 3 items rendered markers, dates, titles, and body correctly on all breakpoints.

**Parent `divi/timeline`:**
```json
{
  "module": {
    "advanced": {
      "timeline": {"desktop": {"value": {"direction": "vertical", "position": "right"}}}
    }
  },
  "builderVersion": "5.7.4"
}
```
| `module.advanced.timeline.*.value` | Values |
|------|--------|
| `direction` | `"vertical"` (default) / `"horizontal"` |
| `position` | side of the line for content: `"right"` (default) / `"left"` / `"alternate"` |

**Child `divi/timeline-item`** (self-closing):
```json
{
  "title":   {"innerContent": {"desktop": {"value": "Founded"}}},
  "date":    {"innerContent": {"desktop": {"value": "2019"}}},
  "content": {"innerContent": {"desktop": {"value": "Company launched."}}},
  "marker": {
    "decoration": {"icon": {"desktop": {"value": {"unicode": "&#xf00c;", "type": "fa", "weight": "900"}}}}
  },
  "builderVersion": "5.7.4"
}
```
| Field | Path | Notes |
|-------|------|-------|
| Title | `title.innerContent.desktop.value` | plain string |
| Date/label | `date.innerContent.desktop.value` | plain string |
| Body | `content.innerContent.desktop.value` | rich text (encode `<`/`>`) |
| Marker icon | `marker.decoration.icon.desktop.value` | `{unicode,type,weight}` (see `divi/icon`) |

```
timeline {direction, position}
  └── timeline-item (title/date/content/marker) /-->
  └── timeline-item /-->
  └── timeline-item /-->
```

---

## `divi/breadcrumbs` (NEW in 5.4.0 — ✓ render-confirmed)

Accessible breadcrumb trail using native WordPress hierarchy. Self-closing. **Primarily a Theme Builder module** — drop it in a header/body template so every post/page/archive shows its real ancestry trail. **Confirmed in a TB body template:** rendered the full trail **"Home / Uncategorized / Divi 5 Sample Post"** for a single post. It also renders on a standalone page (scenario 20: "Home / [page]"), but the trail is only meaningful in template context where the "current" item varies per view.

```json
{
  "home":      {"innerContent": {"desktop": {"value": {"text": "Home", "url": ""}}}},
  "separator": {"innerContent": {"desktop": {"value": {"text": "/"}}}},
  "trail":     {"advanced": {"htmlTag": {"desktop": {"value": "nav"}}}},
  "builderVersion": "5.7.4"
}
```
| Field | Path | Notes |
|-------|------|-------|
| Home label | `home.innerContent.desktop.value.text` | text of the first crumb |
| Home URL | `home.innerContent.desktop.value.url` | blank = site root |
| Separator | `separator.innerContent.desktop.value.text` | e.g. `"/"`, `"›"`, `"»"` |
| Wrapper tag | `trail.advanced.htmlTag.desktop.value` | `"nav"` (default) / `"div"` / `"span"` / `"p"` |

- Crumbs after Home are generated automatically from the current page's ancestry — no per-crumb markup.
- Design → Breadcrumb-links styling no longer affects the Home crumb (Home follows its own Home-Link settings).

---

*DIVI5 Content Modules Skill — V0.5.1 | Builder Version 5.7.4 | Created by Shashank Gupta @ divilove.com*
