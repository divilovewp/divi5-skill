---
name: divi5-modules-media
description: Confirmed JSON structures for Divi 5 media modules — video, gallery (grid only), slider, video-slider, before-after-image, audio, and lottie.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Media Modules
> **Part of the DIVI5 skill set. Attach when using video, gallery, slider, lottie, audio, or before-after image.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA (this) · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS

> **5.6.2 notes:** `divi/svg` (inline SVG) is documented in MODULES-CONTENT. All image-bearing media modules now support **aspect-ratio** (`sizing.aspectRatio`) and **framing** (`<imageElement>.decoration.fit` → object-fit/position) — see STYLING §3/§3b. Gallery/grid layouts use the full **Grid layout** system in LAYOUT §5b.

---

## `divi/video`

Embeds a video. **Self-closing.** Confirmed working.

```json
{
  "video": {
    "innerContent": {
      "desktop": {"value": {"src": "https://www.youtube.com/watch?v=XXXXX"}}
    }
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed:** YouTube URLs in `video.innerContent.desktop.value.src` render as a full embedded player with thumbnail and play button. Constrain to `max_width: '900px'` row for good proportions.

---

## `divi/gallery`

Image gallery grid. **Self-closing.**

```json
{
  "galleryGrid": {
    "decoration": {
      "layout": {
        "desktop":   {"value": {"gridColumnCount": "3"}},
        "tablet":    {"value": {"gridColumnCount": "2"}},
        "phone":     {"value": {"gridColumnCount": "1"}}
      }
    }
  },
  "image": {"advanced": {"galleryIds": {"desktop": {"value": [37, 38, 39, 40, 41, 42]}}}},
  "builderVersion": "5.11.1"
}
```

**Gallery images ARE buildable in JSON — pass WP media-library attachment IDs** via `image.advanced.galleryIds` (an int array), **not** image URLs. Embedding a URL/`src` (or passing `innerContent.desktop.value` as an array) crashes WordPress with a 500 (`ltrim(): array given`); the **id-array form is the supported path** — confirmed against the Divi 5.9.0 `GalleryModule` source (the ids go straight into `get_posts(post_type=attachment, include=…)`). Seed the media library first (`wp media import <url> --porcelain` prints the id). Render-confirmed on 5.9.0: a 3-column grid of 6 photos with pagination. The `galleryGrid` column-count settings above are safe to include.

---

## `divi/slider` + `divi/slide`

`slider` is **NOT self-closing**. `slide` **IS self-closing**. Confirmed working.

```json
// slider (parent — container):
{
  "builderVersion": "5.11.1"
}

