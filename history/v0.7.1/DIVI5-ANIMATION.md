---
name: divi5-animation
description: Native motion in Divi 5 — the Animation group (entrance reveal on viewport enter), Scroll Effects (scroll-linked parallax), Interactions, Sticky, Transition and Transform. Attribute paths, valid values, defaults, and the silent-failure traps.
author: vault research (Divi 5.12.1 source + official docs)
---

# DIVI5 Skill — Animation & Motion
> **Part of the DIVI5 skill set. Attach when animating anything — entrance reveals, scroll-linked effects, sticky elements, or transitions.**
> Skill files: BASE · LAYOUT · STYLING · ANIMATION (this) · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS

> **Researched against Divi 5.12.1** (2026-09-09). The upstream skill files do
> not cover animation: `Interactions` is documented in MODULES-INTERACTIVE, but
> the `animation` / `transform` keys appear only as four stray rows in a
> PRESETS table.

## Provenance markers

| Marker | Meaning |
|---|---|
| ✓ **SOURCE** | Verified in the Divi 5.12.1 theme source (file cited) |
| 📖 **DOCS** | Official Elegant Themes documentation |
| ⚠️ **INHERITED** | From the upstream skill, not re-verified here |
| ❓ **OPEN** | Not yet verified — see §8 |

---

## 1. Three mechanisms — do not confuse them

The most common conceptual error is assuming that "animate as the page scrolls"
means *Scroll Effects*. **It does not.**

| | **Animation** | **Scroll Effects** | **Interactions** |
|---|---|---|---|
| UI tab | Design | Advanced | Advanced |
| When it runs | Once, when the element **enters the viewport** | **Continuously**, tied to scroll position | When the trigger fires |
| Behaviour | Appears and **stays** | Moves back and forth as you scroll (parallax) | Depends on the effect |
| Target | Itself | Itself | Itself **or another** element |
| Attribute | `<element>.decoration.animation` ✓ | `module.decoration.scroll` ✓ | `module.decoration.interactions` ✓ |

> **Content revealing as the page scrolls down** — the modern-site pattern where
> a block rises a few pixels and fades in — is the **Animation** group, not
> Scroll Effects.

---

## 1b. Attribute format — the rule governing everything below

