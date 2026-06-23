---
name: divi5-modules-media
description: Confirmed JSON structures for Divi 5 media modules — video, gallery (grid only), slider, video-slider, before-after-image, audio, and lottie.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Media Modules
> **Part of the DIVI5 skill set. Attach when using video, gallery, slider, lottie, audio, or before-after image.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA (this) · MODULES-DATA · WORDPRESS · PATTERNS

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
  "builderVersion": "5.1.0"
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
        "phoneWide": {"value": {"gridColumnCount": "2"}},
        "phone":     {"value": {"gridColumnCount": "1"}}
      }
    }
  },
  "builderVersion": "5.1.0"
}
```

**⚠️ Gallery images cannot be passed via JSON markup.** Passing `innerContent.desktop.value` as an array crashes WordPress with a 500 error (`ltrim(): array given`). Gallery images must be added via the Divi editor UI (WP media library IDs). The `galleryGrid` column count settings work and are safe to include.

---

## `divi/slider` + `divi/slide`

`slider` is **NOT self-closing**. `slide` **IS self-closing**. Confirmed working.

```json
// slider (parent — container):
{
  "builderVersion": "5.1.0"
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
    "innerContent": {"desktop": {"value": "\u003cp\u003eSlide body text.\u003c/p\u003e"}},
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
  "builderVersion": "5.1.0"
}
```

**Confirmed:** First slide is active on page load. Navigation dots render automatically. `module.decoration.background.color` sets per-slide background. Remove section padding (`0px` all sides) to let the slider be full-width.

---

## `divi/video-slider` + `divi/video-slider-item`

`video-slider` is **NOT self-closing**. Item **IS self-closing**. **Real-render confirmed.**

**Rendered UI:** Unlike `divi/slider` (text slides), video-slider renders a main video area (YouTube thumbnail + play button) with a film-strip thumbnail row below showing all items. Navigation works via the thumbnail strip.

```json
// video-slider (parent — minimal attrs):
{
  "builderVersion": "5.1.0"
}

// video-slider-item (child — self-closing):
{
  "video": {
    "innerContent": {"desktop": {"value": {"src": "https://www.youtube.com/watch?v=XXXXX"}}}
  },
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
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
  "builderVersion": "5.1.0"
}
```

**Confirmed:** Both `src` fields accept external URLs. Renders with a centered drag handle between the two images. Constrain to `max_width: '1000px'` for best proportions.

---

*DIVI5 Media Modules Skill — V0.3.0 | Builder Version 5.1.0 | Created by Shashank Gupta @ divilove.com*
