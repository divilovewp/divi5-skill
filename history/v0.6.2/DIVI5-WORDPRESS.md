---
name: divi5-wordpress
description: WordPress REST API integration for Divi 5 — required meta fields, application passwords, mu-plugin setup, canvas creation, and page create/delete workflows.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — WordPress Integration
> **Part of the DIVI5 skill set. Attach when creating pages programmatically via the REST API.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS (this) · PATTERNS

---

## 1. Creating Pages via the WordPress REST API

### Why This Matters

When creating Divi 5 pages programmatically via the WordPress REST API, three fields are **mandatory** beyond just the page content. Without them:
- The page renders with a **WordPress sidebar** (not full-width)
- **Section backgrounds don't apply** (hero colors, CTA colors invisible)
- **White text becomes invisible** (no dark background behind it)
- The `number-counter`, `circle-counter`, and other modules may not render

### Required Fields on Every Page Create/Update

```python
payload = {
    'title':    'My Page Title',
    'content':  divi_markup_string,   # the <!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder --> string
    'status':   'publish',
    'template': 'page-template-blank.php',   # ← Divi full-width, removes sidebar
    'meta': {
        '_et_pb_use_builder':   'on',                 # ← tells Divi the builder is active
        '_et_pb_page_layout':   'et_full_width_page', # ← full-width, no sidebar
    },
}
```

### Field Explanations

| Field | Value | Why |
|-------|-------|-----|
| `template` | `"page-template-blank.php"` | Divi's blank template skips the WordPress sidebar when the builder is active. Default `page.php` always shows the sidebar regardless. |
| `meta._et_pb_use_builder` | `"on"` | `et_pb_is_pagebuilder_used()` returns `true` only when this meta is set. Without it, the template falls back to standard WP rendering (sidebar, constrained width). |
| `meta._et_pb_page_layout` | `"et_full_width_page"` | Sets the page layout selector in Divi's page settings. Controls CSS class applied to the page wrapper. |

### Page Layout Values

| Value | Effect |
|-------|--------|
| `"et_full_width_page"` | Full width — no sidebar, content spans 100% |
| `"et_no_sidebar"` | No sidebar but keeps standard content width |
| `"et_right_sidebar"` | Right sidebar (default if meta not set) |
| `"et_left_sidebar"` | Left sidebar |

---

## 2. Prerequisites: mu-plugin for Meta Access

WordPress REST API does **not** expose protected meta fields (underscore prefix) by default. You must register them with `show_in_rest: true` via a mu-plugin.

**File:** `wp-content/mu-plugins/divi-rest-meta.php`

```php
<?php
/**
 * Plugin Name: Divi REST Meta
 * Description: Registers Divi page meta fields in the REST API.
 */
add_action( 'init', function () {
    foreach ( ['_et_pb_use_builder', '_et_pb_page_layout', '_et_pb_side_nav'] as $key ) {
        register_post_meta( 'page', $key, [
            'type'         => 'string',
            'single'       => true,
            'default'      => '',
            'show_in_rest' => true,
            'auth_callback' => function() { return current_user_can('edit_posts'); },
        ]);
    }
});
```

Without this mu-plugin, setting `meta._et_pb_use_builder` in the REST payload is silently ignored.

---

## 3. Authentication

WordPress REST API requires **Application Passwords** (WP 5.6+). Basic username/password auth is disabled by default.

### Creating an Application Password

**Via WP Admin:**
`WP Admin → Users → Profile → Application Passwords → Add New`

**Via REST API (using an existing app password):**
```python
import base64, requests

WP_URL   = 'http://your-site.local'
USERNAME = 'admin'
APP_PASS = 'xxxx xxxx xxxx xxxx xxxx xxxx'  # spaces OK

token = base64.b64encode(f'{USERNAME}:{APP_PASS}'.encode()).decode()
headers = {
    'Authorization': f'Basic {token}',
    'Content-Type': 'application/json',
}
```

### Verifying Auth
```python
resp = requests.get(f'{WP_URL}/wp-json/wp/v2/users/me', headers=headers)
print(resp.json()['name'], resp.json()['roles'])
```

---

## 4. Full Python Page Create Example

```python
import base64, json, requests

WP_URL   = 'https://your-site.example'
USERNAME = 'claude'
APP_PASS = 'If1f Vre2 moxv iXmE NDxX riYP'  # spaces OK in application passwords

def auth_headers():
    token = base64.b64encode(f'{USERNAME}:{APP_PASS}'.encode()).decode()
    return {'Authorization': f'Basic {token}', 'Content-Type': 'application/json'}

def create_divi_page(title: str, markup: str) -> dict:
    """
    markup = the full <!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder --> string
    """
    resp = requests.post(
        f'{WP_URL}/wp-json/wp/v2/pages',
        headers=auth_headers(),
        json={
            'title':    title,
            'content':  markup,
            'status':   'publish',
            'template': 'page-template-blank.php',
            'meta': {
                '_et_pb_use_builder': 'on',
                '_et_pb_page_layout': 'et_full_width_page',
            },
        },
        timeout=30
    )
    resp.raise_for_status()
    page = resp.json()
    print(f'Created: {page["link"]} (ID {page["id"]})')
    return page

def delete_divi_page(page_id: int) -> None:
    requests.delete(
        f'{WP_URL}/wp-json/wp/v2/pages/{page_id}?force=true',
        headers=auth_headers(),
        timeout=30
    )
```

