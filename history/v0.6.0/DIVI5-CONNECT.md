---
name: divi5-connect
description: Divi Connect plugin workflow — read a site's design system; create & edit pages and real blog posts live; build global Theme Builder headers/footers; manage colors, size/font/gradient variables and presets via the REST API. Reference this when the user has chosen live-site mode (mode A in DESIGN-PROCESS).
author: Shashank Gupta @ divilove.com
---

# DIVI5-CONNECT — Live Site Workflow
> **Part of the DIVI5 skill set. Used when the user has Divi Connect installed on their WordPress site.**
> Covers: reading the design system, creating pages live, managing colors/variables/presets.

---

## §1 Setup — What to Ask the User

Ask for these two things in one message:

1. **Site URL** — e.g. `https://mysite.com`
2. **API key** — from WP Admin → Settings → Divi Connect
   - If they haven't got it yet: tell them to call `GET {siteUrl}/wp-json/divi-connect/v1/key` with their WordPress username + application password, and it returns the key

Once you have both, you're ready. All requests use the header:
```
X-Divi-Connect-Key: dvc_xxxx
```

---

## §2 Step 1 — Always Read the Design System First

Before generating any markup, call:
```
GET {siteUrl}/wp-json/divi-connect/v1/design-system
Header: X-Divi-Connect-Key: {apiKey}
```

The response has four sections. Read all of them before planning the page.

### `data.colors` — global color tokens
```json
{
  "gcid-brand-navy": {
    "id":    "gcid-brand-navy",
    "label": "Brand Navy",
    "color": "#1a1a2e",
    "token": "$variable({\"type\":\"color\",\"value\":{\"name\":\"gcid-brand-navy\"}})$"
  }
}
```
Use `token` verbatim in page markup wherever you'd normally write a hex color. Never hardcode a hex that matches an existing site color.

### `data.variables.numeric` — size/spacing tokens
```json
[{ "id": "gvid-heading-size", "label": "Heading Size", "value": "48px",
   "token": "$variable({\"type\":\"size\",\"value\":{\"name\":\"gvid-heading-size\"}})$" }]
```

### `data.variables.gradients` — gradient tokens
```json
[{ "id": "gvid-hero-grad", "label": "Hero Gradient",
   "value": "linear-gradient(135deg,#1a1a2e,#0f172a)",
   "token": "$variable({\"type\":\"gradient\",\"value\":{\"name\":\"gvid-hero-grad\",\"settings\":{}}})$" }]
```

### `data.presets` — module presets (summary only — id + name)
```json
{
  "module": {
    "divi/heading": {
      "default": "dark-heading",
      "items": {
        "dark-heading": { "id": "dark-heading", "name": "Dark Heading", "moduleName": "divi/heading" }
      }
    }
  }
}
```
Apply a preset by adding `"modulePreset": "dark-heading"` as a top-level key in the module's attrs.

### `data.usage_hints`
Always present — confirms the exact token format and builder version. Use `builder_version` as the `builderVersion` in all markup.

---

## §3 Using Design System Tokens in Markup

### ⚠️ TOKEN DISCIPLINE — mandatory when connected to a live site
These are the rules that make a built page actually match the site's design. Breaking them produces "ghost" values that render as nothing, or off-brand hardcoded values.

1. **Use the exact `token` string from `/design-system` for EVERY color AND size** — copy it **verbatim** (the whole `$variable(...)$`). This applies to **font sizes, line-heights, spacing/padding/margin, gaps, border-radius**, not just colors. If a token exists for the value you want, you MUST use it instead of a raw number.
2. **NEVER invent an ID.** Only use `gvid-`/`gcid-` IDs that were returned by `/design-system`. Do **not** write `gcid-primary`, `gcid-heading`, `gcid-body`, `gcid-link`, `gvid-h1`, etc. unless that exact id is in the response. Invented IDs do not resolve → blank/fallback styling.
3. **Match by label.** The response gives each token a `label` (e.g. `H1 Desktop`, `Body`, `Spacing - Medium`, `Section Gap`). Pick the token whose label fits the role — e.g. an H1 heading's `size` → the `H1` size token, section padding → a `Spacing`/`Padding` token.
4. **Headings are the usual offender — do not hardcode heading font sizes.** If the site defines H1–H6 size variables, every heading's `size` must be the matching size token.
5. **Only hardcode when NO token exists** for that value (e.g. an empty site, or a one-off value with no matching variable).