📖 DOCS — [Attribute Format](https://dev.elegantthemes.com/docs/explanations/module/attribute-format/)
(**developer** docs, not the Help Center). This is the canonical spec and
explains the shape of every group below.

**Base structure:** `breakpoint > mode > value`

```json
{ "desktop": { "value": "40px", "hover": "42px", "sticky": "44px" },
  "tablet":  { "value": "30px" },
  "phone":   { "value": "20px" } }
```

- State modes: `value` (default), `hover`, `sticky` — **inside** the breakpoint.
  This confirms the rule in `DIVI5-STYLING.md` §7c.
- **`subName`** = a property **inside** `desktop.value`
  (e.g. `boxShadow.desktop.value.horizontal`).
- **Nested option group** = a named key **above** the breakpoint layer
  (e.g. `button.font.font.desktop.value`).

> 🚨 **The rule that separates them:** a nested group name **never** sits next to
> `desktop`. Siblings of `desktop` may only be other breakpoints.

This is how to read `ScrollPresetAttrsMap`: when the source declares
`subName => 'verticalMotion.enable'`, it means
`module.decoration.scroll.desktop.value.verticalMotion.enable` — `verticalMotion`
is a **subName inside `value`**, not a nested group.

---

## 2. Animation group — entrance reveal

**Path:** `<element>.decoration.animation` — ✓ SOURCE:

| File:line | Read |
|---|---|
| `ModuleElements.php:1093` | `$element_attr['decoration']['animation']` |
| `ImageWrapperAnimation.php:34` | same |
| `BlurbModule.php:941` | `$attrs['imageIcon']['decoration']['animation']` |
| `ContactFieldModule.php:663` | `$parent_attrs['field']['decoration']['animation']` |

### 🔑 Not only on `module` — sub-elements take it too

The group can hang off any element of a module, not just the root:

- `module.decoration.animation` → the whole module
- `imageIcon.decoration.animation` → only the image/icon of a `divi/blurb`
- `field.decoration.animation` → only the field of a form

> 🚨 **Animation on a sub-element that is not rendered is inert.** An
> `imageIcon.decoration.animation` on a `divi/blurb` **with no image and no
> icon** produces nothing: the wrapper does not exist, so the key sits in the
> JSON with no effect. The markup looks correct and throws no error — a
> render-only failure.

### How Divi applies it

✓ SOURCE (`AnimationUtils.php:51-57`) — `classnames()` returns the class
**`et_animated`**, and only when `FeaturesManager::get('anim')` is on. The rest
travels as **script data** (an "animation data" generator just below takes `id`,
`selector`, `attr` and `moduleAttrs`).

> ⚠️ Animation therefore **depends on JS**. That is the technical reason behind
> the import trap in §7 — without the bundle enqueued the class is emitted but
> nothing animates.

### Keys — ✓ SOURCE (`Packages/Module/Options/Animation/`)

Defaults read from `AnimationUtils.php:345-501`:

| Key | Values | Default |
|---|---|---|
| `style` | `fade`, `slide`, `bounce`, `zoom`, `flip`, `fold`, `roll` | `none` |
| `direction` | `center`, `top`, `bottom`, `left`, `right` | `center` |
| `duration` | one cycle | `1000ms` |
| `delay` | delay before start — **this is what staggers** | `0ms` |
| `intensity.<style>` | movement strength — **object per style**, see below | `50%` |
| `startingOpacity` | initial opacity — **this is what fades in** | `0%` |
| `speedCurve` | `ease-in`, `ease-out`, `ease-in-out`, `linear` | `ease-in-out` |
| `repeat` | `once`, `loop` | `once` |

An invalid `direction` does **not** error — it silently falls back to `center`
(`filter_value`, line 372).

### `intensity` is an object keyed by style

✓ SOURCE (`RowPresetAttrsMap.php`) — not a single value; five independent keys,
so switching styles preserves each one's intensity:

```json
"intensity": { "slide": "50%", "zoom": "50%", "flip": "50%",
               "fold": "50%", "roll": "50%" }
```

Only those five exist (`slide`, `zoom`, `flip`, `fold`, `roll`) — `fade` and
`bounce` have no entry of their own, even though the frontend requires a value.

### 🚨 `direction` is not an independent field — it is appended to `style`

✓ SOURCE (`AnimationUtils.php:336-341`; the field itself is marked
`'skip' => true` with the comment *"direction will be appended to style"*):

```php
if ( 'center' !== $direction ) { $value .= ucfirst( $direction ); }
```

So the real effect is **`style` + `ucfirst(direction)`**: `slide` + `left` =
`slideLeft`. With `center` there is no suffix — `center` is the **neutral**
value ("no direction"), not "from the centre".

### Not every style accepts `direction`

✓ SOURCE (`AnimationUtils.php:239-270`, `_get_options()`):

| `style` | Takes `direction`? | Valid options |
|---|---|---|
| `fade` | ❌ **no** | style, duration, delay, intensity\*, startingOpacity, speedCurve, repeat |
| `bounce` | ✅ yes | + `direction` |
| `slide` `zoom` `flip` `fold` `roll` | ✅ yes | full set |
| `none` | — | `[]` (none) |

> 🚨 **`fade` is always just `fade`.** There is no `fadeBottom`, `fadeLeft`, etc.
> To "rise into view" the style is **`slide` with `direction: bottom`** — or
> plain `fade` with no displacement.

\* **`intensity` gotcha:** the source comment reads *"Intensity setting is not
exist in VB when the style is `fade`. But it is required in FE."* For `fade` and
`bounce` the field is **absent from the Visual Builder**, yet the frontend
requires the value. Include it when authoring JSON by hand.

### `repeat: loop` — the one native infinite repeat

✓ SOURCE. **It restarts each cycle** — good for drawing attention to a
decorative element, but it does **not** produce seamless continuous scrolling
(see §6).

### Where animation can be applied

📖 DOCS — Elegant Themes state, across several articles, that animation options
exist on *"any Divi section, row, column, or module"* (Design ▸ Animation). The
source confirms this partially:

| Element | Status |
|---|---|
| **Module** | ✓ SOURCE — `ModuleElements.php:1093`, plus Blurb and ContactField |
| **Row** | ✓ SOURCE — `RowPresetAttrsMap.php:660-690`, all 12 `module.decoration.animation__*` keys |
| **Section** | 📖 DOCS say yes; ⚠️ `SectionPresetAttrsMap.php` exists but does **not** list `animation` |
| **Column** | 📖 DOCS say yes; ❓ no `PresetAttrsMap` at all (only `ColumnModule.php`) |

> **Reading the discrepancy:** a *PresetAttrsMap* governs what an **Option Group
> Preset** can capture — not whether the attribute renders. The likely meaning is
> that Section and Column animate but are **not preset-able**.
> **Row is the safe bet for animating a whole block** — the only container
> confirmed on both ends.

### Recipe — discreet reveal on scroll

The combination that makes a block rise into view as it enters the viewport:

```json
"module": { "decoration": { "animation": { "desktop": { "value": {
  "style":           "slide",
  "direction":       "bottom",
  "duration":        "600ms",
  "delay":           "0ms",
  "startingOpacity": "0%",
  "speedCurve":      "ease-out",
  "repeat":          "once",
  "intensity":       { "slide": "20%" }
} } } } }
```

- `style: slide` + `direction: bottom` → `slideBottom`. Plain `fade` gives no
  displacement — see the `direction` table above.
- `startingOpacity: 0%` produces the fade-in; without it the block only slides.
- Low `intensity` = short, sober movement. 📖 DOCS: *"lowering the intensity
  creates a smoother and more subtle animation"*.
- Divi's default `duration` of `1000ms` is slow for a reveal — shorten it.

### Staggered (cascade) effect

📖 DOCS — done **with `delay` alone**, incremented element by element. Elegant
Themes' own example uses **50ms** steps:

| Element | `delay` |
|---|---|
| 1st | `0ms` |
| 2nd | `50ms` |
| 3rd | `100ms` |
| 4th | `150ms` |

There is **no native stagger control** — it is one `delay` key per element. With
many items the total grows fast (10 items at 50ms = 500ms before the last one
even starts).

### Best practices — 📖 DOCS

Keep it subtle (motion must not compete with content), stagger with delays, test
on devices and slow connections, and match the animation to the site's tone.

---

## 3. Scroll Effects — scroll-linked parallax

**Path:** `module.decoration.scroll` — ✓ SOURCE
(`Options/ScrollSettings/ScrollSettingsPresetAttrsMap.php:36`).

### The six effects — ✓ SOURCE (`Options/Scroll/ScrollPresetAttrsMap.php`)

| JSON key | UI name (📖 DOCS) |
|---|---|
| `verticalMotion` | Vertical Motion |
| `horizontalMotion` | Horizontal Motion |
| `fade` | Fade In & Out |
| `scaling` | Scale Up & Down |
| `rotating` | Rotate |
| `blur` | Blur |

Each effect appears twice in the preset map: `<effect>.enable` and `<effect>`.

> **Typo in the official docs:** the sixth effect is listed as *"Blurb"* in the
> Help Center article. The source key is `blur`. Not related to `divi/blurb`.

### Trigger — `motionTriggerStart` ✓ SOURCE

📖 DOCS for the semantics:

| Value | Behaviour |
|---|---|
| `Top` | starts when the **top** of the module enters the viewport |
| `Middle` | starts when the **middle** is visible |
| `Bottom` | starts when the **bottom** is in view |

Default: `"middle"` (✓ SOURCE). Lowercase in JSON.

### Full shape of each effect — ✓ SOURCE

`ScrollEffectsUtils.php:36` (`$scroll_effect_default_group_attr`) and
`ScrollEffectsScriptData.php:152` (`$parent_attr['decoration']['scroll']`).

```json
"module": { "decoration": { "scroll": { "desktop": { "value": {
  "motionTriggerStart": "middle",
  "verticalMotion": {
    "enable":   "off",
    "viewport": { "bottom": "0", "end": "50", "start": "50", "top": "100" },
    "offset":   { "start": "4", "mid": "0", "end": "-4" }
  }
} } } } }
```

Every effect has exactly `enable` · `viewport` · `offset`. `motionTriggerStart`
is a sibling of the effects, not a child.

> 💡 `ScrollEffectsScriptData.php:152-154` shows `decoration.scroll` travelling
> to the frontend script alongside **`decoration.transform`**. Both compose into
> the same CSS `transform`.

### 🚨 Trap: the `viewport` key names are counter-intuitive

✓ SOURCE (`ScrollEffectsUtils.php:510-537`) — the constants reveal the keys do
not mean what they appear to:

| JSON key | What it actually is | Default |
|---|---|---|
| `viewport.bottom` | **start limit** | `0` |
| `viewport.end` | **start middle** | `50` |
| `viewport.start` | **end middle** | `50` |
| `viewport.top` | **end limit** | `100` |

`start` is the **end** of the middle band and `end` is its **start** — swapped.
"Fixing" them breaks the effect.

`offset` is straightforward: `start` → `mid` → `end` are the effect's three
values along the path (`ScrollEffectsUtils.php:546-564`).

### Defaults per effect — ✓ SOURCE

All start `enable: "off"`. Viewport is `bottom 0 / end 50 / start 50 / top 100`
for every effect **except `blur`** (`end 40 / start 60`).

| Effect | `offset.start` | `offset.mid` | `offset.end` |
|---|---|---|---|
| `verticalMotion` | `4` | `0` | `-4` |
| `horizontalMotion` | `4` | `0` | `-4` |
| `fade` | `0` | `100` | `100` |
| `scaling` | `70` | `100` | `100` |
| `rotating` | `90` | `0` | `0` |
| `blur` | `10` | `0` | `0` |

Read as: `fade` goes opacity 0 → 100 → 100; `scaling` 70% → 100% → 100%;
`rotating` 90° → 0 → 0. The defaults already describe a **reveal** — they enter
animating and settle.

### `gridMotion` does not exist

✓ SOURCE. It is **commented out** in `ScrollPresetAttrsMap.php`
(`// "{$attr_name}__gridMotion.enable"`). Do not use it.

---

## 4. Interactions — trigger / effect / target

**Path:** `module.decoration.interactions` — ✓ SOURCE (`Module.php:506`; also
`OffCanvasHooks.php:1590` and `:3157`).

📖 DOCS for semantics. ❓ OPEN: the internal array schema (MODULES-INTERACTIVE
covers the system, but against 5.11.1).

**Triggers:** `Click` · `Mouse Enter` / `Mouse Exit` · `Viewport Enter` /
`Viewport Exit` · `Load` (with *Time Delay*)

**Effects:** Toggle Visibility / Show / Hide Element · Toggle/Add/Remove Preset ·
Toggle/Add/Remove Attribute · Toggle/Add/Remove Cookie · **Scroll to Element** ·
**Mirror Mouse Movement** (translate, scale, opacity, tilt, rotate, with
sensitivity)

**Target:** itself **or another** module, row or section.

> This is the mechanism for **one element revealing another** — something the
> Animation group, bound to its own element, cannot do.

---

## 5. Sticky

**Path:** `module.decoration.sticky` — ✓ SOURCE
(`ScrollSettingsPresetAttrsMap.php:37` calls
`StickyPresetAttrsMap::get_map('module.decoration.sticky')`; also listed in
`GlobalPresetItemGroupAttrNameResolver.php:45`).

### Keys — ✓ SOURCE (`ContactFieldPresetAttrsMap.php:54-60`)

| Key | Purpose |
|---|---|
| `position` | where it sticks — JSON `"top"` · `"bottom"` · `"topBottom"` (UI: Top, Bottom, Top and Bottom). ✓ SOURCE `StickyUtils.php` valid positions; ✓ RENDER 5.16.0: `"top"` → `et_pb_sticky--top`, held at top 0 |
| `offset.top` / `offset.bottom` | distance kept from the edge |
| `offset.surrounding` | respect other sticky elements |
| `limit.top` / `limit.bottom` | **sticky boundaries** — the range where it applies |
| `transition` | transition from normal style to sticky style |

📖 DOCS — *Sticky Position* appears in the UI **inside the Scroll Effects
group**, even though it is its own group in JSON.

Two documented behaviours worth noting:

- **Sticky state styling** — once sticky is enabled, *every* design option gains
  a `sticky` state and the element transitions from its normal style to the
  sticky one. This is the same `sticky` from §1b (sibling of `value` and `hover`
  inside the breakpoint): enabling the feature is what gives the style state
  meaning.
- **Sticky boundaries** — `limit.*` confines stickiness to a range (e.g. the
  parent section), releasing the element on exit.

---

## 5b. The two other motion groups

Both ✓ SOURCE.

### `module.decoration.transition` — state transition

`ModuleElements.php:2573`, `TransitionUtils.php:652`. Smooths the change into
the `hover` and `sticky` states (§1b) — **not** an entrance animation.

Keys: `duration` · `delay` · `speedCurve`
(confirmed in `SliderPresetAttrsMap.php:2751+`). Without it, `hover` snaps.

### `module.decoration.transform` — static displacement

`RowPresetAttrsMap.php` — five keys: `translate`, `scale`, `rotate`, `skew`,
`origin`.

> ⚠️ **Careful when combining with Scroll Effects.** Both travel together to the
> script (§3) and write to the **same CSS `transform`**. The `AnimationUtils`
> docblock mentions *"detect transform+animation endpoint parity"*, so there is
> explicit reconciliation in the code. Enabling all three (transform + scroll +
> animation) at once is untested territory.
>
> See also the centred `transform-origin` trap in `DIVI5-STYLING.md` §7d.

---

## 6. There is no native marquee

Researched against the hypothesis of a continuously scrolling logo strip:

- ✓ SOURCE — grepping `marquee|infinite|autoplay` across `Options/Scroll/`,
  `Options/Animation/` and `Options/Interactions/` returns no such feature (only
  code comments about recursion).
- ✓ SOURCE — the **`divi/group-carousel`** module exists in 5.12.1
  (`ModuleLibrary/GroupCarousel/`, 90 modules total). Its options: `auto`
  (autoplay), `speed`, `pauseOnHover`, `slidesToShow`, `slidesToScroll`,
  `showArrows`, `showDots`, `arrowPosition`, `arrowType`, `dotPosition`,
  `dotAlignment`, `centerMode`. There is no `autoplay` key in it — in the scope
  searched that name appears only in
  `Options/Background/BackgroundComponentVideo.php`.
- 📖 DOCS — in the comments on the official Group Carousel announcement, Elegant
  Themes reply that a **marquee mode is not a built-in feature**, only a request.

**Conclusion:** a discrete-step carousel with autoplay is native; seamless
continuous scrolling is **not**. `repeat: loop` (§2) does not solve it either —
it restarts each cycle.

---

## 7. Import trap — animation inert after programmatic import

⚠️ INHERITED (`KNOWN-CAVEATS.md` §43).

Divi caches each page's module list in the `_divi_dynamic_assets_cached_modules`
post meta to decide which JS bundles to enqueue. If a script-dependent feature
(entrance animation, scroll effect, sticky, slider, TOC) is added to a page whose
cache **predates** it, the script never enqueues: the JSON is correct and
**nothing happens on screen**.

```bash
wp post meta delete <post_id> _divi_dynamic_assets_cached_modules
# and clear wp-content/et-cache/
```

Applies to any programmatic import (REST or portability) that adds animation to
a page that previously had none. Divi rebuilds the cache on the next load.

---

## 7b. Accessibility — Divi does **not** honour `prefers-reduced-motion`

✓ SOURCE — `grep -rl "prefers-reduced-motion"` across all of `includes/builder-5/`
returns **only three files, none in the frontend render path**:

| File | What it is |
|---|---|
| `visual-builder/build/ai-agent.css` | builder AI-agent UI |
| `visual-builder/build/ai-agent.js` | same |
| `visual-builder-dependencies/wordpress/compose.min.js` | WordPress dependency |

Visitors with "reduce motion" enabled at the OS level **still see** entrance
animations and scroll effects. There is no native option to suppress them — Divi
neither exposes a control nor honours the media query.

---

## 8. Coverage

### ✓ Confirmed in source (5.12.1)

| Item | Where |
|---|---|
| `<element>.decoration.animation`, incl. sub-elements | §2 |
| All 8 animation keys + defaults | §2 |
| `direction` appended to `style`; `fade` takes none | §2 |
| `intensity` as a per-style object | §2 |
| Animation on **Row** (12 preset keys) | §2 |
| `module.decoration.scroll` + 6 effects | §3 |
| `viewport` / `offset` shape, defaults, key inversion | §3 |
| `module.decoration.interactions` | §4 |
| `module.decoration.sticky` + 7 keys | §5 |
| `module.decoration.transition` / `.transform` | §5b |
| No native marquee | §6 |
| `prefers-reduced-motion` not honoured | §7b |

### ✓ Render-confirmed on Divi 5.16.0 (before merging, 21 Oct 2026)

Each against a plain text module on the same page that did not move:

- **§2 reveal recipe** (`slide` + `bottom`, `startingOpacity 0%`): the module starts `et_animated` at opacity 0
  and reaches opacity 1 (`et_had_animation`) once scrolled into view.
- **§3 `verticalMotion`** with the default viewport/offset: `translateY` 400 → 151 → −254 → −400px as the page
  scrolls. The viewport-key inversion (§3) is still in `ScrollEffectsUtils.php` on 5.16.0.
- **§5 sticky** `position: "top"`: `et_pb_sticky et_pb_sticky--top`, held at top 0 while the page scrolled on.
- `prefers-reduced-motion`: still the same three non-front-end files on 5.16.0; `gridMotion` still commented out.
- **§4 Interactions**: the array schema is in MODULES-INTERACTIVE "Interactions"; a timeline item as a click
  trigger rendered on 5.16.0 (MODULES-CONTENT, timeline).

### ❓ Open — all require a render test

1. Are Section and Column **preset-able** for `animation`? Docs say both animate,
   but neither lists the key in a preset map. Use **Row** for block-level
   animation (§2).
2. Internal array schema of Interactions on 5.12.1 (§4).
3. Does `repeat: loop` survive a programmatic import once the asset cache is
   cleared (§7)?
4. How `scroll` + `transform` + `animation` reconcile when enabled together —
   they share one CSS `transform` (§5b).
5. What the `FeaturesManager::get('anim')` feature flag is, and when it is off
   (§2).

---

## Sources

**Developer docs** (`dev.elegantthemes.com`) — where the schema lives; the Help
Center only describes the UI:

- [Attribute Format](https://dev.elegantthemes.com/docs/explanations/module/attribute-format/) — canonical spec, basis of §1b
- [Default Module Attributes](https://dev.elegantthemes.com/docs/explanations/module/default-module-attributes/) — `default` vs `defaultPrintedStyle`
- [Module Metadata](https://dev.elegantthemes.com/docs/explanations/module/module-metadata/introduction/) — `module.json` structure
- [Anatomy of Module](https://dev.elegantthemes.com/docs/explanations/module/anatomy-of-module/) — architectural (a module is a Gutenberg block)

> ⚠️ Both `dev.elegantthemes.com` and `help.elegantthemes.com` are JS-rendered
> SPAs — `WebFetch` returns only the navigation shell. Read them through a
> browser. The *Introducing Divi 5* category does **not** cover animation; it is
> conceptual (terminology, principles, release phases).

**Help Center:**

- [Animation Option Group in Divi 5](https://help.elegantthemes.com/en/articles/10102631-understanding-the-animation-option-group-in-divi-5)
- [Scroll Effects Option Group in Divi 5](https://help.elegantthemes.com/en/articles/10102792-understanding-the-scroll-effects-option-group-in-divi-5)
- [Divi Sticky Options](https://help.elegantthemes.com/en/articles/4474319-divi-sticky-options)

**Blog:**

- [Advanced Animations Options For All Divi Modules, Rows and Sections](https://www.elegantthemes.com/blog/theme-releases/divi-feature-update-introducing-advanced-animations-options-for-all-divi-modules-rows-and-sections)
- [Everything You Need To Know About Divi 5 Interactions](https://www.elegantthemes.com/blog/divi-resources/everything-you-need-to-know-about-divi-5-interactions)
- [How To Create Interactive Layouts On Scroll With Divi 5](https://www.elegantthemes.com/blog/divi-resources/how-to-create-interactive-layouts-on-scroll-with-divi-5)
- [New Group Carousel Module, Lottie Module And More!](https://www.elegantthemes.com/blog/theme-releases/group-carousel-lottie-icon-list)

**Source:** `wp-content/themes/Divi/includes/builder-5/server/Packages/`

---

*DIVI5 Animation Skill — V0.7.1 | Builder Version 5.16.0 | contributed by @spetrum*
