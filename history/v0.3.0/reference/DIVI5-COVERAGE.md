# DIVI5 Skill Files — Coverage Map

> What is confirmed, what is documented but untested, and what is not covered.

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
| `divi/blurb` | ✓ Confirmed | Icon/image + title + text card |
| `divi/cta` | ✓ Confirmed | Title, body, button |
| `divi/testimonial` | ✓ Confirmed | Portrait via `url` field |
| `divi/team-member` | ✓ Confirmed | Image via `url`, default image-left layout |
| `divi/link` | ✓ Confirmed | Static link + WordPress menu loop |
| `divi/icon` | ✓ Confirmed | FontAwesome unicode, color, size |
| `divi/icon-list` + `divi/icon-list-item` | ✓ Confirmed | icon-list is container; item is self-closing |
| `divi/divider` | ✓ Confirmed | Must set explicit border color on colored backgrounds |
| `divi/code` | ✓ Confirmed | Raw HTML injection; used for animated backgrounds, custom CSS |
| `divi/fullwidth-header` | ✓ Confirmed | Needs fullwidth section; button format uses combined `{text, linkUrl}` innerContent |

---

## Interactive Modules

| Module | Status | Notes |
|--------|--------|-------|
| `divi/accordion` + `divi/accordion-item` | ✓ Confirmed | `open: 'on'` for first item |
| `divi/toggle` | ✓ Confirmed | Standalone, self-closing, no container needed |
| `divi/tabs` + `divi/tab` | ✓ Confirmed | First tab active by default, horizontal on mobile |
| `divi/contact-form` + `divi/contact-field` | ✓ Confirmed | See field types below |
| `divi/signup` | ✓ Confirmed | Email signup |
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
| Responsive breakpoints (desktop, tablet, phoneWide, phone) | ✓ Confirmed | Values do not inherit across breakpoints |
| HTML attributes (id, class, data-*) | ✓ Confirmed (real page) | `module.decoration.attributes` |
| Admin label | ✓ Confirmed | `module.meta.adminLabel.desktop.value` |

---

## Not Covered / Untested

These modules are known to exist in Divi 5 but have no confirmed JSON structure in the skill files. Using them may produce unexpected results.

| Module | Reason not covered |
|--------|-------------------|
| `divi/gallery` (images) | Images require WP media library IDs — cannot be defined in standalone JSON |
| `divi/map` | Requires a Google Maps API key configured on the target WordPress site |
| `divi/menu` | Navigation menu module — distinct from link loop; field structure not confirmed |
| `divi/search` | No confirmed field structure |
| `divi/sidebar` | Requires WordPress widget area to be configured |
| `divi/login` | No confirmed field structure |
| `divi/dropdown` | No confirmed field structure |
| `divi/post-nav` | Previous/next post navigation — only relevant inside post templates |
| `divi/blog` | Requires WordPress posts to exist on site |
| `divi/post-carousel` | Requires WordPress posts |
| `divi/post-slider` | Requires WordPress posts |
| `divi/post-title` | Only meaningful inside a single post template |
| `divi/portfolio` | Requires Divi Project CPT content |
| `divi/filterable-portfolio` | Requires Divi Project CPT content |
| `divi/comments` | Requires WordPress post with comments |
| `divi/pagination` | Only renders inside a loop context |
| `divi/global-layout` | Global saved modules — requires the saved module to exist on the target site |
| WooCommerce modules | Entire WooCommerce module family — untested |

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

---

*DIVI5 Coverage Map — V0.3.0 | Builder Version 5.1.0*
