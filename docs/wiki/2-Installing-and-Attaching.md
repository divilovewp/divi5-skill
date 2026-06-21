# Installing & Attaching

The skill is a folder of Markdown files. How you "install" it depends on which Claude
surface you use.

## Claude Code
Place the skill folder where Claude Code can load skills (a skills directory or your
project), keeping `SKILL.md` at its root. Claude Code reads `SKILL.md` first and pulls
in the referenced `DIVI5-*.md` files on demand. Then just ask it to build a Divi 5 page.

## claude.ai (Projects)
Create a Project and add the skill files as Project knowledge (at minimum
`SKILL.md` + `DIVI5-BASE.md` + `DIVI5-DESIGN-PROCESS.md`; add module/styling files as
your work needs them). Start a chat in that Project and ask for a page.

## Claude Desktop
Attach the relevant files to the conversation (or keep them in a Project as above).

## Minimum vs. full attach
You rarely need all files. A good default:

| Task | Attach |
|------|--------|
| Any task | `SKILL.md` + `DIVI5-BASE.md` + `DIVI5-DESIGN-PROCESS.md` |
| Landing page (JSON) | + `DIVI5-LAYOUT.md` + `DIVI5-STYLING.md` + `DIVI5-MODULES-CONTENT.md` + `DIVI5-PATTERNS.md` |
| Publish live | + `DIVI5-CONNECT.md` |
| Import via REST/WP-CLI | + `DIVI5-WORDPRESS.md` |
| Interactive / media / data / dynamic / Woo | + the matching `DIVI5-MODULES-*.md` |

Loading only what a task needs keeps context small — the plugin-specific file
(`DIVI5-CONNECT.md`) isn't read at all on the JSON-only path.
