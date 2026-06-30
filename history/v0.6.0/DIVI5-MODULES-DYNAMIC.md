---
name: divi5-modules-dynamic
description: Source-verified JSON structures for Divi 5 dynamic-content modules — blog, portfolio family, post* (title/content/slider/nav), menu, search, login, sidebar, comments, map, plus the Loop Builder query system. These modules pull from WordPress content on the target site.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Dynamic Content Modules
> **Part of the DIVI5 skill set. Attach when using blog, portfolio, post templates, menu, search, login, sidebar, comments, map, or the Loop Builder.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC (this) · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS

> **Mostly ✓ render-confirmed (5.7.0).** These modules render real WordPress content, so output depends on the target site (posts, menus, widget areas, CPTs must exist). Confirmed: blog, portfolio family, post-title/content/slider/nav, menu, search, login, sidebar, comments, Loop Builder, global-layout. Still ⚙ source-only: map/map-pin (Maps API key), instagram-feed (IG account), fullwidth variants. Defaults below are extracted from the theme's `module-default-render-attributes.json`.

---

## Shared facts

- All modules here are **self-closing** except `map`/`fullwidth-map` when they contain `map-pin` children.
- Most render best inside a **Theme Builder** template (single post/page/archive). On a normal page they fall back to the main query or the current post.
- Text color: many default to `module.advanced.text.text.desktop.value.color: "light"` (white) for dark backgrounds — override to `"dark"` on light backgrounds.
- These modules use the **Grid layout** system for their result grids (`<grid>.decoration.layout` → `display:"grid"`, `gridColumnCount`). See LAYOUT §5b.

---

## `divi/blog` — ✓ render-confirmed

Post grid/list. Self-closing. **Confirmed (scenario 21):** rendered recent posts (titles + excerpts) in a grid. Set `module.advanced.text.text.color` to contrast with the section background, and note that posts **without a featured image** show a blank image placeholder area. Use responsive `blogGrid` `gridColumnCount` so the grid stacks on mobile (same rule as LAYOUT §5b).

```json
{
  "post": {
    "advanced": {
      "type":         {"desktop": {"value": "post"}},
      "number":       {"desktop": {"value": "10"}},
      "offset":       {"desktop": {"value": "0"}},
      "dateFormat":   {"desktop": {"value": "M j, Y"}},
      "showExcerpt":  {"desktop": {"value": "on"}},
      "excerptContent": {"desktop": {"value": "off"}},
      "excerptManual":  {"desktop": {"value": "on"}},
      "excerptLength":  {"desktop": {"value": "270"}}
    }
  },
  "image":      {"advanced": {"enable": {"desktop": {"value": "on"}}}},
  "fullwidth":  {"advanced": {"enable": {"desktop": {"value": "on"}}}},
  "pagination": {"advanced": {"enable": {"desktop": {"value": "on"}}}},
  "meta": {
    "advanced": {
      "showAuthor":     {"desktop": {"value": "on"}},
      "showDate":       {"desktop": {"value": "on"}},
      "showCategories": {"desktop": {"value": "on"}},
      "showComments":   {"desktop": {"value": "off"}}
    }
  },
  "title":   {"decoration": {"font": {"font": {"desktop": {"value": {"headingLevel": "h2"}}}}}},
  "blogGrid": {"decoration": {"layout": {"desktop": {"value": {"display": "grid", "gridColumnCount": "3"}}}}},
  "builderVersion": "5.8.1"
}
```

| Field | Path | Notes |
|-------|------|-------|
| Post type | `post.advanced.type` | `"post"` or any CPT slug |
| Count | `post.advanced.number` | posts per page (string) |
| Offset | `post.advanced.offset` | skip N posts |
| Layout | `fullwidth.advanced.enable` | `"on"` = fullwidth list; `"off"` = grid (use `blogGrid` columns) |
| Grid columns | `blogGrid.decoration.layout.*.value.gridColumnCount` | when not fullwidth |
| Featured image | `image.advanced.enable` | `"on"`/`"off"` |
| Excerpt | `post.advanced.showExcerpt` + `excerptManual`/`excerptContent`/`excerptLength` | manual = use post excerpt |
| Pagination | `pagination.advanced.enable` | `"on"`/`"off"` |
| Meta toggles | `meta.advanced.show{Author,Date,Categories,Comments}` | |

