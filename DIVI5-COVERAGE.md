# DIVI5 Skill Files — Coverage Map

> What is confirmed, what is documented but untested, and what is not covered.

**Legend:** ✓ Confirmed = real-render tested · ⚙ Source = extracted from Divi theme source, pending render test · ✗ = not working.

---

## New in v0.5.1 (Divi 5.7.4) — ✓ all render-confirmed

> The authoring surface below was introduced in **5.7.0**. Patches **5.7.1–5.7.4** were bug-fix/builder-UI releases only — no new authoring features to confirm.


| Item | Status | Type | File |
|------|--------|------|------|
| Text gradient fill (`font.textEffects` `fillType:"gradient"`, linear) | ✓ Confirmed | system | STYLING §7b |
| Text image fill (`font.textEffects` `fillType:"image"`) | ✓ Confirmed | system | STYLING §7b |
| Text stroke (`font.textEffects` `strokeWidth`/`strokeColor`, hollow + fill+stroke) | ✓ Confirmed | system | STYLING §7b |
| Gradient fill on Text-module body (`bodyFont.body.font.textEffects`) | ✓ Confirmed | system | STYLING §7b |
| Gradient variables (`$variable({"type":"gradient"...})$`, `global_variables` type `gradients`) | ✓ Confirmed | system | STYLING §1, §10 |
| Expanded gradient model — conic / elliptical text fill (`directionRadial`, `repeat`, `length`) | ✓ Confirmed | system | STYLING §1 |
| Global presets (`builder_global_presets_d5`) — single preset, stacked presets, inline override | ✓ Confirmed | system | PRESETS |

> All ✓ render-confirmed via REST at all three breakpoints (scenario 27: linear fill, image fill, stroke, fill+stroke, text-body gradient; scenario 28: conic + elliptical text fill, gradient-variable token on both text fill and a group background; scenario 33: global presets — single, stacked, inline override). Gradient variables require the `--gvid-*` custom property injected into `:root` for REST workflows (mirrors the global-colors mu-plugin). Presets require styling in `attrs` (not just `styleAttrs`) and the mu-plugin must use `et_update_option()` to write to the correct `et_divi_builder_global_presets_d5` key.

---

## New in v0.4.0 (Divi 5.6.2) — ⚙ Source-verified

| Item | Type | File |
|------|------|------|
| `divi/svg` | module | MODULES-CONTENT |
| `divi/timeline` + `divi/timeline-item` | module | MODULES-CONTENT |
| `divi/breadcrumbs` | module | MODULES-CONTENT |
| `divi/table-of-contents` | module | MODULES-DATA |
| `divi/instagram-feed` | module | MODULES-DATA |
| `divi/dropdown` | module | MODULES-INTERACTIVE |
| `divi/contact-form-7` (CF7 styler) | module | MODULES-INTERACTIVE |
| Grid layout (`layout.display:"grid"` + grid keys) | system | LAYOUT §5b |
| Aspect ratio (`sizing.aspectRatio`) | system | STYLING §3 |
| Image framing (`fit` → object-fit/position) | system | STYLING §3b |
| Form pseudo-class states (focus/checked/active) | system | STYLING §10c |
| Variable generators (Color Scale / Harmony / fluid) | system | STYLING §10 |
| `divi/global-layout` | structure | LAYOUT §5c |
| Loop Builder (`advanced.loop`) | system | MODULES-DYNAMIC |
| Dynamic content family (blog/portfolio/post*/menu/search/login/sidebar/comments/map) | modules | MODULES-DYNAMIC |
| WooCommerce family (25 modules) | modules | MODULES-WOOCOMMERCE |

---

## Layout Containers — All Confirmed ✓

| Module | Status | Notes |
|--------|--------|-------|
| `divi/section` | ✓ Confirmed | Regular + fullwidth type |
| `divi/row` | ✓ Confirmed | flexColumnStructure, responsive stacking, max-width |
| `divi/column` | ✓ Confirmed | Flex sizing, responsive width |
| `divi/group` | ✓ Confirmed | Styled card container, background, border, padding, flex layout |
| `divi/group-carousel` | ✓ Confirmed | Multi-slide, autoplay, arrows, dots, center mode |

---

## Content Modules