### Self-check before calling `divi_create_page`
Scan your markup: every `color`, `size`, `gradient`, padding/margin/gap/radius value is **either** an exact `$variable(...)$` token from the design-system response **or** a deliberate raw value with no matching token. No invented IDs.

```python
# Color token — background or font color field
"desktop": {"value": {"color": "$variable({\"type\":\"color\",\"value\":{\"name\":\"gcid-brand-navy\"}})$"}}

# SIZE token — font size / spacing / radius field (use the token, NOT "48px")
"font": {"desktop": {"value": {"size": "$variable({\"type\":\"size\",\"value\":{\"name\":\"gvid-heading-size\"}})$"}}}

# Gradient token — background gradient field
"desktop": {"value": {"gradient": "$variable({\"type\":\"gradient\",\"value\":{\"name\":\"gvid-hero-grad\",\"settings\":{}}})$"}}

# Preset — top-level key in module attrs
{
  "modulePreset": "dark-heading",
  "title": {"innerContent": {"desktop": {"value": "My Heading"}}},
  "builderVersion": "5.8.1"
}
```

### If a needed token bucket is empty — ASK, don't silently hardcode
When `/design-system` returns **no colors** or **no size/spacing/font variables** for what the design needs, don't just inline values — **ask the user first** (DESIGN-PROCESS "Variable-availability gate"):
> "This site has no [colors / size / spacing] variables yet. Generate a variable system (recommended — editable + fluid), or build with inline numeric values?"

- **Generate →** `POST /colors` (`gcid-*`) and/or `POST /variables` (`gvid-*` size/font/gradient) *(Pro)*, then build with the new tokens.
- **Inline →** build with literal values — an accepted path; the self-audit won't flag literals when the user opted out.
- **Free tier / `402`:** size-variable generation needs **Pro**, and Free bakes size tokens to literal anyway → tell the user and fall back to inline for **sizes** (colors + gradients still generate on Free). See §5 + §7.

---

## §4 Step 2 — Create the Page

```
POST {siteUrl}/wp-json/divi-connect/v1/pages
Header: X-Divi-Connect-Key: {apiKey}
Content-Type: application/json

{
  "title":   "Page Title",
  "content": "<!-- wp:divi/placeholder -->\r\n{sections}\r\n<!-- /wp:divi/placeholder -->",
  "status":  "publish",
  "slug":    "optional-custom-slug",
  "template": "blank"
}
```