---

## `divi/portfolio`, `divi/filterable-portfolio`, `divi/fullwidth-portfolio` — ✓ render-confirmed

Project (Divi `project` CPT) grids. `filterable-portfolio` adds category filter tabs. All self-closing. **Confirmed (scenario 23):** both rendered a grid of `project` items with titles + categories; `filterable-portfolio` showed the **All / Branding / Web Design** filter bar. (Projects without a featured image show an empty thumbnail area.)

```json
{
  "portfolio": {
    "innerContent": {"desktop": {"value": {"postsNumber": "10"}}},
    "advanced": {
      "showTitle":      {"desktop": {"value": "on"}},
      "showCategories": {"desktop": {"value": "on"}},
      "showPagination": {"desktop": {"value": "on"}},
      "layout":         {"desktop": {"value": "fullwidth"}}
    }
  },
  "title":         {"decoration": {"font": {"font": {"desktop": {"value": {"headingLevel": "h2"}}}}}},
  "portfolioGrid": {"decoration": {"layout": {"desktop": {"value": {"display": "grid", "gridColumnCount": "4"}}}}},
  "builderVersion": "5.8.1"
}
```

| Field | Path | Notes |
|-------|------|-------|
| Count | `portfolio.innerContent.desktop.value.postsNumber` | (on `filterable-portfolio` it's `portfolio.advanced.postsNumber`) |
| Layout | `portfolio.advanced.layout` | `"fullwidth"` or `"grid"` |
| Grid columns | `portfolioGrid.decoration.layout.*.value.gridColumnCount` | grid mode |
| Show title/categories/pagination | `portfolio.advanced.show*` | `"on"`/`"off"` |
| Hover overlay icon | `overlay.advanced.hoverIcon` / `overlay.decoration.icon` | `{unicode}` |

> Requires `project` CPT entries on the site. `fullwidth-portfolio` must live in a **fullwidth section**.

---

## Post template modules — `post-title`, `post-content`, `post-slider`, `post-nav` (+ fullwidth variants)

Meant for **single-post / archive Theme Builder templates**; they render the *current* post's data.

> **✓ Render-confirmed in a Theme Builder body template (single posts):** `divi/post-title` rendered the post's H1 + meta, and `divi/post-content` rendered the full post body **including its `<h2>` headings**. (`divi/comments` also confirmed — see below.) See "Creating a Theme Builder template via REST" at the end of this file for how this was built.

### `divi/post-title`
```json
{
  "title": {
    "decoration": {"font": {"font": {"desktop": {"value": {"headingLevel": "h1"}}}}},
    "advanced":   {"showTitle": {"desktop": {"value": "on"}}}
  },
  "meta": {
    "advanced": {
      "showMeta":          {"desktop": {"value": "on"}},
      "showAuthor":        {"desktop": {"value": "on"}},
      "showDate":          {"desktop": {"value": "on"}},
      "dateFormat":        {"desktop": {"value": "M j, Y"}},
      "showCategories":    {"desktop": {"value": "on"}},
      "showCommentsCount": {"desktop": {"value": "on"}}
    }
  },
  "image": {"advanced": {"enabled": {"desktop": {"value": "on"}}, "placement": {"desktop": {"value": "below"}}}},
  "builderVersion": "5.8.1"
}
```
`image.advanced.placement`: `"below"` / `"above"` / `"background"`. `textWrapper.advanced.useBackground` + `textWrapper.decoration.background` add a panel behind the title.

### `divi/post-content`
Renders the current post body. Minimal — no required attrs: `{"builderVersion": "5.8.1"}`. Only meaningful inside a single template.

### `divi/post-slider` — ✓ render-confirmed (scenario 32)
Posts as a slider (like `divi/slider` but auto-populated). **Standalone** — runs its own `WP_Query`, so it renders on any page (no single-post context). Confirmed showing featured image, title, author/date/comments meta, excerpt, and Read More. ⚠️ Its default background is a global-color variable (`gcid-primary-color`) — set an explicit `module.decoration.background` color if that token isn't defined.
```json
{
  "post": {
    "advanced": {
      "number":        {"desktop": {"value": "10"}},
      "orderby":       {"desktop": {"value": "date_desc"}},
      "offset":        {"desktop": {"value": "0"}},
      "contentSource": {"desktop": {"value": "off"}},
      "excerptManual": {"desktop": {"value": "on"}},
      "excerptLength": {"desktop": {"value": "270"}}
    }
  },
  "image":  {"advanced": {"enable": {"desktop": {"value": "on"}}, "placement": {"desktop": {"value": "background"}}}},
  "button": {"innerContent": {"desktop": {"value": {"text": "Read More"}}}, "advanced": {"enable": {"desktop": {"value": "on"}}}},
  "arrows": {"advanced": {"enable": {"desktop": {"value": "on"}}}},
  "module": {"advanced": {"autoSpeed": {"desktop": {"value": "7000"}}}},
  "builderVersion": "5.8.1"
}
```
`post.advanced.orderby`: `"date_desc"`, `"date_asc"`, `"title_asc"`, `"rand"`, etc. `slideOverlay.advanced.use: "on"` adds a dark tint over background images.

### `divi/post-nav` (labeled "Pagination") — ✓ render-confirmed (scenario 34)
Previous/next links for the current post. Self-closing. **Needs single-post context** (uses `get_the_ID()` + `get_next_post()`/`get_previous_post()`), so place it in a **single-post Theme Builder body template**. Confirmed rendering "← prev / next →" links resolving to the adjacent posts by date.
```json
{
  "module": {"advanced": {"inSameTerm": {"desktop": {"value": "off"}}}},
  "links":  {"advanced": {"showPrev": {"desktop": {"value": "on"}}, "showNext": {"desktop": {"value": "on"}}}},
  "builderVersion": "5.8.1"
}
```
`inSameTerm: "on"` restricts prev/next to the same category. (Loop **Pagination** for blog/portfolio result sets is handled by those modules' own `pagination.advanced.enable`.)

> **Fullwidth variants** (`fullwidth-post-title`, `fullwidth-post-content`, `fullwidth-post-slider`) take the same attrs but must sit directly in a **fullwidth section** (no row/column).

---

## `divi/menu` + `divi/fullwidth-menu` — ✓ render-confirmed

Renders a WordPress nav menu with logo + optional cart/search icons. Self-closing. **You must point it at a nav menu via `menu.advanced.menuId.desktop.value` = the nav-menu term ID (string)** — without it the module renders an empty bar. **Confirmed (scenario 25):** `menuId:"20"` rendered the full `<ul>` with all assigned items (Home/Blog/Shop/Contact). Set the menu link color (the menu's link/font element) so links contrast with the menu background — defaults can be light and disappear on a white bar.

```json
{
  "logo": {"innerContent": {"desktop": {"value": {"linkTarget": "off"}}}},
  "menu": {"advanced": {"menuId": {"desktop": {"value": "20"}}, "style": {"desktop": {"value": "left_aligned"}}}},
  "menuDropdown": {
    "advanced": {
      "direction": {"desktop": {"value": "downwards"}},
      "animation": {"desktop": {"value": "fade"}}
    }
  },
  "cartIcon":   {"advanced": {"show": {"desktop": {"value": "off"}}}},
  "searchIcon": {"advanced": {"show": {"desktop": {"value": "off"}}}},
  "cartQuantity": {"advanced": {"show": {"desktop": {"value": "off"}}}},
  "module": {
    "advanced": {"text": {"text": {"desktop": {"value": {"color": "light"}}}}},
    "decoration": {"background": {"desktop": {"value": {"color": "#ffffff"}}}}
  },
  "builderVersion": "5.8.1"
}
```
| Field | Path | Values |
|-------|------|--------|
| **Nav menu** | `menu.advanced.menuId` | **required** — the nav-menu term ID (string) to display |
| Menu style | `menu.advanced.style` | `"left_aligned"`, `"centered"`, `"inline_centered_logo"`, `"fullwidth"` |
| Dropdown dir | `menuDropdown.advanced.direction` | `"downwards"` / `"upwards"` |
| Dropdown anim | `menuDropdown.advanced.animation` | `"fade"`, `"flip"`, `"expand"`, `"slide"`, `"grow"` |
| Cart / search / hamburger | `cartIcon` / `searchIcon` / `hamburgerMenuIcon` | `advanced.show` + `decoration.font` |

`fullwidth-menu` is the same module for a **fullwidth section**.

---

## `divi/search` — ✓ render-confirmed

Site search box. Self-closing. **Confirmed (scenario 25):** rendered the search input.
```json
{
  "search": {
    "advanced": {
      "showButton":   {"desktop": {"value": "on"}},
      "excludePages": {"desktop": {"value": "off"}},
      "excludePosts": {"desktop": {"value": "off"}}
    }
  },
  "builderVersion": "5.8.1"
}
```
Placeholder/button text and input styling flow through the module's design groups. Field focus styling uses the pseudo-class states (STYLING §10c).

---

## `divi/login` — ✓ render-confirmed

WordPress login form. Self-closing. **Confirmed (scenario 25):** rendered Username/Password fields, "Forgot your password?" link, and Login button.
```json
{
  "title":  {"decoration": {"font": {"font": {"desktop": {"value": {"headingLevel": "h2"}}}}}},
  "button": {"innerContent": {"desktop": {"value": {"text": "Login", "linkUrl": "#"}}}},
  "module": {"advanced": {"currentPageRedirect": {"desktop": {"value": "off"}}}},
  "builderVersion": "5.8.1"
}
```
`currentPageRedirect: "on"` returns the user to the current page after login. When logged in, the module shows a logged-in message + logout link.

---

## `divi/sidebar` — ✓ render-confirmed

Renders a registered WordPress widget area. Self-closing. **Confirmed (scenario 25):** rendered the `sidebar-1` widget area (showed its Search widget). Output depends on which widgets are in the chosen area.
```json
{
  "sidebar": {
    "innerContent": {"desktop": {"value": {"area": "sidebar-1"}}},
    "advanced": {"layout": {"desktop": {"value": {"alignment": "left", "showBorder": "on"}}}}
  },
  "builderVersion": "5.8.1"
}
```
`sidebar.innerContent.desktop.value.area` = the widget area ID registered by the theme (e.g. `"sidebar-1"`). The area must contain widgets to render anything.

---

## `divi/comments` — ✓ render-confirmed

Comment list + comment form for the current post. Self-closing. **Confirmed** in a Theme Builder body template over a single post — rendered the "Submit a Comment" form (comment/name/email/website + submit).
```json
{
  "module": {"advanced": {"showReply": {"desktop": {"value": "on"}}}},
  "image":  {"advanced": {"showAvatar": {"desktop": {"value": "on"}}}},
  "meta":   {"advanced": {"showMeta": {"desktop": {"value": "on"}}}},
  "commentCount": {
    "advanced":   {"showCount": {"desktop": {"value": "on"}}},
    "decoration": {"font": {"font": {"desktop": {"value": {"headingLevel": "h1"}}}}}
  },
  "formTitle": {"decoration": {"font": {"font": {"desktop": {"value": {"headingLevel": "h3"}}}}}},
  "field": {"advanced": {"focusUseBorder": {"desktop": {"value": "off"}}}},
  "builderVersion": "5.8.1"
}
```
The `field` element uses the harmonized form-field structure incl. focus pseudo-state (STYLING §10c). Only meaningful on a post that allows comments.

---

## `divi/map` + `divi/map-pin` (and `divi/fullwidth-map`)

Google Map with pins. **Requires a Google Maps API key configured in Divi → Theme Options.** `map` is a **container** when it holds `map-pin` children (otherwise self-closing with the address in `map.innerContent`).

```json
// map (parent):
{
  "map": {
    "innerContent": {"desktop": {"value": {"address": "", "zoom": 18, "lat": 0, "lng": 0}}},
    "advanced": {
      "mouseWheel":     {"desktop": {"value": "on"}},
      "mobileDragging": {"desktop": {"value": "on"}},
      "grayscaleFilter": {"desktop": {"value": {"enabled": "off", "amount": "0"}}}
    }
  },
  "module": {"decoration": {"sizing": {"desktop": {"value": {"height": "440px"}}}}},
  "builderVersion": "5.8.1"
}

// map-pin (child, self-closing):
{
  "pin": {"innerContent": {"desktop": {"value": {"address": "123 Main St", "zoom": 18, "lat": 40.7128, "lng": -74.006}}}},
  "builderVersion": "5.8.1"
}
```
- `lat`/`lng` are **numbers** (not strings); `zoom` is a number.
- Set `module.decoration.sizing.height` or the map collapses.
- `fullwidth-map` is the same in a fullwidth section.

---

## Loop Builder (`module.advanced.loop`) — ✓ render-confirmed

Turns a repeatable element (`group`, `group-carousel`, `column`, and ~60 other modules) into a **query loop** — Divi renders that element (and its whole subtree) **once per queried item**, with dynamic-content tokens inside resolving to each item's data. Enabled via the `loop` group on the element's `module.advanced`. **Confirmed (scenario 22):** a `group` with a post-types loop rendered one card per post (title + date + excerpt from each), and the repeated cards tiled into the parent column's CSS grid. Loop rendering is **server-side**, so it works from raw REST markup (no builder-UI/asset-enqueue requirement, unlike the client-side TOC).

```json
"module": {
  "advanced": {
    "loop": {
      "desktop": {"value": {
        "enable": "on",
        "queryType": "post_types",
        "subTypes": [{"value": "post"}],
        "postPerPage": "6",
        "postOffset": "0",
        "orderBy": "date",
        "order": "DESC",
        "excludeCurrentPost": "off"
      }}
    }
  }
}
```

| subName | Purpose |
|---------|---------|
| `enable` | `"on"` / `"off"` — turn the loop on |
| `queryType` | `"post_types"`, `"terms"` (a.k.a. `post_taxonomies`), `"users"` (also WooCommerce product loops via `post_types`+`product`) |
| `subTypes` | **array of `{"value": "..."}` objects** — post-type slugs / taxonomy / role values. ⚠️ NOT plain strings: `[{"value":"post"}]`. Empty/omitted → all post types (`any`). |
| `postPerPage` | items per page (default 10) |
| `postOffset` | skip N items |
| `order` | `"ASC"` / `"DESC"` |
| `orderBy` | `"date"`, `"title"`, `"menu_order"`, `"rand"`, … |
| `includeSpecificPosts` / `excludeSpecificPosts` | ID lists |
| `includePostWithSpecificTerms` / `excludePostWithSpecificTerms` | term filters |
| `excludeCurrentPost` | `"on"` skips the current post (archive/single context) |
| `ignoreStickysPost` | ignore sticky posts |
| `metaQuery` | custom-field meta query |

- Pair with a **Pagination** module targeting the same loop (`loopId`).
- `queryType:"post_types"` with `subTypes:[{"value":"product"}]` (Woo active) drives product loops — see MODULES-WOOCOMMERCE.
- To tile the repeated items, put the loop element in a **grid** column/group (LAYOUT §5b) — the repeated copies become grid children.

### Dynamic Content tokens (D5) — needed inside loops

Inside a loop element, reference each item's fields with **dynamic-content tokens** (a `$variable(...)$` of `type:"content"`). **Inside a loop the token names are prefixed with `loop_`** (a plain `post_title` would resolve to the page's main post, not the loop item). The token goes directly into a field's `value` string:

```json
"title": {"innerContent": {"desktop": {"value":
  "$variable({\"type\":\"content\",\"value\":{\"name\":\"loop_post_title\",\"settings\":{}}})$"
}}}
```

In Python (avoid nested f-string braces):
```python
def dc(name, settings=None):
    obj = {"type": "content", "value": {"name": name, "settings": settings or {}}}
    return '$variable(' + json.dumps(obj, separators=(',', ':')) + ')$'
```

| Loop token (`name`) | Renders |
|---------------------|---------|
| `loop_post_title` | item title |
| `loop_post_excerpt` | excerpt — `settings:{words, read_more_label}` to trim/label |
| `loop_post_date` / `loop_post_modified_date` | date |
| `loop_post_author` / `loop_post_author_bio` / `loop_post_author_profile_picture` | author fields |
| `loop_post_featured_image` (a.k.a. `loop_post_thumbnail`) | featured image URL (use in an `image`/blurb) |
| `loop_post_link` / `loop_post_link_url` | permalink |
| `loop_post_comment_count` | comment count |
| `loop_post_terms` | terms/categories |
| `loop_post_meta_key` | custom field (`settings` carries the meta key) |

> The non-`loop_` tokens (`post_title`, `post_excerpt`, `post_featured_image`, `post_date`, `post_link_url`, `post_author`, …) use the same `type:"content"` format and resolve to the **current page's post** — use those in single-post Theme Builder templates (outside a loop). There is no `post_content` token; use the `divi/post-content` module for the full body.

---

## Creating a Theme Builder template via REST (confirmed)

Divi 5 reuses the D4 Theme Builder storage: post types `et_theme_builder` (the live set) → `et_template` (one per assignment row, holds conditions + layout links) → `et_body_layout` / `et_header_layout` / `et_footer_layout` (the actual Divi markup). The standard REST API can't assemble these relationships, but Divi's own PHP helpers can. A tiny mu-plugin exposing a REST route does it reliably:

```php
// In a mu-plugin, inside rest_api_init (permission: edit_others_posts):
$body_id = et_theme_builder_insert_layout([            // enables builder + layout_type term
    'post_type' => 'et_body_layout', 'post_status' => 'publish',
    'post_title' => $title, 'post_content' => $markup,  // $markup = placeholder-wrapped Divi blocks
]);
$tb_id = et_theme_builder_get_theme_builder_post_id(true, true);  // live TB set (create if needed)
$tpl_id = et_theme_builder_store_template($tb_id, [
    'id' => 0, 'title' => $title, 'default' => '0', 'enabled' => '1',
    'layouts' => [
        'header' => ['id' => 0, 'enabled' => true],
        'body'   => ['id' => $body_id, 'enabled' => true],
        'footer' => ['id' => 0, 'enabled' => true],
    ],
    'use_on' => ['singular:post'],   // condition: all single posts
    'exclude_from' => [],
], true);
add_post_meta($tb_id, '_et_template', $tpl_id);          // map template -> TB set
et_theme_builder_clear_wp_cache('all');
ET_Core_PageResource::remove_static_resources('all', 'all');
```

Key facts:
- **Condition values** use `area:type` form — `singular:post` = all single posts, `singular:page` = all pages, plus archive/specific-ID options from `et_theme_builder_get_template_settings_options()`.
- `default => '1'` makes a catch-all template for everything without a more specific match (use sparingly — it affects the whole site).
- The body layout content uses the same `<!-- wp:divi/placeholder -->…<!-- /wp:divi/placeholder -->` wrapper as pages.
- A **body-only** template still uses the active theme's header/footer/sidebar; add header/footer layouts (or assign a menu / disable the sidebar) for a clean result.

## Coverage note

**✓ Render-confirmed (5.6.2):** blog, portfolio/filterable-portfolio, post-title, post-content, comments, menu, search, login, sidebar, and the **Loop Builder** + Dynamic Content tokens.

**✓ Render-confirmed (5.7.0):** post-slider (scenario 32), post-nav (scenario 34, in a single-post TB template), global-layout (scenario 33, via `globalModule`).
**⚙ Source-verified (pending render test):** fullwidth post/menu/map variants, map/map-pin (needs a Google Maps API key), instagram-feed (needs a connected Instagram account). These need external credentials/services or specific content.

Output of every module here depends on real WordPress content, so verify on a site that has the relevant posts/menus/widget areas/CPTs before relying on a specific layout.

---

*DIVI5 Dynamic Modules Skill — V0.6.0 | Builder Version 5.8.1 | Created by Shashank Gupta @ divilove.com*
