# DIVI5 Skill Files

Modular skill files for generating Divi 5 page layouts via JSON.

## Files

| File | When to attach |
|------|---------------|
| `DIVI5-BASE.md` | **Always** — core rules, nesting, common mistakes, validation |
| `DIVI5-LAYOUT.md` | Building page structure (section/row/column/group) |
| `DIVI5-STYLING.md` | Styling any module (backgrounds, spacing, border, typography, variables) |
| `DIVI5-MODULES-CONTENT.md` | heading, text, button, image, blurb, CTA, testimonial, team-member, link, icon, divider, code |
| `DIVI5-MODULES-INTERACTIVE.md` | accordion, toggle, tabs, contact-form, signup |
| `DIVI5-MODULES-MEDIA.md` | video, gallery, slider, video-slider, lottie, audio, before-after-image |
| `DIVI5-MODULES-DATA.md` | counters, pricing tables, social, dynamic WP, misc |
| `DIVI5-WORDPRESS.md` | Creating pages programmatically via REST API |
| `DIVI5-PATTERNS.md` | Real-world layout patterns + Python generation helpers |

## Typical combinations

**Build a landing page (full):**
BASE + LAYOUT + STYLING + MODULES-CONTENT + PATTERNS

**Build and import via REST API:**
BASE + LAYOUT + STYLING + MODULES-CONTENT + WORDPRESS + PATTERNS

**Add interactive sections:**
+ MODULES-INTERACTIVE

**Add media/video sections:**
+ MODULES-MEDIA

**Add pricing or counters:**
+ MODULES-DATA

## Version
V0.3.0 — Migrated from monolithic DIVI5-SKILL-V2.md
Self-improvement loop: iteration 1 discoveries included in DIVI5-WORDPRESS.md
