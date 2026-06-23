---
name: divi5-modules-content
description: Confirmed JSON structures for Divi 5 content modules — heading, text, button, image, blurb, CTA, testimonial, team-member, link (with menu loop), icon, icon-list, divider, code, and fullwidth-header.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Content Modules
> **Part of the DIVI5 skill set. Attach when using heading, text, button, image, blurb, CTA, testimonial, team-member, link, icon, divider, code.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT (this) · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · WORDPRESS · PATTERNS

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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
}
```

---

## `divi/button`

Renders a styled CTA button. **Self-closing.**

> Uses `linkUrl` and `linkTarget` — NOT `url`/`newWindow` (those are Divi 4 names).

```json
{
  "button": {
    "innerContent": {
      "desktop": {
        "value": {
          "text": "Get Started",
          "linkUrl": "/contact",
          "linkTarget": "off"
        }
      }
    }
  },
  "module": {
    "decoration": {
      "background": {"desktop": {"value": {"color": "#2563eb"}}},
      "border": {
        "desktop": {"value": {"radius": {
          "topLeft": "8px", "topRight": "8px",
          "bottomLeft": "8px", "bottomRight": "8px", "sync": "on"
        }}}
      },
      "spacing": {
        "desktop": {"value": {"padding": {
          "top": "18px", "bottom": "18px", "left": "48px", "right": "48px"
        }}}
      },
      "layout": {"desktop": {"value": {"justifyContent": "center"}}}
    }
  },
  "builderVersion": "5.1.0"
}
```

**`linkTarget`:** `"off"` = same tab, `"on"` = new tab

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
  "builderVersion": "5.1.0"
}
```

---

## `divi/blurb`

Icon/image + title + content. Feature cards. **Self-closing.**

> Blurb `title.innerContent` uses `{"text": "..."}` object format — NOT a plain string.

```json
{
  "imageIcon": {
    "innerContent": {
      "desktop": {"value": {"src": "https://example.com/icon.svg"}}
    }
  },
  "title": {
    "innerContent": {
      "desktop": {"value": {"text": "Feature Title"}}
    },
    "decoration": {
      "font": {
        "font": {
          "desktop": {"value": {
            "headingLevel": "h3", "size": "22px", "weight": "700",
            "color": "#1F2937", "textAlign": "center"
          }}
        }
      }
    }
  },
  "content": {
    "innerContent": {
      "desktop": {"value": "\u003cp\u003eFeature description here.\u003c/p\u003e"}
    },
    "decoration": {
      "bodyFont": {"body": {"font": {"desktop": {"value": {
        "color": "#374151", "textAlign": "center"
      }}}}}
    }
  },
  "module": {
    "decoration": {
      "background": {"desktop": {"value": {"color": "#FFFFFF"}}},
      "border": {
        "desktop": {"value": {"radius": {
          "topLeft": "16px", "topRight": "16px",
          "bottomLeft": "16px", "bottomRight": "16px", "sync": "on"
        }}}
      },
      "spacing": {"desktop": {"value": {"padding": {
        "top": "40px", "bottom": "40px", "left": "32px", "right": "32px"
      }}}}
    }
  },
  "builderVersion": "5.1.0"
}
```

❌ `"innerContent": {"desktop": {"value": "Feature Title"}}` — plain string, WRONG for blurb title
✅ `"innerContent": {"desktop": {"value": {"text": "Feature Title"}}}` — object with `text` key

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
  "builderVersion": "5.1.0"
}
```

**Confirmed (real-render tested):** All three fields render — title with font styling, body text, and button with background + text color. The `cta` is a convenient single-module alternative to separate heading + text + button modules.

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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
        'builderVersion': '5.1.0',
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
  "builderVersion": "5.1.0"
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
{"builderVersion": "5.1.0"}

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
  "builderVersion": "5.1.0"
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

```json
{
  "module": {
    "decoration": {
      "spacing": {"desktop": {"value": {"margin": {"top": "16px", "bottom": "16px"}}}}
    }
  },
  "builderVersion": "5.1.0"
}
```

**⚠️ Default color is invisible on dark/colored backgrounds.** The divider uses the theme's default line color, which blends into non-white sections. Always set an explicit border color when using on colored backgrounds:
```json
"module": {
  "decoration": {
    "border": {"desktop": {"value": {"styles": {"bottom": {
      "color": "rgba(255,255,255,0.3)", "width": "1px", "style": "solid"
    }}}}}
  }
}
```

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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
    "innerContent": {"desktop": {"value": "<p>Body paragraph text.</p>"}}
  },
  "buttonOne": {
    "innerContent": {"desktop": {"value": {"text": "Primary CTA", "linkUrl": "#"}}}
  },
  "buttonTwo": {
    "innerContent": {"desktop": {"value": {"text": "Secondary CTA", "linkUrl": "#"}}}
  },
  "builderVersion": "5.1.0"
}
```

**⚠️ Button structure is unique to fullwidth-header.** Both the label AND the URL go in `innerContent.desktop.value` as a single object `{text, linkUrl}`. Using a plain string for `innerContent` or putting the link in `advanced.link` crashes WordPress with a MultiView TypeError.

**`module.advanced.text.text.desktop.value.orientation`:**
- `"center"` — full-width centered text layout (no image split). Use for text-only heroes.
- `"left"` — text on left, image on right (default split layout). Provide an `image.innerContent.desktop.value.src` for the right side.

**Nesting:** `fullwidth-header` goes directly inside a fullwidth section — no `divi/row` or `divi/column` wrapper.

---

*DIVI5 Content Modules Skill — V0.3.0 | Builder Version 5.1.0 | Created by Shashank Gupta @ divilove.com*