`template` (optional):
- **`blank`** (default) — full-bleed page, **no theme/Theme-Builder header & footer**. Use for landing pages and standalone designs where you build all the chrome yourself.
- **`default`** — normal page template, so a **global Theme Builder header/footer (or the theme's) renders around the page**. Use this whenever the site has a global header/footer that should appear on the page (see §5 Theme Builder). ⚠️ With the default `blank`, a global header/footer will NOT show on the page.

Response (201):
```json
{ "success": true, "id": 42, "post_type": "page", "url": "https://mysite.com/page-title/", "edit": "https://mysite.com/wp-admin/..." }
```

Return the `url` to the user so they can open it immediately. Offer the `edit` link too.

---

## §4b Edit an Existing Page or Post (no delete + recreate)

To change an existing page, **read it, edit the markup, write it back** — this keeps the same ID, URL and history. Do NOT delete and recreate.

```
GET /pages/{id}        → { id, post_type, title, status, slug, url, content }   # content = raw Divi markup
PUT /pages/{id}        # partial — send only the fields you want to change
{ "content": "<!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder -->" }
```
`PUT /pages/{id}` accepts any of: `title`, `content`, `status`, `slug`, `template`. Returns `{ success, id, url, updated:[...] }`.

Workflow to tweak a page: `GET /pages/{id}` → modify the returned markup → `PUT /pages/{id}` with the new `content`. Re-running `divi_get_page` first means you edit the real current markup instead of regenerating from scratch.

---

## §5 Other Endpoints

### Build from a compact spec, and see the result *(Divi Connect v1.6.0+)*

Newer Divi Connect adds two tools that make live building cheaper and self-correcting. If
`tools/list` shows them, **prefer them**:

- **`divi_build_page`** — the preferred way to build. Instead of hand-writing escaped block
  markup, send a compact component **spec** (`sections → rows → cols → modules`) and the server
  expands it into valid Divi markup (correct escaping, structure and tokens guaranteed) and
  creates/updates the page. Pass a color as a `gcid-…` id and any size as a `gvid-…` id — the
  server wraps them into tokens for you (literals also work). To horizontally center an image or
  button, set `center:true` on its **column**. Module types and fields are documented in the
  tool's own description. This removes the blank-page mistakes (attrs-wrapper, unescaped `<`,
  invented tokens) and uses far fewer tokens than emitting raw markup.
- **`divi_get_rendered_page`** — after creating/updating a **published** page, call this to SEE
  the result: it returns the rendered HTML (content region) plus the page's own Divi CSS rules.
  Use it to verify spacing, contrast and centering and fix issues instead of building blind.

When these are unavailable (older plugin), build with `divi_create_page` and the markup rules above.

### Section presets — let the server design common sections *(Divi Connect v1.6.3+)*

For common section types, send a **preset** instead of composing rows/cols/modules by hand. A section
in the spec can be `{ "preset": "hero|features|cta|steps", ...content }` and the server expands it into
a well-structured, well-spaced section — you supply only **content + brand colours**, it handles the
layout, spacing, type scale and alignment. Prefer presets for these sections; they produce tidier output
than hand-built ones, especially on smaller models.

- **hero** — `{preset:"hero", eyebrow?, heading, sub?, button?{text,url,bg,fg}, bg?, fg?, accent?, align?}`
- **features** — `{preset:"features", eyebrow?, heading?, sub?, items:[{title,text,icon?}], card_bg?, accent?, bg?}`
- **cta** — `{preset:"cta", heading, sub?, button{text,url,bg,fg}, bg? (the band), fg?, accent?}`
- **steps** — `{preset:"steps", heading?, items:[{title,text}], accent?, bg?}`

Pass colours as `gcid-…`/`gvid-…` ids or literals exactly as elsewhere; anything you omit gets a tasteful default.

### Build guardrails — always check `warnings` *(Divi Connect v1.6.3+)*

`divi_build_page` now protects design quality and returns a `warnings` array — read it and fix what it flags:

- **Unknown colour / size / font ids are dropped** (the element inherits instead of rendering the wrong
  default colour) and reported. So call `divi_get_design_system` first and use only ids that exist — never
  invent token names.
- **WCAG AA contrast** is enforced: leave a text colour unset over a known background and the server
  auto-supplies a legible light/dark colour; set an explicit colour that fails AA (4.5:1 normal, 3:1 large)
  and it keeps your colour but warns. Aim for AA-passing pairs.

### Create a real blog POST (not a page)
For blog/journal articles that should appear in the blog, feeds and archives, create a **post**, not a page.

#### ▸ Post-creation mode gate — ASK before creating a post (then wait)
A post can be authored two ways, and styled two ways. Ask the user up front:
> "For this post, do you want the body built with the **Divi Builder** (full Divi modules/layout) or plain **Gutenberg** blocks? And should I build a **Theme Builder Single-Post template** (Pro) to style how posts look?"

