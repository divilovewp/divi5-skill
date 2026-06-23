# Divi 5 Skill — Known Caveats & Limitations

> The detailed source of truth behind each item is [`DIVI5-COVERAGE.md`](DIVI5-COVERAGE.md)
> (the canonical coverage map, v0.5.1 / Divi 5.7.4).

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
- **Transparent button background** → invisible text; use a border instead.
- **`divi/divider`** has a native line that is on-by-default — set its color explicitly (don't add a separate border, or you get a double line).
- **Button alignment** must be set **per breakpoint** or it falls back to left-aligned on mobile.
- **`pricing-tables`** with multiple tables in one container won't stack on mobile (use one table per container per column).
- **Empty column** with a background image and no children collapses to zero height — add `minHeight`.
- **`number-counter` / `circle-counter` / `countdown-timer` / `table-of-contents`** need a real browser (scroll / JS); headless screenshots show blank or static output. TOC must be built via the builder UI, not raw REST.
- **Responsive values do not inherit** across breakpoints — set each breakpoint you care about.

## 4. Documented from source but not render-tested (⚙)

`divi/dropdown`, form pseudo-class states (focus/checked/active), `divi/instagram-feed`, `divi/map`,
box-shadow, `viewportEnter` / `viewportExit` interaction triggers, global canvas, and the variable
generators (Color Scale / Harmony / fluid). These are extracted from Divi source and should work, but
haven't been confirmed with a real render.

## 5. Version & scope

- The skill is confirmed against **Divi 5.7.4** (v0.5.1). Newer Divi 5 releases (e.g. 5.8.0, and a build
  released ~2026-06-20) are **not yet recorded** in the skill — treat newer-than-5.7.4 features as unverified.
- Still on the skill backlog: documenting **Canvas creation/usage** and the **native off-canvas menu pattern**
  (see `BACKLOG.md` in the divi-connect repo).

---

*Generated from DIVI5-COVERAGE.md (V0.5.1 · Builder Version 5.7.4). Keep both in sync when coverage changes.*
