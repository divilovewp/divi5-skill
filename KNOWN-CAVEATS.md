# Divi 5 Skill — Known Caveats & Limitations

> The detailed source of truth behind each item is [`DIVI5-COVERAGE.md`](DIVI5-COVERAGE.md)
> (the canonical coverage map, v0.6.0 / Divi 5.8.1).

These are the known limits of building Divi 5 with the skill (and, by extension, via Divi Connect). They
fall into five buckets.

---

## 1. Hard failures — crash or silently drop

| Caveat | Effect | Do this instead |
|---|---|---|
| `innerContent.desktop.value` passed as an **array** | WordPress 500 | Always a string or object |
| `audio.innerContent…value` as an **object** | WordPress 500 | Plain string URL |
| **`builderVersion` missing** on a module | Module won't render/import | Always stamp `builderVersion` |
| `divi/gallery` **images in JSON** | WordPress 500 | Grid attrs work; images need WP media-library IDs (set in editor) |
| `boolean_checkbox` contact field | Silently skipped | Use `checkbox` with a single option |
| Woo **checkout** modules via plain REST with an **empty cart** | HTTP 500 at save | Place on the Checkout page / a TB template, or boot a WC cart first |

## 2. Not covered at all (need external services or the editor)

- `divi/gallery` **images** — require WP media-library IDs, can't be defined in standalone JSON.
- `divi/instagram-feed` — needs a connected Instagram account.
- `divi/map` / `divi/map-pin` — need a Google Maps API key.
- Fullwidth post / menu / map variants — same attrs as the standard variants but need a fullwidth section / external service.

## 3. Renders, but with behavioral gotchas

- **Size / numeric variables (`gvid-*`)** inline a simplified literal value, **not** a CSS `var()` — a precise `clamp()` collapses to its minimum. (This is exactly why Divi Connect's Free tier "bakes" size tokens.)
- **Grid layout** does **not** auto-stack on mobile — set a responsive `gridColumnCount`.
- **Text columns** (`font.columnCount`, NEW 5.8.0) also do **not** auto-stack on mobile — set a responsive `columnCount:"1"`.
- **Transparent button background** → invisible text; use a border instead.
- **`divi/divider`** has a native line that is on-by-default — set its color explicitly (don't add a separate border, or you get a double line).
- **Button alignment** must be set **per breakpoint** or it falls back to left-aligned on mobile.
- **`pricing-tables`** with multiple tables in one container won't stack on mobile (use one table per container per column).
- **Empty column** with a background image and no children collapses to zero height — add `minHeight`.
- **`number-counter` / `circle-counter` / `countdown-timer` / `table-of-contents`** need a real browser (scroll / JS); headless screenshots show blank or static output. TOC must be built via the builder UI, not raw REST.
- **`divi/tooltip`** (NEW 5.8.0) hover/click triggers + final placement are **script-dependent** — on a raw REST page the tooltip script may not enqueue (like TOC), so the popover never reveals; `trigger:"always"` renders without JS. Build via the builder UI for hover/click.
- **Stale `_divi_dynamic_assets_cached_modules` post meta** — Divi 5 caches each page's module list in this post meta to decide which JS bundles to enqueue. If a script-dependent module (slider, entrance animation, scroll effect, sticky, TOC) is **added to a page whose cache predates it**, its script never enqueues: a slider renders all slides stacked vertically with dead arrows/dots, animations/sticky sit inert. Fix: `wp post meta delete <id> _divi_dynamic_assets_cached_modules` + clear `wp-content/et-cache/` after programmatic imports — Divi rebuilds the cache on the next load. This is likely the mechanism behind the raw-REST TOC/tooltip script failures above. (Tested on Divi 5.7.0 → 5.8.1, portability-imported pages.)
- **Responsive values do not inherit** across breakpoints — set each breakpoint you care about.

## 4. Documented from source but not render-tested (⚙)

`divi/dropdown`, form pseudo-class states (focus/checked/active), `divi/instagram-feed`, `divi/map`,
box-shadow, `viewportEnter` / `viewportExit` interaction triggers, global canvas, and the variable
generators (Color Scale / Harmony / fluid). These are extracted from Divi source and should work, but
haven't been confirmed with a real render.

## 5. Version & scope

- The skill is confirmed against **Divi 5.8.1** (v0.6.0). The 5.8.0 additions — Tooltip module + the
  Advanced Text Styling batch (variable fonts, columns, drop caps, vertical text, line-wrap, hyphenation,
  paragraph spacing, stroke position) — are recorded and render-confirmed. Treat any feature newer than
  5.8.1 as unverified.
- Still on the skill backlog: documenting **Canvas creation/usage** and the **native off-canvas menu pattern**
  (see `BACKLOG.md` in the divi-connect repo).

---

*Generated from DIVI5-COVERAGE.md (V0.6.2 · Builder Version 5.8.1). Keep both in sync when coverage changes.*