- **Gutenberg body (default / recommended for articles):** the post is plain block content (paragraphs, headings, quotes, lists). Its look comes from the theme or a **Single-Post Theme Builder template**. Create with `_et_pb_use_builder` **off** (the plugin keeps posts Gutenberg by default — see plugin note).
- **Divi Builder body:** the post body is Divi `divi/...` markup (like a page). Needs `_et_pb_use_builder` **on** for the post — pass the builder flag (see plugin note); markup rules are identical to pages.
- **Single-Post TB template (Pro):** if the user wants consistent post styling (title/meta/breadcrumbs/content area/CTA), build it once via `/theme-builder` (`layout_type:"body"`, condition `singular:post_type:post:all`) — see §5 Theme Builder. A Gutenberg body + a TB template is the cleanest combo. (A Divi-builder body usually does NOT need a TB body template — it carries its own layout.)

> **Plugin capability note (verify in review):** `/posts` historically did **not** force `_et_pb_use_builder` (so posts stay Gutenberg). To support a **Divi-builder post**, `/posts` must accept a flag (e.g. `"builder":"divi"|"gutenberg"`, default `gutenberg`) that sets `_et_pb_use_builder=on` when `divi`. Confirm/implement during the plugin review.

```
POST /posts
{
  "title": "My Article",
  "content": "<!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder -->",
  "status": "publish",
  "slug": "my-article",
  "excerpt": "Optional excerpt.",
  "categories": ["Journal"],   // names — created if missing (or numeric term ids)
  "tags": ["divi", "news"],
  "builder": "gutenberg"        // "gutenberg" (default) or "divi" — see gate above
}
```
Returns `{ success, id, post_type:"post", url, edit }`. Same markup rules as pages. `GET/PUT/DELETE /posts/{id}` work exactly like the page endpoints (read raw markup, partial update, delete). Use `divi_create_page` only for standalone pages.

### Set global colors  *(Pro)*
Writes to the Divi 5 Variables panel (global colors). `merge:true` keeps existing colors; omit/false replaces all.
```
POST /colors
{ "colors": { "gcid-primary": {"label": "Primary", "color": "#1a1a2e"} }, "merge": true }
```

### Set global variables — sizes, **fonts**, gradients  *(Pro)*
Creates variables in the Variables panel. `type` accepts: **`size`** (numbers/spacing — e.g. `"clamp(2rem,5vw,5rem)"` or `"48px"`), **`font`** (a font-family name), **`gradient`** (a CSS gradient), and `string`/`link`/`image`/`color`. `id` is optional — omit it and a `gvid-…` is generated.
```
POST /variables
{ "variables": [
    { "label": "Section Gap",  "value": "clamp(2rem,5vw,5rem)", "type": "size" },
    { "label": "Heading Font", "value": "Cormorant Garamond",    "type": "font" },
    { "label": "Hero Gradient","value": "linear-gradient(135deg,#1a1a2e,#0f172a)", "type": "gradient" }
] }
```

### Create / merge presets  *(Pro)*
```
POST /presets
{
  "presets": {
    "module": {
      "divi/heading": {
        "default": "",
        "items": {
          "my-preset-id": {
            "id": "my-preset-id", "name": "My Preset", "moduleName": "divi/heading",
            "version": "5.8.1", "type": "module",
            "created": 1700000000, "updated": 1700000000,
            "attrs": { /* styling — PRIMARY bucket, must be non-empty */ },
            "styleAttrs": { /* mirror of attrs — auxiliary */ },
            "renderAttrs": {}
          }
        }
      }
    }
  },
  "merge": true
}
```

