# Publishing Live with Divi Connect

[Divi Connect](https://divilove.com/) is an optional WordPress plugin that connects
Claude to your Divi 5 site, so a page can be **read, planned, and published** without
leaving the conversation. The skill's `DIVI5-CONNECT.md` documents this path.

> The skill itself is free and license-agnostic — it contains no licensing logic. Any
> free/paid tiering lives entirely in the plugin. You can use the JSON-only path with
> no plugin at all.

## What the live path adds
- **Reads your real design system** — global colors, size/spacing variables, gradients,
  and presets — so generated pages use *your* tokens instead of guessed values.
- **Creates and edits pages** directly (and posts, Theme Builder templates, etc.,
  depending on the plugin tier).
- **Server-side validation** — the plugin rejects malformed markup, so the skill's
  block-markup rules and the plugin's validator reinforce each other.

## How it flows
1. Install the Divi Connect plugin and copy your connector URL from its settings page.
2. Add it to Claude (as a connector / MCP endpoint).
3. Ask for a page. The model loads your design system, plans the layout, and publishes
   it, returning the live URL.

## JSON-only vs live — same brain
The authoring knowledge is identical on both paths; the live path is just a publishing
adapter. If you don't use the plugin, everything in
[Building a Page](3-Building-a-Page.md) still applies — you import the JSON yourself.

For setup, plans, and troubleshooting of the plugin itself, see the Divi Connect
documentation at [divilove.com](https://divilove.com/).