| Module | Status | Notes |
|--------|--------|-------|
| `divi/heading` | ✓ Confirmed | All heading levels (h1–h6), font styling |
| `divi/text` | ✓ Confirmed | Rich text with HTML encoding |
| `divi/button` | ✓ Confirmed | Centering via `module.advanced.alignment`, ghost/outline style |
| `divi/image` | ✓ Confirmed | External URLs, sizing, alt text |
| `divi/blurb` | ✅ Deep-dive | useIcon image/icon, placement top/left, content-width, headingLink title (`url`/`target`), icon color — render-verified 5.7.4 (page 253) |
| `divi/cta` | ✓ Confirmed | Title, body, button |
| `divi/testimonial` | ✓ Confirmed | Portrait via `url` field |
| `divi/team-member` | ✓ Confirmed | Image via `url`, default image-left layout |
| `divi/link` | ✓ Confirmed | Static link + WordPress menu loop |
| `divi/icon` | ✓ Confirmed | FontAwesome unicode, color, size |
| `divi/icon-list` + `divi/icon-list-item` | ✓ Confirmed | icon-list is container; item is self-closing |
| `divi/divider` | ✓ Confirmed | Must set explicit border color on colored backgrounds |
| `divi/code` | ✓ Confirmed | Raw HTML injection; used for animated backgrounds, custom CSS |
| `divi/fullwidth-header` | ✓ Confirmed | Needs fullwidth section; button format uses combined `{text, linkUrl}` innerContent |
| `divi/svg` | ✓ Confirmed | inline `code` rendered (scenario 20); `{sourceType, code, src, linkUrl, linkTarget}` |
| `divi/timeline` + `divi/timeline-item` | ✓ Confirmed | 3-item vertical timeline rendered (scenario 20); parent `advanced.timeline={direction,position}` |
| `divi/breadcrumbs` | ✓ Confirmed | rendered Home/page (scenario 20); `home={text,url}`, `separator={text}`, `trail.advanced.htmlTag` |

---

## Interactive Modules

| Module | Status | Notes |
|--------|--------|-------|
| `divi/accordion` + `divi/accordion-item` | ✓ Confirmed | `open: 'on'` for first item |
| `divi/toggle` | ✓ Confirmed | Standalone, self-closing, no container needed |
| `divi/tabs` + `divi/tab` | ✓ Confirmed | First tab active by default, horizontal on mobile |
| `divi/contact-form` + `divi/contact-field` | ✓ Confirmed | See field types below |
| `divi/signup` | ✓ Confirmed | Email signup |
| `divi/dropdown` | ⚙ Source | `module.advanced.dropdown={showOn,direction,alignment,offset}` |
| `divi/contact-form-7` | ✓ Confirmed | rendered full form (scenario 21); `form.advanced.formId` = CF7 form ID |
| Form pseudo-class states | ⚙ Source | focus/checked/active under `<field>.advanced.<state>` (5.3.0) |
| Interactions system | ✓ Confirmed | Full trigger/target system with canvas popup pattern |

### Contact field types

| Type | Status | Notes |
|------|--------|-------|
| `text` | ✓ Confirmed | |
| `email` | ✓ Confirmed | |
| `textarea` | ✓ Confirmed | |
| `select` (dropdown) | ✓ Confirmed | Options in `fieldItem.advanced.selectOptions.desktop.value` as `[{value, id}]` |
| `checkbox` | ✓ Confirmed | Options in `fieldItem.advanced.checkboxOptions.desktop.value` as `[{value, checked, dragID}]` |
| `radio` | ✓ Confirmed | Same structure as checkbox options |
| `boolean_checkbox` | ✗ Not working | Silently skipped — use `checkbox` with a single option instead |

### Interaction triggers & effects

| Trigger | Status |
|---------|--------|
| `click` | ✓ Confirmed |
| `load` (with `timeDelay`) | ✓ Confirmed |
| `mouseEnter` | ✓ Confirmed |
| `mouseExit` | ✓ Confirmed |
| `viewportEnter` | Documented, not real-render tested |
| `viewportExit` | Documented, not real-render tested |

| Effect | Status |
|--------|--------|
| `toggleVisibility` | ✓ Confirmed |
| `addVisibility` | ✓ Confirmed |
| `removeVisibility` | ✓ Confirmed |

---

## Media Modules

| Module | Status | Notes |
|--------|--------|-------|
| `divi/video` | ✓ Confirmed | YouTube URLs in `video.innerContent.desktop.value.src` |
| `divi/slider` + `divi/slide` | ✓ Confirmed | Per-slide background, nav dots auto-generated |
| `divi/video-slider` + `divi/video-slider-item` | ✓ Confirmed | Film-strip thumbnails auto-generated; `title`/`description` on items silently ignored |
| `divi/before-after-image` | ✓ Confirmed | Both sides accept external URLs |
| `divi/audio` | ✓ Confirmed | `audio.innerContent.desktop.value` = **plain string URL** (NOT object) |
| `divi/lottie` | ✓ Confirmed | `lottie.innerContent.desktop.value.src` = object with `src` key |
| `divi/gallery` | ⚠️ Partial | Grid layout attrs work; **images cannot be passed via JSON** — requires WP media library IDs set via editor |

---

## Data & Display Modules