### Delete a page or post (confirmation required)
```
DELETE /pages/{id}     (or /posts/{id})
```
**Safety:** without `confirm:true` the call does NOT delete — it returns `{ requires_confirmation:true, message, page:{title} }`. **Always confirm with the user first**, then re-call with `{"confirm": true}`. Default moves to Trash (recoverable); add `{"force": true}` only if the user explicitly wants permanent deletion.

### Theme Builder — global header / footer / body  *(Pro)*
```
GET    /theme-builder                     → list templates (template_id, header_id, body_id, footer_id, use_on)
POST   /theme-builder                     → create a layout (see below)
PUT    /theme-builder/{layout_id}/content → replace a layout's content in place
DELETE /theme-builder/{template_id}       → delete a template (confirm-gated, like pages)
```
**Create a global header or footer** (renders site-wide). Omit `use_on` → it attaches to the **Default Website Template** so it appears on every page:
```
POST /theme-builder
{ "title": "Site Header", "content": "<!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder -->", "layout_type": "header" }
```
- `layout_type`: `header` | `footer` | `body` (default `body`).
- For a **conditional** template, pass `use_on` with **valid Divi conditions** (e.g. `["singular:post_type:post:all"]`, `["404"]` for the 404 page — `general:all_pages` and `all_404_pages` are NOT valid). Omit `use_on` on header/footer for a true site-wide default.
- Returns `{ success, template_id, layout_type, layout_id, applied_to:"default_template"|"conditional_template", edit_layout }`.

> ⚠️ **A global header/footer only shows on pages whose `template` is `default`** (see §4). Pages created with the default `blank` template suppress it — so when a site has a global header/footer, create its pages with `"template": "default"`.

> **Escaping in Theme Builder content is identical to pages** — wrap inner HTML's `<`/`>` as `<`/`>` exactly as for `divi/code`/`divi/text` on a page. Do **not** pre-double backslashes for Theme Builder content (older workaround — no longer needed).

---

## §6 Full Session Checklist

1. User picks mode A (live site)
2. Ask for site URL + API key
3. Call `GET /design-system` — read colors, variables, presets. **Variable-availability gate:** if a needed token bucket is empty, ask the user → generate (`POST /colors` / `/variables`) or build inline (see "If a needed token bucket is empty" above).
4. Run discovery questions (page goal, sections, tone, etc.) — **wait for answers**
5. Write Page Plan using the site's real design tokens by name
6. **▸ APPROVAL GATE — present the plan and ask the user to approve or change it. STOP. Do NOT generate markup or call `POST /pages` yet.**
7. **If the user gives feedback/changes after seeing the plan, revise the plan and present it again. Keep iterating until they approve.**
8. Only after approval: generate Divi 5 markup (with tokens, not raw hex)
9. Call `POST /pages` — get live URL
10. Return URL + edit link to user

---

## §7 Error Handling

| HTTP status | Meaning | Action |
|---|---|---|
| 401 / 403 | Wrong or missing API key | Ask user to check their key from Settings → Divi Connect |
| **402** | **Pro feature on a Free site** | The endpoint requires Divi Connect **Pro** (managing colors/variables/presets, Theme Builder, global layouts, WooCommerce). Tell the user; free sites can still build/edit pages & posts and read the design system. |
| 404 on `/design-system` | Plugin not installed or not activated | Ask user to install Divi Connect from WP Admin → Plugins |
| **422** | **Markup validation failed** | The response `problems[]` lists exactly what's wrong (e.g. raw unescaped HTML in a value, wrong content key, `attrs` wrapper). Fix the markup and retry — nothing was created. |
| 500 on `/pages` | Markup parse error or WP insert failure | Check that content starts with `<!-- wp:divi/placeholder -->` and ends with `<!-- /wp:divi/placeholder -->` |
| 503 on `/theme-builder` | Divi Theme Builder functions not available | Only works on sites where Divi is the active theme |

---

*DIVI5-CONNECT — v1.1.0 | Divi Connect Plugin v1.4.0 | Builder Version 5.8.1*
