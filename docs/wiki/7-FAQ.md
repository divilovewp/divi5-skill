# FAQ

**Do I need the Divi Connect plugin to use this?**
No. The skill works fully on the JSON-only path — it generates Divi 5 markup you import
yourself. The plugin is an optional convenience for reading your design system and
publishing live.

**Which Divi version does it target?**
The Divi 5.7.x line (latest 5.7.4). Generated markup stamps `"builderVersion": "5.7.4"`.
Older builder versions still import via Divi's backward-compatibility migration, but
match your installed version where you can.

**My generated module renders blank — why?**
Almost always one of the block-markup rules in `DIVI5-BASE.md`: attributes wrapped in an
`attrs` key, the wrong text key (it must be `content`), raw (unescaped) HTML in a value,
or a missing `builderVersion`. Check those four first.

**Can it use my brand colors and spacing?**
Yes. If your site exposes a design system (global colors + size/spacing variables), the
skill uses the real `$variable(...)$` tokens so the page stays editable and on-brand. It
never invents token IDs — it only uses ones your site actually defines.

**Does it stack correctly on mobile?**
Layout modules stack via the row/column flex system. A few container modules manage
their own internal layout (e.g. grid, pricing-tables, the tabs bar) and need responsive
settings called out — these gotchas are documented per module.

**How current is the coverage?**
`DIVI5-COVERAGE.md` tracks what is render-verified vs source-verified vs untested.
Modules are deepened one at a time under the protocol in
[Contributing](6-Contributing.md).

**What's the license?**
MIT — see `LICENSE`.
