---
name: divi5-design-process
description: The reasoning/planning methodology for building Divi 5 pages. Read this FIRST. Ask the user focused discovery questions, then produce a written Page Plan before generating any JSON. Teaches how to think like a designer — discovery/intake, intent, narrative, information architecture, nesting strategy, module selection, design system, responsive plan, and self-critique.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Design Thinking & Planning Process
> **Part of the DIVI5 skill set. Always attach this with BASE.** Work through it BEFORE writing markup.
> Skill files: BASE · **DESIGN-PROCESS (this)** · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS · COVERAGE

---

<!-- dc:standalone-only -->
## 0. Connection Mode — Ask This First (Before Anything Else)

Before discovery questions or planning, ask the user which output mode they want. Ask it as a single short question:

> **"Would you like to connect to a live WordPress site and create the page there directly, or just get the Divi 5 markup to import yourself?"**

**Wait for their answer.** Then branch:

### A — Live site (Divi Connect plugin)
Ask for connection info in one message:
> "Please share your Divi Connect details:
> 1. Site URL (e.g. https://mysite.com)
> 2. API key (from WP Admin → Settings → Divi Connect, or call GET /wp-json/divi-connect/v1/key with your WP credentials)"

Once you have those, follow the **DIVI5-CONNECT** workflow:
- Call `GET {siteUrl}/wp-json/divi-connect/v1/design-system` first — this returns the site's real colors, variables, and presets
- Use the returned tokens (not hardcoded hex values) in the page markup
- **Run the Variable-availability gate (below)** before building
- Call `POST {siteUrl}/wp-json/divi-connect/v1/pages` to create the page live
- Report back the live URL

#### Variable-availability gate (run after `/design-system`)
Tokens are the default (BASE rule 15; STYLING §10b), **but only if the site has them.** Inspect the buckets `/design-system` returned:
- **Tokens exist for what you need →** build with them (never invent token names).
- **A needed bucket is empty/missing (no colors, no size/spacing/font variables) → ASK the user, then wait:**
  > "This site has no [colors / size / spacing] variables defined yet. Want me to **generate a variable system** (recommended — keeps the design editable and fluid), or **build with inline numeric values**?"
  - **Generate →** `POST /colors` (for `gcid-*`) and/or `POST /variables` (for `gvid-*` sizes/spacing/fonts/gradients), then build with the new tokens.
  - **Inline →** build with literal values. This is an accepted, consistent path — *not* a defect; the self-audit won't flag literals when the user opted out.
- **Free/Pro:** size-variable *generation* is Pro-gated and the free tier bakes size tokens to literal regardless. On free / a `402`, say so and fall back to inline for **sizes** (colors + gradients still generate on free). See DIVI5-CONNECT.

> In **mode B (JSON only)** there's no site to query: ask the user whether the target site already defines `gcid-*`/`gvid-*` tokens (use them) or whether to include `global_colors`/`global_variables` definitions in the export vs inline literals.

### B — JSON only
Generate Divi 5 markup as a code block. The user imports it via Divi → Import & Export, or runs it through the REST API manually. No connection needed.

> If the user says "just go" without answering, default to **B (JSON only)**.

---
<!-- /dc:standalone-only -->

## 0b. The One Rule — Plan Before You Build

**Never emit JSON first.** A correct-but-thoughtless page is the #1 failure mode: valid markup that looks generic, has weak hierarchy, arbitrary nesting, and mismatched modules. **And never plan on guesses when a couple of questions would make the page right** — ask first.

**Output contract — every page request runs in this order:**

0. **Setup** — read the site's design system first so you build on real tokens (Divi Connect connector: `divi_get_design_system`; raw REST / standalone: `GET /design-system`).
1. **`## Discovery`** — ask the user a focused set of relevant questions, then **wait for answers** before planning (see Phase 0b). Skip only if the brief already answers them or the user says "just go."
2. `## Page Plan` — the written blueprint (Phases 1–7 below, kept concise), built from the answers.
3. `## Self-Critique` — a quick pass against the rubric (§11); revise the plan if needed.
4. **▸ APPROVAL GATE** — present the plan and **explicitly ask the user to approve or adjust it. STOP here. Do NOT generate markup or call `divi_create_page` / `POST /pages` until the user approves.** If they request changes, revise the plan and ask again.
5. `## Markup` — *only after approval*, generate the Divi 5 markup from the finalized plan. In mode A, then call POST /pages and return the live URL.

> The approval gate is mandatory. The single exception: the user explicitly says "just build it / just go" — then proceed with **stated assumptions** (still show a 2-line plan first).

The discovery + plan is the thinking. The JSON is just transcription. The quality comes from the plan, not the markup.

> Sequence: **ask → plan top-down (page → sections → modules → styling) → build bottom-up.**

---

## 0c. Phase 0 — Discovery (ASK before planning)

**Ask the user a focused set of relevant questions, then wait for the answers.** A page built on the user's real intent beats one built on assumptions. But respect their time — a tight, tailored intake, not an interrogation.

### How to ask (rules)
- **Skip what's already known.** Only ask what the brief didn't already answer. If the user gave colors, don't ask for colors.
- **Tailor to the page type.** Detect the page type from the request and ask the questions that actually change *that* page (a product page needs price/images; a contact page needs form fields/map).
- **Batch into one message**, numbered, so the user answers in a single reply. Don't drip questions one at a time.
- **Cap it:** ~4–6 questions for a normal page; up to ~8 for a complex one. Lead with the highest-impact ones.
- **Offer defaults.** For each question, suggest a sensible default ("if unsure, I'll assume X") so the user can answer "all defaults / just go."
- **Don't block forever.** If the user says "just go", doesn't answer, or it's a trivial request, proceed with documented assumptions (state them in the plan).
- If the runtime offers a structured question UI (multiple-choice prompts), use it; otherwise ask in plain numbered text.

### Core question bank (pick the relevant ones)
1. **Goal & primary CTA** — what's the ONE action this page should drive, and what should the main button say + link to?
2. **Audience & tone** — who's it for, and what vibe (corporate / playful / premium / minimal / technical)?
3. **Brand** — brand colors (hex) and fonts? Logo? (Default: a clean neutral palette + one accent, system/Inter fonts.)
4. **Content** — do you have copy and images, or should I write realistic placeholder copy and use stock/placeholder images?
5. **Must-have sections** — anything that must be on the page (or must NOT be)?
6. **Reference** — any site/page whose style you want to echo?
7. **Scope/context** — single page or a Theme Builder template? Page length (concise vs comprehensive)?

### Page-type add-ons (ask only the fitting ones)
- **Product:** product name, price, key features, # of gallery images, reviews? buy vs inquire?
- **Pricing:** how many tiers, names/prices, billing toggle (monthly/annual), highlighted plan?
- **Portfolio:** how many projects, categories/filters, case-study detail or grid only?
- **Contact:** which form fields, show a map (needs Maps API key), office info/hours?
- **About/Service:** team members? process steps/timeline? stats to highlight?
- **Blog/dynamic:** pull real WordPress posts (Loop Builder) or static cards? how many?

After answers arrive (or are waived), write the **Page Plan**.

> In mode A (live site): if the `/design-system` call returned colors or presets, reference them in the plan by name ("use the site's brand-navy color", "apply the dark-heading preset"). Don't invent new hex values for things the site already defines.

---

## 1. Phase 1 — Intent (lock it from the answers)

Distill the discovery answers (or stated assumptions) into the brief that drives the design:

- **Page type** — landing, product, pricing, about, services, portfolio, blog index, contact, home. This drives everything.
- **Primary goal** — the ONE action (sign up, buy, book, contact, read). Everything serves it.
- **Primary CTA** — exact button text + destination. Appears in the hero and again near the end.
- **Audience & tone** — who reads this, and the voice.
- **Content inventory** — real content/assets vs placeholder. If placeholder, write believable copy (never "Lorem ipsum" for headings/CTAs). **Verbatim-copy rule:** when the user supplies copy OR a reference/source page, **transcribe it EXACTLY — never paraphrase, reword, or "improve" it.** LLMs tend to rewrite text near a reference; resist it. Generate fresh wording *only* for genuinely missing copy. Before deploy, diff your on-page text against the source (self-audit §9).
- **Constraints** — brand colors/fonts, required sections, length, page vs Theme Builder.

Write 3–6 lines. A hero for a SaaS trial differs completely from a hero for a law firm.

---

## 2. Phase 2 — Narrative & Information Architecture

A good page is a **story that leads to the CTA**, not a pile of sections. Choose the section sequence deliberately.

### Persuasion arc (default for marketing pages)
`Hook (hero) → Problem/empathy → Solution/value → Proof (social/stats/testimonials) → Details (features/how-it-works) → Objection handling (FAQ/pricing) → Final CTA`

### Page archetype → recommended section sequence

| Page type | Section sequence |
|-----------|------------------|
| **SaaS / app landing** | Hero (value + CTA) → Logos/social proof → Problem → Features (3-up) → How it works → Testimonials → Pricing → FAQ → Final CTA |
| **Product (physical)** | Hero (image + buy) → Highlights → Gallery → Benefits → Specs/details → Reviews → Related → CTA |
| **Service / agency** | Hero → Services (cards) → Process (steps/timeline) → Portfolio/case studies → Team → Testimonials → Contact CTA |
| **About** | Hero/mission → Story (timeline) → Values → Team → Stats → CTA |
| **Pricing** | Hero (headline) → Pricing tables → Feature comparison → FAQ → CTA |
| **Portfolio** | Hero → Filterable portfolio/grid → Selected work → About blurb → Contact CTA |
| **Contact** | Hero → Contact form + info (2-col) → Map → FAQ |

### Rhythm rules
- **5–9 sections** for most pages. If you have more, you're probably over-explaining.
- **Alternate section backgrounds** (light / dark / tint) to create visual rhythm and separate ideas.
- **One idea per section.** If a section does two jobs, split it.
- **Vary layouts** — don't stack five identical 3-column rows. Mix full-width, split, grid, centered.
- The **hero and the final CTA are the two most important sections** — give them the most design attention.

---

## 3. Phase 3 — Section-by-Section Blueprint

For **each** section, decide and write a one-liner (see template in §12):

```
S<n> [Purpose] — Layout: <cols/grid> | Modules: <...> | BG: <color/image> | Notes: <hierarchy/spacing>
```

Decide per section:
- **Purpose** (one sentence — what job it does in the narrative).
- **Layout** — column count + widths, or grid (and column count per breakpoint). Centered vs split vs full-bleed.
- **Modules** — the specific Divi modules (Phase 5 reasoning).
- **Background** — solid / tint / dark / image+overlay. Maintain the alternating rhythm.
- **Hierarchy** — what's the biggest element, what draws the eye, where the CTA sits.

A blueprint is "done" when someone could build the page from it without further decisions.

---

## 4. Phase 4 — Nesting & Structure Strategy

Keep the tree **as shallow as the design allows**. Every extra level is more markup to get right and more responsive edge-cases.

**Canonical hierarchy:** `Section → Row → Column → Module`. Add `Group` / nested `Row` only when they earn it.

### Decision: how to build a "card"
- **Column-as-card** (style the `column`: bg, radius, padding) — when the whole column *is* one card and contains a few simple modules. Simplest; default.
- **Group-as-card** (`divi/group` with bg/border/padding) — when you need **multiple cards per column**, a card inside a carousel, or a self-contained component you'll repeat (incl. **Loop Builder** items). Use a group when the card must travel as a unit.
- **Nested row** — only when a card needs its own multi-column internal layout (e.g., icon column + text column inside a card).

### Decision: grid vs flex for multi-item layouts
- **Flex row** (`flexColumnStructure` + columns) — linear, content-driven layouts that should stack 1-per-row on mobile. Default for 2–4 feature columns.
- **CSS Grid** (`layout.display:"grid"`, see LAYOUT §5b) — uniform tiles, galleries, mosaics, large card sets, or when items must span tracks. **Set responsive `gridColumnCount`** (grid does NOT auto-stack).
- Rule of thumb: ≤4 equal columns of mixed content → flex; many uniform tiles or a true grid → grid.

### Anti-patterns
- Module placed directly in a section or row (always Section→Row→Column→Module).
- Group wrapping a single module for no styling reason.
- Deeply nested rows when a single grid would do.
- A 1-column row used where the section could hold the row directly — fine, but don't add empty wrappers.

---

## 5. Phase 5 — Module Selection (pick the *best* match, not the first)

Reason about trade-offs. The skill's module table (PATTERNS §2 step 2) lists options; here's *how to choose*:

| Need | Best match | Why / vs alternatives |
|------|-----------|-----------------------|
| Icon + title + short text card | `divi/blurb` | Purpose-built; don't hand-assemble icon+heading+text |
| Title + body + button as one promo | `divi/cta` | One styled unit; use over assembling heading+text+button when it's a single message |
| Heading/body/button you need to lay out individually | separate `heading`/`text`/`button` | When you need independent placement/styling |
| Big animated number | `divi/number-counter` (or `circle-counter` for %) | Don't fake with text; counters draw the eye to proof |
| Expandable Q&A (many) | `divi/accordion` (one open at a time) | Use `toggle` for a single standalone collapsible |
| Switch between content panels | `divi/tabs` | Horizontal switching; vs accordion (vertical, all visible) |
| Quote + person | `divi/testimonial` | Built-in portrait + attribution |
| Chronology / steps with dates | `divi/timeline` | vs blurbs-in-a-row when order/time matters |
| Repeating real WP content | **Loop Builder** on a `group` (MODULES-DYNAMIC) | vs hardcoding cards; use for blogs/products/projects |
| Pricing | `pricing-tables` (one table per column for mobile stacking) | |
| Logos/inline SVG | `divi/svg` or `image` | SVG for crisp icons/logos |

**Heuristics:**
- Prefer **one purpose-built module** over hand-assembling 3 generic ones (blurb > icon+heading+text).
- If content is **real WordPress data that repeats**, reach for the **Loop Builder**, not hardcoded copies.
- Match the module to the *meaning*: stats → counters, steps → timeline, proof → testimonials.
- Check **COVERAGE** before using anything exotic — avoid ⚠️/❌ items (e.g., TOC needs a Theme Builder + builder-UI save).

---

## 5b. Bespoke designs → REAL modules (NOT `divi/code` + a stylesheet)

When a reference design is custom HTML/CSS, the tempting shortcut is one `divi/code`
block + a shared `<style>` sheet. **Don't.** It breaks the product promise, isn't
editable in the builder, and collapses if the chrome/stylesheet is ever stripped.
**`divi/code` is last-resort only** — genuine custom **SVG art** or a third-party
embed. Everything visual maps to a real module. (BASE rule 14; self-audit §9.)

### Decision: real module vs `divi/code`
1. Is it text, a heading, a list, a number, an icon, a quote, a button/link, a card,
   a form, a media item? → **a real module exists — use it** (table in §5).
2. Is it a bespoke vector illustration or an external script/iframe? → `divi/svg`
   (art) or `divi/code` (embed) is legitimate.
3. Is it "arbitrary CSS I can't express with decoration"? → almost always you *can*
   (two-tone headings, badges, custom cards, dividers — see recipes). Re-check
   STYLING before reaching for code.

### Native recipes (proven on a production build — copy these instead of code)
| Bespoke thing | Native recipe |
|---------------|---------------|
| **Two-tone / italic-accent heading** (one word in another colour) | `divi/heading` is plain-text only → use a **`divi/text`** with an inline `<hN>` containing an `<em style="color:var(--gcid-accent)">` accent; base font via `font-family:var(--gvid-font-display)` |
| **Trust / feature list** (with icons) | `divi/icon-list` + `icon-list-item`; horizontal via parent `layout.flexDirection:"row"` |
| **Stat / metric** | `divi/number-counter` (keeps `+`/`%`; set `number.advanced.enablePercentSign` off/on) |
| **Icon-in-a-circle** | `divi/svg` (inline art) inside a flex `group` with a circular `border.radius` + fixed sizing |
| **Quote / testimonial card** | `divi/testimonial` (stars + quote inline-styled in `content`; author/role via their decoration font) |
| **Floating badge / sticker** | a `group` with Advanced ▸ Position `absolute` + offset; parent column `relative` w/ **top-left** origin (STYLING §7d — never center origin) |
| **CTA links / arrows** | `divi/link` (font on `content.decoration.font`) |
| **FAQ** | `divi/accordion` + `accordion-item` |
| **Timeline / steps** | `divi/timeline` + `timeline-item` |
| **Comparison matrix** | a native column grid (there is no table module) |
| **Custom card** | `divi/group` styled via `decoration` (bg/border/radius/padding/shadow) — never a `.card` class in a stylesheet |

> Two-tone headings are the one place inline HTML (inside a `divi/text`) is normal —
> because `divi/heading` is plain-text. That's still a real module, not a code block.

---

## 6. Phase 6 — Design System (define once, reuse everywhere)

Decide these **before** styling sections, so the page is consistent (consistency is what reads as "designed"):

- **Color palette (60-30-10):** dominant/background (60%), secondary/surfaces (30%), accent/CTA (10%). Pick 1 accent for CTAs and stick to it. Define as global color tokens (STYLING §10) so they're reusable.
- **Type scale:** heading sizes (h1 hero, h2 section, h3 card) + body. Use a consistent ratio (e.g., 3rem / 2rem / 1.25rem / 1rem). One heading font + one body font.
- **Spacing scale:** section padding (e.g., 80px desktop / 60 tablet / 40 phone), gaps (16/24/32). Reuse the same few values — don't invent per-section spacing.
- **Container width:** one max-width for rows (e.g., 1280px; 700–900px for text-heavy/forms).
- **Radius & shadow:** one card radius (e.g., 12–16px) and one shadow style, applied consistently.

Write the tokens in the plan; reference them in every section.

---

## 7. Phase 7 — Responsive Plan

State per-section how it adapts (don't leave it to chance):
- **Columns** stack to 1 on phone (`flexType: 24_24`, row `flexWrap: wrap`); set `phone`/`tablet` values explicitly — they don't inherit.
- **Grids** need responsive `gridColumnCount` (e.g., 3 → 2 → 1).
- **Hero** split columns often `column-reverse` on mobile (image above text or vice-versa).
- **Type** scales down on small screens; check tap targets and that nothing is white-on-white when sections restack.
- **Buttons** center per breakpoint (`module.advanced.alignment` on every breakpoint).

---

## 8. Design Principles Primer (the "why" behind the choices)

- **Visual hierarchy** — size, weight, color, and position guide the eye: hero headline > section heading > card title > body. One clear focal point per section.
- **Contrast** — make the CTA the highest-contrast element on the screen. Ensure text/background contrast passes accessibility (don't put mid-grey on white).
- **Whitespace** — generous section padding and gaps. Crowding kills perceived quality; let elements breathe.
- **Proximity** — group related items; separate unrelated ones with space, not lines.
- **Alignment** — pick a grid and stick to it; ragged alignment looks broken. Center hero/CTA; left-align body text blocks.
- **Repetition/consistency** — reuse the type scale, spacing, colors, radius. Consistency = "designed."
- **Reading patterns** — Z-pattern for hero (logo→nav→headline→CTA), F-pattern for content-heavy. Put the CTA where the eye lands.
- **Restraint** — limited palette, 2 fonts, a few spacing values. When unsure, remove.

---

## 8b. Avoid AI-design clichés (read "designed," not "AI-generated")

A page can be **valid and thoughtless at once**: correct modules, but the instantly-recognisable "AI default" look. That look — not broken markup — is the #1 reason output reads as generic. The fix isn't more decoration. It's **grounding every choice in the brief and a coherent design system**, with deliberate hierarchy and restraint.

> **Where the "design system" comes from depends on your mode (§0):**
> - **Mode A (live site / Divi Connect):** the site's **real tokens** from `/design-system` — use them, never invent token names.
> - **Mode B (JSON only):** there's no site to read, so ground in **the brand you were given** and **define a coherent token set** — reference the `gcid-*`/`gvid-*` ids the user says their site defines, or emit `global_colors`/`global_variables` definitions in the export, or (if the user opted for literals) reuse a small consistent set. Either way it's a *deliberate* system, **not** a per-element reflex.

> This is about the **ungrounded reflex**, not any one style. If the brand genuinely is warm/editorial/serif, use it — *deliberately*. The sin is reaching for a default look with no grounding in this brand.

### The tells to avoid — and what to do instead

| ❌ AI cliché | ✅ Do instead |
|---|---|
| **The "AI default" aesthetic** — cream/beige bg + a serif display (Playfair/Fraunces) + a terracotta/amber/sage accent, chosen *by reflex* | Ground in the brand + a coherent token set (Mode A: the site's real tokens; Mode B: the ids the site defines / your exported definitions / stated brand). Warm-editorial is fine *when it's the brand*, not as a fallback. |
| **Aggressive gradients** — purple→pink hero, rainbow CTAs, a gradient on every section | Solid brand colours; a gradient only if it's part of the brand, used once, with intent. |
| **Emoji as UI** — emoji in headings, as bullets, as section markers | Real `divi/icon` / `divi/svg` in a brand colour. Emoji only if the voice is explicitly playful. |
| **"Alert" cards** — every card a rounded box with a thick coloured left border | One radius + one shadow + consistent padding (§6); differentiate by hierarchy, not a left stripe. |
| **Inter / system font everywhere**, no type personality | One display + one body font on a real type scale (`font-display` / `font-body` role tokens); let type carry voice. |
| **Everything centred**, uniform section rhythm, no focal point | Deliberate hierarchy (§8) + varied layout rhythm (§2): mix full-width / split / grid; left-align body blocks. |
| **Dead interactions** — no hover/focus, or one style on every state | Define hover/focus on buttons, links and cards via decoration **states** (`:hover`); keep visible keyboard focus. Real interaction states read as "designed." |
| **Decoration as a crutch** — glassmorphism / blur / heavy shadows papering over a weak layout | Fix layout first (hierarchy, spacing, alignment); effects are seasoning, not structure. |

### The 3-brands test
Before building, ask: **"Would this look identical for a law firm, a taco truck, and a SaaS?"** If yes, it's the generic default — reground it in *this* brand's tokens, voice and content. **Restraint + grounding beats decoration.** (See §8 Restraint · §6 Design System · STYLING §10 tokens.)

---

## 9. Map the Plan to the Skill Files (where each decision is implemented)

| Plan decision | Implement via |
|---------------|---------------|
| Section/row/column/group structure, grid | LAYOUT |
| Colors, type, spacing, tokens, aspect-ratio, framing | STYLING |
| Which module + its JSON | MODULES-CONTENT / -INTERACTIVE / -MEDIA / -DATA / -DYNAMIC / -WOOCOMMERCE |
| Repeating real content | MODULES-DYNAMIC (Loop Builder) |
| Ready-made structures | PATTERNS |
| Is this module safe to use? | COVERAGE |
| Rules, nesting, gotchas | BASE |

---

## 10. Worked Mini-Example

**Brief:** "Landing page for a habit-tracking app, free trial, friendly tone."

**## Discovery** (asked; user replied "use defaults, accent indigo, I have a hero app screenshot, no pricing yet")
→ Goal/CTA: start free trial; brand: indigo accent, defaults otherwise; content: placeholder copy + their hero image; sections: skip pricing; page (not TB). With that, proceed.

**## Page Plan**
- *Intent:* SaaS landing; goal = start free trial; CTA "Start Free Trial" → /signup; audience = busy people wanting better habits; tone friendly. Brand: indigo accent, clean.
- *Narrative:* Hero → social proof logos → problem → features (3) → how it works → testimonials → final CTA.
- *Design system:* BG #ffffff / surfaces #f1f5f9 / accent #6366f1; type 3rem/2rem/1.25rem/1rem, Inter; section pad 80/60/40; container 1200px; radius 16px.
- *Blueprint:*
  - S1 Hero — split 2-col (text left + app image right) | heading+text+button, image | BG dark indigo gradient | CTA primary, biggest element. Mobile: column-reverse.
  - S2 Proof — 1-col centered caption + logo strip (grid 5→2) | image/svg | BG white.
  - S3 Problem — 1-col centered text | heading+text | BG #f1f5f9.
  - S4 Features — 3-up cards | `blurb` ×3 (group-as-card) in a flex row → 1 col mobile | BG white.
  - S5 How it works — `timeline` (3 steps) | BG #f1f5f9.
  - S6 Testimonials — 2-up `testimonial` | BG white.
  - S7 Final CTA — 1-col centered `cta` | BG indigo, high contrast button.

**## Self-Critique:** Hero CTA is the highest-contrast element ✓; backgrounds alternate ✓; 7 sections ✓; features use purpose-built blurb ✓; mobile stacking noted ✓. Ship.

**## JSON:** *(generate from the blueprint using LAYOUT/STYLING/module files)*

---

## 11. Self-Critique Rubric (run before generating JSON)

Score the plan; fix any "no":
- [ ] Does every section earn its place and serve the primary goal?
- [ ] Is there one clear focal point + the strongest contrast on the **CTA**?
- [ ] Do backgrounds/layouts alternate enough to create rhythm (not five identical rows)?
- [ ] Is the **module choice the best match** for each block (not hand-assembled generics)?
- [ ] Is nesting as shallow as possible (no pointless groups/rows)?
- [ ] Are colors/type/spacing from the **defined system** (consistent), not ad-hoc?
- [ ] Is the **responsive behavior** specified for every multi-column/grid section?
- [ ] Any ⚠️/❌ modules from COVERAGE used? Replace or flag.
- [ ] Realistic copy (no lorem in headings/CTAs)?
- [ ] **Real modules only** — no page built from `divi/code` + a stylesheet (§5b / BASE rule 14)?
- [ ] **Copy is verbatim** vs the user's source/reference (no paraphrasing)?
- [ ] **Variable gate honoured** — tokens used where they exist / user opted in; inline only where they don't or the user opted out?
- [ ] **Contrast on dark backgrounds** checked (titles/meta/icons use light tokens; no undefined `var()`)?
- [ ] **No AI-design clichés (§8b)** — grounded in the brief + a coherent token set (Mode A live tokens / Mode B defined-or-stated), not the reflex cream+serif+terracotta default, rainbow gradients, emoji-as-UI, left-border cards, or Inter-everywhere; hover/focus states defined?

> Then run the full **Authoring Self-Audit Gate (BASE §9)** before deploying.

---

## 12. Blueprint Template (fill this in)

```
## Discovery   (ask these, then wait for answers — skip if brief already covers them)
1. Goal & primary CTA?  2. Audience & tone?  3. Brand colors/fonts + logo?
4. Real content or placeholders?  5. Must-have sections?  6. Reference site?  7. Page or TB template / length?
(+ page-type add-ons as relevant. Offer defaults; if user says "just go", proceed on stated assumptions.)

## Page Plan
Intent: <page type> | goal: <action> | CTA: "<text>" → <url> | audience/tone: <...> | brand: <colors/fonts>
Narrative: <section flow in arrows>
Design system: BG <..> / surface <..> / accent <..> | type <h1/h2/h3/body> <font> | pad <d/t/p> | container <px> | radius <px>
Blueprint:
  S1 <purpose> — Layout: <..> | Modules: <..> | BG: <..> | Notes: <hierarchy, responsive>
  S2 ...
  ...

## Self-Critique
<rubric pass; revisions>

## JSON
<markup>
```

---

*DIVI5 Design Process Skill — V0.6.2 | Builder Version 5.8.1 | Created by Shashank Gupta @ divilove.com*
