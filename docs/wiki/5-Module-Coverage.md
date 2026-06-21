# Module Coverage

The skill aims to cover the full Divi 5 authoring schema. `DIVI5-COVERAGE.md` is the
authoritative, always-current status list; this page is a high-level map.

## Families
- **Layout** — section, row, column, group, group-carousel, Grid layout, global-layout
- **Content** — heading, text, button, image, blurb, CTA, testimonial, team-member,
  link, icon, icon-list, divider, code, fullwidth-header, svg, timeline, breadcrumbs
- **Interactive** — accordion, toggle, tabs, contact-form (+ fields), signup, dropdown,
  contact-form-7, interactions
- **Media** — video, gallery, slider, video-slider, lottie, audio, before-after-image
- **Data** — number/circle/bar counters, countdown, pricing tables, social, social-follow,
  table-of-contents, instagram-feed
- **Dynamic** — blog, portfolio (+ filterable), post modules, menu, search, login,
  sidebar, comments, map, **Loop Builder** + dynamic content tokens
- **WooCommerce** — shop, the single-product family, cart, and checkout modules
- **Systems** — the token/variable system, gradients (+ gradient variables), text fill
  effects, aspect-ratio, image framing, Global Presets, Theme Builder templates

## Verification levels
Entries in `DIVI5-COVERAGE.md` are marked as one of:
- **✓ render-verified** — produced on a real site and confirmed at desktop/tablet/mobile
- **⚙ source-verified** — extracted from the Divi theme source, not yet render-tested
- **deep-dive** — exhaustively documented under the per-module protocol
  (see [Contributing](6-Contributing.md))

A few modules depend on external services (e.g. a connected Instagram account, a Maps
API key) and are noted accordingly.