---

## 5. Importing via Divi's Portability UI (Manual)

If using Divi's Import & Export UI instead of the REST API:

1. Go to any page → Edit with Divi Builder → gear icon (Page Settings) → **Import & Export**
2. Upload the `.json` file (must have `"context": "et_builder"`)
3. The import will replace the current page's content

This does **not** require Application Passwords or the mu-plugin.

---

## 6. Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Page shows sidebar | Template or meta not set | Set `template: "page-template-blank.php"` and `_et_pb_use_builder: "on"` |
| Section backgrounds invisible | `_et_pb_use_builder` not `on` | mu-plugin + set meta |
| White text invisible on white bg | Backgrounds not applying | See above |
| Modules missing (counters, etc.) | Builder not activated | Set `_et_pb_use_builder: "on"` |
| `meta` field silently ignored | Protected meta not registered | Install `divi-rest-meta.php` mu-plugin |
| Auth fails | Wrong credentials or basic auth disabled | Use Application Password |

---

## 7. Canvas — Reusable Content Blocks

Canvas is a Divi 5 feature for creating reusable content blocks that can be embedded on multiple pages. **Fully confirmed via real-render test.**

### Canvas post type

Canvases are stored as `et_pb_canvas` WordPress custom posts with REST support at `/wp-json/wp/v2/et_pb_canvas`.

**Canvas content = plain Divi block markup — NO `<!-- wp:divi/placeholder -->` wrapper.**

### mu-plugin additions required

Add to `divi-rest-meta.php` to enable canvas meta via REST:

```php
// In the init action:
add_post_type_support( 'et_pb_canvas', 'custom-fields' );

$canvas_meta = [
    '_divi_canvas_id',
    '_divi_canvas_parent_post_id',
    '_divi_canvas_parent_context',
    '_divi_canvas_append_to_main',
    '_divi_canvas_z_index',
];
foreach ( $canvas_meta as $key ) {
    register_post_meta( 'et_pb_canvas', $key, [
        'type'          => 'string',
        'single'        => true,
        'default'       => '',
        'show_in_rest'  => true,
        'auth_callback' => function () { return current_user_can( 'edit_posts' ); },
    ] );
}
```

### Creating a canvas via REST

```python
import uuid, requests
from requests.auth import HTTPBasicAuth

auth = HTTPBasicAuth('claude', 'APP_PASSWORD')
canvas_id = f'my-canvas-{uuid.uuid4().hex[:8]}'   # any unique string

# Canvas content = raw Divi block markup (no placeholder wrapper)
canvas_markup = '<!-- wp:divi/section {...} -->...<!-- /wp:divi/section -->'

r = requests.post('http://site.local/wp-json/wp/v2/et_pb_canvas', auth=auth, json={
    'title':   'Shared CTA Block',
    'content': canvas_markup,
    'status':  'publish',
    'meta':    {'_divi_canvas_id': canvas_id},   # ← REQUIRED for canvas-portal lookup
})
canvas_wp_id = r.json()['id']

# Cleanup:
# requests.delete(f'.../wp-json/wp/v2/et_pb_canvas/{canvas_wp_id}?force=true', auth=auth)
```

### Embedding a canvas in a page

`divi/canvas-portal` is **self-closing** and goes inside a regular `section → row → column`:

```python
m('canvas-portal', {
    'canvas': {
        'advanced': {
            'canvasId': {'desktop': {'value': canvas_id}}   # matches _divi_canvas_id meta
        }
    },
    'builderVersion': '5.8.1'
})
```

### Canvas scope types

| Type | Meta to set | Use case |
|------|-------------|----------|
| **Global** | `_divi_canvas_id` only | Canvas shown everywhere (e.g. site-wide CTA) |
| **Local (post)** | + `_divi_canvas_parent_post_id` | Canvas tied to one page |
| **Local (context)** | + `_divi_canvas_parent_context` | Canvas on all archive/category pages |

### ⚠️ Key rules

- `_divi_canvas_id` is **mandatory** — `canvas-portal` looks up content by this meta value, not by WP post ID
- Canvas content must NOT have the `<!-- wp:divi/placeholder -->` wrapper that pages require
- `canvas-portal` renders the canvas content inline at the module's position in the page
- In REST API context, the canvas renders empty (Divi skips it server-side when in builder mode) — it only renders on the public frontend

---

*DIVI5 WordPress Skill — V0.6.2 | Builder Version 5.8.1 | Created by Shashank Gupta @ divilove.com*
