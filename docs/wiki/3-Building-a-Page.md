# Building a Page

The skill treats building a page as a **gated, multi-step** process — the plan is the
thinking; the markup is just transcription. Full method lives in
`DIVI5-DESIGN-PROCESS.md`; this is the short version.

## The workflow
1. **Connection mode.** The model asks whether you want JSON only or to publish live
   (Divi Connect). On the live path it loads your real design system first.
2. **Discovery.** It asks a focused, batched set of questions — goal/offer, audience,
   key sections, brand/tone, must-have content, primary CTA — then waits for your
   answers. (Skipped only if you gave detailed requirements or say "just build it.")
3. **Page Plan + approval.** It presents a concise written plan (intent → narrative →
   section blueprint → which design tokens map to what) and waits for your approval.
4. **Build.** Only after approval does it generate the markup and (live mode) create
   the page.

This gating is deliberate — a short brief like "a page for a business coach" doesn't
specify the offer, audience, sections, or CTA, so the model asks before guessing.

## Using the JSON it produces
The output is a Divi 5 builder content string wrapped in
`<!-- wp:divi/placeholder --> … <!-- /wp:divi/placeholder -->`. Import it by either:

- **Divi Import/Export** in the builder UI, or
- **WordPress REST API / WP-CLI** — see `DIVI5-WORDPRESS.md`. Pages created via REST
  need the Divi builder meta set, e.g.:

```python
payload = {
    "title": "My Page",
    "content": divi_markup,            # the placeholder-wrapped string
    "status": "publish",
    "template": "page-template-blank.php",
    "meta": {
        "_et_pb_use_builder": "on",
        "_et_pb_page_layout": "et_full_width_page",
    },
}
# POST to https://your-site.example/wp-json/wp/v2/pages
```

Without `_et_pb_use_builder: "on"`, Divi won't treat the content as a builder page.

## Design tokens
If your site has a design system (global colors and size/spacing variables), the skill
prefers the real `$variable(...)$` tokens so the page stays editable and on-brand. On
the live path it reads them automatically; on the JSON path, tell it your tokens or it
will use sensible inline values.