| Module | Status | Notes |
|--------|--------|-------|
| `divi/number-counter` | ✓ Confirmed | Intersection observer — needs scroll-through before screenshot |
| `divi/circle-counter` | ✓ Confirmed | Arc color matches number color |
| `divi/counters` + `divi/counter` | ✓ Confirmed | Bar progress; `usePercentages: 'on'` on parent adds % suffix |
| `divi/pricing-tables` + `divi/pricing-table` | ✓ Confirmed | One table per container per column for mobile stacking |
| `divi/social-media-follow` + network | ✓ Confirmed | facebook, twitter, instagram, linkedin, youtube confirmed |
| `divi/countdown-timer` | ✓ Confirmed (UI) | Live countdown requires browser; headless Playwright shows static render only |
| `divi/table-of-contents` | ✓ Confirmed | built ordered list linking post `<h2>`s in a TB body template over a Gutenberg post. Must be built via builder UI (raw-REST insert won't enqueue its client-side script); list populates in-browser only. |
| `divi/instagram-feed` | ⚙ Source | `feed.innerContent={accountId,postCount}`; grid layout; needs connected IG account |

---

## Canvas & Global Modules

| Feature | Status | Notes |
|---------|--------|-------|
| Local canvas | ✓ Confirmed | `canvases.local` — page-specific canvas content |
| Global canvas | Documented, not tested | `canvases.global` — site-wide reusable canvas |
| `divi/canvas-portal` | ✓ Confirmed | Renders an inline canvas by `_divi_canvas_id` |
| Canvas popup (fixed overlay) | ✓ Confirmed | Full pattern in DIVI5-MODULES-INTERACTIVE.md |
| `divi/global-layout` | Observed in real page | References a saved global module by WP post ID — not yet documented in skill files |

---

## Styling Systems

| Feature | Status | Notes |
|---------|--------|-------|
| Background color (solid) | ✓ Confirmed | All containers and most modules |
| Background image | ✓ Confirmed | `url`, `size`, `position`, `repeat` |
| Background gradient | ✓ Confirmed | Linear and elliptical; with/without color stops |
| Background image + gradient overlay | ✓ Confirmed | Combine `image` and `gradient` keys in same `value` |
| Global color variables | ✓ Confirmed | `$variable({"type":"color",...})$` |
| Global color variable with opacity | ✓ Confirmed | `settings: {"opacity": N}` where N = percentage |
| Global font-size / content variables | ✓ Confirmed (with caveat) | Inlines simplified literal value — not CSS `var()` |
| Spacing (padding / margin) | ✓ Confirmed | Per-side, sync options, responsive |
| Border (width, style, color, radius) | ✓ Confirmed | |
| Typography (family, size, weight, color, line-height, alignment) | ✓ Confirmed | |
| Sizing (width, height, min-height, max-width) | ✓ Confirmed | |
| Position (static, absolute, fixed) | ✓ Confirmed | With origin and offset |
| Z-index | ✓ Confirmed | |
| Overflow | ✓ Confirmed | `x`/`y` scroll/hidden |
| Box shadow | Documented, not real-render tested | |
| Aspect ratio (`sizing.aspectRatio`) | ✓ Confirmed | square tiles rendered (scenario 20); `{width, height}` |
| Image framing (`fit` object-fit/position) | ✓ Confirmed | `objectFit:"cover"` cropped cleanly (scenario 20) |
| Grid layout (`layout.display:"grid"`) | ✓ Confirmed | equal grid rendered (scenario 20). **Does NOT auto-stack on mobile — set responsive `gridColumnCount`.** |
| Variable generators (Color Scale/Harmony/fluid) | ⚙ Source | produce ordinary tokens; reference syntax unchanged |
| Form pseudo-class states (focus/checked/active) | ⚙ Source | (5.3.0) |
| Responsive breakpoints (desktop, tablet, phoneWide, phone) | ✓ Confirmed | Values do not inherit across breakpoints |
| HTML attributes (id, class, data-*) | ✓ Confirmed (real page) | `module.decoration.attributes` |
| Admin label | ✓ Confirmed | `module.meta.adminLabel.desktop.value` |

---

## Dynamic Content Modules — ⚙ Source-verified (MODULES-DYNAMIC)

Now documented from source. Output depends on real WordPress content on the target site.

| Module | Status | Notes |
|--------|--------|-------|
| `divi/blog` | ✓ Confirmed | rendered posts (scenario 21); `post.advanced` query + `blogGrid` columns |
| `divi/portfolio` / `divi/filterable-portfolio` / `divi/fullwidth-portfolio` | ✓ Confirmed | rendered project grid + filter tabs (scenario 23); `project` CPT |
| `divi/post-title` / `divi/post-content` | ✓ Confirmed | rendered in a TB body template (post H1 + meta; post body incl. headings) |
| `divi/post-slider` | ✓ Confirmed | recent posts as slides (scenario 32); standalone, runs own WP_Query; set explicit bg color |
| `divi/post-nav` | ✓ Confirmed | prev/next links (scenario 34) in a single-post TB body template; `inSameTerm` |
| `divi/menu` / `divi/fullwidth-menu` | ✓ Confirmed | rendered assigned nav menu (scenario 25); **`menu.advanced.menuId` (term ID) required**; set link color for contrast |
| `divi/search` | ✓ Confirmed | rendered search input (scenario 25) |
| `divi/login` | ✓ Confirmed | rendered full login form (scenario 25); `currentPageRedirect` |
| `divi/sidebar` | ✓ Confirmed | rendered `sidebar-1` widget area (scenario 25) |
| `divi/comments` | ✓ Confirmed | rendered comment form in a TB body template |
| `divi/map` + `divi/map-pin` / `divi/fullwidth-map` | ⚙ Source | **needs Google Maps API key**; `lat`/`lng`/`zoom` numeric |
| Loop Builder (`module.advanced.loop`) | ✓ Confirmed | post-types loop on a group rendered a card per post w/ `loop_*` dynamic content (scenario 22); server-side, works via REST. `subTypes`=`[{value}]` objects |
| Dynamic Content tokens (`$variable type:content`) | ✓ Confirmed | `loop_post_title/excerpt/date/...` inside loops; `post_*` for current post |
| `divi/global-layout` | ✓ Confirmed | references a saved `et_pb_layout` (scope=global) via **`globalModule`** (string id, NOT `ref`); reused twice on one page (scenario 33) |

## WooCommerce Modules — ✓ ALL 25 render-confirmed (MODULES-WOOCOMMERCE)

Entire family verified against fixture products with real data (scenarios 29 product / 30 cart / 31 checkout), all 3 breakpoints. Requires **WooCommerce active**.

| Group | Modules | Status |
|-------|---------|--------|
| Shop/collection | `shop`, `related-products`, `product-upsell`, `cross-sells` | ✓ Confirmed |
| Single-product | `product-title`, `-price`, `-images`, `-gallery`, `-description`, `-add-to-cart`, `-meta`, `-rating`, `-reviews`, `-stock`, `-tabs`, `-additional-info`, `-breadcrumb` | ✓ Confirmed |
| Cart | `cart-products`, `cart-totals`, `cart-notice` | ✓ Confirmed |
| Checkout | `checkout-billing`, `-shipping`, `-additional-info`, `-order-details`, `-payment-info` | ✓ Confirmed |

- Single-product modules use `content.advanced.product:"dynamic"` **or a specific product ID string** (confirmed).
- `product-gallery`/`-rating`/`-stock` (previously empty) now confirmed with a 3-image gallery, reviews (4.5★), and managed stock.
- **Cart/checkout need a cart context** (WC cart/checkout page, a TB template, or a session with a non-empty cart). ⚠️ Checkout modules **fatal at REST insert** without a cart session — boot a WC cart first (see MODULES-WOOCOMMERCE).

## Still Not Covered

| Module | Reason |
|--------|--------|
| `divi/gallery` (images) | Images require WP media library IDs — cannot be defined in standalone JSON (grid attrs work) |
| `divi/instagram-feed` | Needs a connected Instagram account |
| `divi/map` / `map-pin` | Needs a Google Maps API key |
| Fullwidth post/menu/map variants | Same attrs as standard variants; need a fullwidth section / external service |

---

## Known Gotchas (Things That Silently Fail or Crash)

| Issue | Impact |
|-------|--------|
| `innerContent.desktop.value` is an array | WordPress 500 crash — always use string or object |
| `audio.innerContent.desktop.value` as object | WordPress 500 crash — must be plain string URL |
| `builderVersion` missing on any module | Module fails to render or import |
| `boolean_checkbox` contact field | Silently skipped — use `checkbox` with one option |
| `gallery` images in JSON | WordPress 500 crash |
| Button alignment not set per-breakpoint | Falls back to left-aligned on mobile |
| `pricing-tables` with multiple tables in one container | Does not stack on mobile |
| Numeric variables (`gvid-*`) used for precise `clamp()` | Divi inlines the minimum value only |
| Empty column with background image and no child modules | Collapses to zero height — add `minHeight` |
| Transparent button background | Button text invisible on any background — use border instead |
| `divi/divider` on colored background | Invisible — must set explicit border color |
| `number-counter` / `circle-counter` in headless screenshot | Counter stays blank if page not scrolled — uses intersection observer |
| Woo checkout modules (billing/shipping/additional-info/payment) inserted via plain REST with empty cart | HTTP 500 at save time (Divi renders blocks for critical CSS) — place on the Checkout page/TB template, or boot a WC cart before insert |

---

*DIVI5 Coverage Map — V0.5.1 | Builder Version 5.7.4*