// slide (child — self-closing):
{
  "title": {
    "innerContent": {"desktop": {"value": "Slide Heading"}},
    "decoration": {"font": {"font": {"desktop": {"value": {
      "headingLevel": "h2", "size": "3rem", "weight": "800",
      "color": "#FFFFFF", "textAlign": "center"
    }}}}}
  },
  "content": {
    "innerContent": {"desktop": {"value": "<p>Slide body text.</p>"}},
    "decoration": {"bodyFont": {"body": {"font": {"desktop": {"value": {
      "color": "rgba(255,255,255,0.85)", "size": "18px", "textAlign": "center"
    }}}}}}
  },
  "button": {
    "innerContent": {"desktop": {"value": {"text": "Learn More", "linkUrl": "#", "linkTarget": "off"}}}
  },
  "module": {
    "decoration": {
      "background": {"desktop": {"value": {"color": "#0f172a"}}},
      "spacing": {"desktop": {"value": {"padding": {
        "top": "100px", "bottom": "100px", "left": "40px", "right": "40px"
      }}}}
    }
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed:** First slide is active on page load. Navigation dots render automatically. `module.decoration.background.color` sets per-slide background. Remove section padding (`0px` all sides) to let the slider be full-width.

**⚠️ Slides stacked vertically with dead navigation?** Divi 5 caches the page's module list in the `_divi_dynamic_assets_cached_modules` post meta to decide which JS bundles to enqueue. If the slider is added to a page that was previously saved/imported **without** one, the stale cache omits `divi/slider`, the slider script never loads, and all slides render stacked with no cycling and no working arrows/dots — even though the JSON is correct. Fix: `wp post meta delete <post_id> _divi_dynamic_assets_cached_modules` (and clear `wp-content/et-cache/`), then reload — Divi re-scans the content and writes a fresh cache. The same stale-cache class affects entrance animations, scroll effects, sticky, and table-of-contents. Tested on Divi 5.7.0 → 5.8.1, portability-imported pages.

---

## `divi/video-slider` + `divi/video-slider-item`

`video-slider` is **NOT self-closing**. Item **IS self-closing**. **Real-render confirmed.**

**Rendered UI:** Unlike `divi/slider` (text slides), video-slider renders a main video area (YouTube thumbnail + play button) with a film-strip thumbnail row below showing all items. Navigation works via the thumbnail strip.

```json
// video-slider (parent — minimal attrs):
{
  "builderVersion": "5.11.1"
}

// video-slider-item (child — self-closing):
{
  "video": {
    "innerContent": {"desktop": {"value": {"src": "https://www.youtube.com/watch?v=XXXXX"}}}
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed:** YouTube URLs in `video.innerContent.desktop.value.src` render with thumbnail and play button. Film-strip thumbnails auto-generated for each item.

**`title` and `description` fields on `video-slider-item`:** Setting these fields does not cause errors, but they are not displayed in the rendered video-slider UI — the module only shows the video player and thumbnails. Do not rely on these fields for visible text.

---

## `divi/lottie`

Lottie animation. **Self-closing.** Format confirmed — URL reliability is the variable.

```json
{
  "lottie": {
    "innerContent": {"desktop": {"value": {"src": "https://example.com/animation.json"}}}
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed:** `lottie.innerContent.desktop.value.src` = object with `src` key pointing to a `.json` Lottie animation URL. When the URL resolves and returns valid Lottie JSON, the animation renders.

**When URL fails:** Module renders "Failed to load animation" placeholder text — no crash, just an empty state.

**URL reliability:** LottieFiles CDN URLs (assets10.lottiefiles.com, assets-v2.lottiefiles.com) can expire. Use self-hosted or stable CDN URLs for production. Test the URL in a browser first.

**`loop` and `autoplay` fields:** `loop.innerContent.desktop.value: "on"` and `autoplay.innerContent.desktop.value: "on"` do not cause errors. Static screenshots can't confirm their effect — assume they work as expected.

---

## `divi/audio`

Audio player. **Self-closing.** Confirmed working including audio src.

```json
{
  "artistName": {"innerContent": {"desktop": {"value": "Divi Podcast"}}},
  "title":      {"innerContent": {"desktop": {"value": "Episode 1: Building with Divi 5"}}},
  "audio": {
    "innerContent": {"desktop": {"value": "https://example.com/track.mp3"}}
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed:** `audio.innerContent.desktop.value` = **plain string URL** (MP3 or other audio format). Do NOT use an object — `{"src": "..."}` crashes WordPress with a 500 error (`ltrim(): array given` in AudioModule.php via `esc_url`).

**Renders:** Styled blue player block with track title, artist byline, progress bar, play/pause button, and volume control.

---

## `divi/before-after-image`

Before/after comparison slider. **Self-closing.** Confirmed working.

```json
{
  "beforeImage": {
    "innerContent": {"desktop": {"value": {"src": "https://example.com/before.jpg"}}}
  },
  "afterImage": {
    "innerContent": {"desktop": {"value": {"src": "https://example.com/after.jpg"}}}
  },
  "module": {
    "decoration": {
      "border": {"desktop": {"value": {"radius": {
        "topLeft": "12px", "topRight": "12px",
        "bottomLeft": "12px", "bottomRight": "12px", "sync": "on"
      }}}}
    }
  },
  "builderVersion": "5.11.1"
}
```

**Confirmed:** Both `src` fields accept external URLs. Renders with a centered drag handle between the two images. Constrain to `max_width: '1000px'` for best proportions.

---

## `divi/imagely-gallery` (NEW in 5.11.0 — ✓ render-confirmed on Divi 5.11.1)

Renders a **NextGEN Gallery (Imagely)** gallery with Divi styling controls. The gallery is
created in NextGEN and selected here by ID. **Self-closing.**

```json
{
  "imagelyGallery": {"innerContent": {"desktop": {"value": {"galleryId": "1"}}}},
  "builderVersion": "5.11.1"
}
```

| Field | Path | Notes |
|-------|------|-------|
| Gallery | `imagelyGallery.innerContent.{bp}.value.galleryId` | the NextGEN gallery ID (string) |

🪤 **The key is `galleryId`, even though Divi's own field is registered under the name `item`.**
Reading the module definition and copying the field name gives you `item`, which stores
cleanly and selects nothing. Use the `subName` — `galleryId` — which is what the value is
actually keyed on.

🎨 Styling elements it exposes: `image` · `title` · `description` · `counter` · `pagination` ·
`navigationArrows` · `tagCloud` · `exifMetaData` · `slideshowLink`.

⚠️ **Requires NextGEN Gallery.** Without it the module saves, the page returns 200, and no
gallery appears — check the rendered output rather than the response.

⛔ **Do not reach for this as a general gallery.** For images you manage in the WordPress media
library, `divi/gallery` is the native module and needs no plugin.

> Render-confirmed on Divi **5.11.1**: the `et_pb_imagely_gallery` wrapper rendered on a page
> whose control `divi/text` also rendered. Gallery *contents* come from the plugin and were
> not asserted — there was no NextGEN install to assert against.

---

*DIVI5 Media Modules Skill — V0.6.9 | Builder Version 5.11.1 | Created by Shashank Gupta @ divilove.com*
