---
name: divi5-custom-modules
description: Building custom Divi 5 modules — confirmed file structure, PHP registration hooks, JavaScript registration pattern, module.json attribute schema, and the relationship between module.json and the serialized JSON the skill files document. Covers all 5 official module types.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Custom Module Development
> **Part of the DIVI5 skill set. Attach when building custom Divi 5 modules or integrating a custom module's JSON output with the existing skill files.**
> Skill files: BASE · DESIGN-PROCESS · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE · WORDPRESS · PATTERNS · CUSTOM-MODULES (this)

> **✅ RENDER-CONFIRMED on Divi 5.9.0.** This contract was documented but never built
> against real code until a real FAQ **parent/child module pack** (emitting schema.org
> FAQPage JSON-LD) validated it end-to-end: both block types register, a generated
> layout imports via the portability path, parent/child nesting survives, and the
> modules render on the front end.
> **Three corrections came out of that build** — each marked inline below:
> 1. `DependencyInterface` lives in `Framework\DependencyManagement\Interfaces\`,
>    not `Framework\DependencyTree\`.
> 2. `render_callback` receives **5** arguments, not 3.
> 3. Module classes must be `require`d **inside** the dependency-tree hook, or the
>    site fatals ("Interface … not found") because plugins load before the theme.
>
> **Two more contract gotchas** surfaced when the pack went through a
> security/correctness review (see "Two rules every module must follow" below):
> 4. A module must emit its **own block-level class** in `render_callback` — Divi's
>    wrapper carries only Divi's classes, so any `.vendor-*` CSS is dead otherwise.
> 5. Any `<script type="application/ld+json">` a module emits must be encoded with
>    `JSON_HEX_TAG`, or a `</script>` in the content is a stored-XSS breakout.

---

## What a Custom Module Is

A custom Divi 5 module is a WordPress plugin that registers a new block type under a custom namespace (e.g. `vendor/my-module`). It uses the same serialized Gutenberg block format as all built-in `divi/*` modules — the JSON patterns documented in the other DIVI5 skill files apply identically to custom modules.

The block comment in `post_content` looks like:
```
<!-- wp:vendor/my-module {"builderVersion":"5.9.0","title":{...}} /-->
```

`"builderVersion":"5.9.0"` is **required** on custom modules, just as on all built-in modules (match the installed Divi version; older values still import via backward-compat migration).

---

## Plugin File Structure

```
my-module-plugin/
├── my-module-plugin.php        ← defines constants, requires server/index.php
├── server/
│   └── index.php               ← PHP class: render_callback, module_styles, classnames
└── visual-builder/
    ├── package.json
    ├── webpack.config.js
    ├── src/
    │   ├── index.jsx           ← calls window.divi.moduleLibrary.registerModule()
    │   └── module.json         ← entire module schema: attributes, UI panels, CSS selectors
    └── build/
        └── my-module-plugin.js ← compiled output, enqueued by PHP
```

---

## PHP Registration — Two Required Hooks

```php
define( 'MY_PLUGIN_URL', plugin_dir_url( __FILE__ ) );
define( 'MY_PLUGIN_PATH', plugin_dir_path( __FILE__ ) );

// 1. Enqueue the compiled JS into the visual builder
add_action( 'divi_visual_builder_assets_before_enqueue_scripts', function() {
    \ET\Builder\VisualBuilder\Assets\PackageBuildManager::register_package_build([
        'name'    => 'my-module-visual-builder',
        'version' => '1.0.0',
        'script'  => [
            'src'                => MY_PLUGIN_URL . 'visual-builder/build/my-module-plugin.js',
            'deps'               => ['react', 'jquery', 'divi-module-library', 'wp-hooks', 'divi-rest'],
            'enqueue_app_window' => true,
        ]
    ]);
});

// 2. Register the PHP class in the module dependency tree.
//    REQUIRE THE CLASS FILES *INSIDE* THIS CALLBACK — see the gotcha below.
add_action( 'divi_module_library_modules_dependency_tree', function( $dependency_tree ) {
    require_once MY_PLUGIN_PATH . 'server/MyModule.php';
    $dependency_tree->add_dependency( new MyModule() );
});
```

> ### ⚠ Require the class files inside the hook, not at plugin load
>
> **Plugins load BEFORE the theme**, so Divi's autoloader — and therefore
> `DependencyInterface` — does not exist yet at plugin-load time. Because
> `implements DependencyInterface` is resolved at class-**declaration** time, a
> top-level `require_once` of the module class fatals the whole site with:
>
> ```
> Uncaught Error: Interface "ET\Builder\Framework\DependencyManagement\Interfaces\DependencyInterface" not found
> ```
>
> Deferring the `require_once` into the `divi_module_library_modules_dependency_tree`
> callback fixes it **and** makes the plugin inert-by-construction: with Divi absent
> or too old the action never fires, the class is never declared, nothing can fatal.
> (Hit and fixed while building a real module pack — verified on 5.9.0.)

Inside the `MyModule` class (implements `DependencyInterface`):
```php
// NOTE the namespace: DependencyManagement\Interfaces — NOT Framework\DependencyTree.
use ET\Builder\Framework\DependencyManagement\Interfaces\DependencyInterface;
use ET\Builder\Packages\Module\Layout\Components\ModuleElements\ModuleElements;
use ET\Builder\Packages\ModuleLibrary\ModuleRegistration;

class MyModule implements DependencyInterface {

    public function load(): void {
        ModuleRegistration::register_module(
            MY_PLUGIN_PATH . 'visual-builder/src/',   // dir CONTAINING module.json
            ['render_callback' => [ self::class, 'render_callback' ]]
        );
    }

    // Divi 5 passes FIVE arguments, not three. Declaring fewer works (PHP ignores
    // the extras) but you then lose $elements — which you need for decoration CSS.
    public static function render_callback(
        array $attrs, string $content, \WP_Block $block,
        ModuleElements $elements, array $default_printed_style_attrs
    ): string {
        $title = $attrs['title']['innerContent']['desktop']['value'] ?? '';
        return "<div class=\"my-module\"><h2>{$title}</h2>{$content}</div>";
    }
}
```

**Returning raw HTML (above) renders content but emits NO decoration CSS.** To make
the `module.decoration.*` panels actually style anything, return
`Module::render([...])` (as core modules do) with a `stylesComponent` that calls
`$elements->style(['attrName' => 'module'])`. Divi's core-module examples (linked
below) show a worked `Module::render` implementation.

### ⚠ Two rules every module must follow (found the hard way)

Both surfaced only under a security/correctness review of the pack — each renders
or behaves fine until a specific condition, so they don't show up in a quick test.

**1. Emit your own block-level class.** Divi's module wrapper carries **only Divi's**
classes, so a stylesheet rule like `.my-module__title { … }` never matches unless
`render_callback` puts `.my-module` on the HTML it returns (as the example above
does with `class="my-module"`). Symptom when you forget: the module's CSS is
silently dead — most visibly if you scope CSS custom properties to the block class,
because then even inherited `fill`/`color` values fall back and marks render in the
wrong colour.

**2. Encode any JSON-LD with `JSON_HEX_TAG`.** A module that emits
`<script type="application/ld+json">` must build the JSON with
`wp_json_encode( $data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_HEX_TAG )`.
Without `JSON_HEX_TAG` a `<` is emitted literally, so any content value containing
`</script>` closes the element early and injects markup — a **stored XSS**. This
bites hardest when the value is preserved raw for the structured data (the visible
copy may be `wp_kses_post()`-cleaned while the JSON-LD copy is not). `JSON_HEX_TAG`
escapes `<`/`>` to `<`/`>`, so no literal `</script` can appear in the
output — which is exactly what stops the breakout.

---

## JavaScript Registration

```javascript
const { addAction } = window?.vendor?.wp?.hooks;
const { registerModule } = window?.divi?.moduleLibrary;

addAction(
    'divi.moduleLibrary.registerModuleLibraryStore.after',
    'myPlugin.myModule',
    () => {
        registerModule(myModule.metadata, myModule);
    }
);
```

`myModule.metadata` comes from the `module.json` file (auto-imported by your Webpack config).

---

## Build Setup — Standard Webpack + Babel

`@divi/*` packages are **not on npm**. They are exposed as `window.divi.*` globals by the Divi 5 theme and declared as Webpack externals. Do not try to install them.

**`package.json`:**
```json
{
  "scripts": {
    "start": "NODE_ENV=development webpack -w --config webpack.config.js",
    "build": "NODE_ENV=production webpack --config webpack.config.js"
  },
  "devDependencies": {
    "@babel/core": "^7.21.0",
    "@babel/preset-env": "^7.20.2",
    "@babel/preset-react": "^7.18.6",
    "babel-loader": "^9.1.2",
    "webpack": "^5.75.0",
    "webpack-cli": "^5.0.1"
  }
}
```

**`webpack.config.js` externals (required):**
```javascript
externals: {
    react:          'React',
    'react-dom':    'ReactDOM',
    '@divi/module': ['divi', 'module'],
    '@divi/module-library': ['divi', 'moduleLibrary'],
    '@divi/icons':  ['divi', 'icons'],
    '@wordpress/hooks': ['vendor', 'wp', 'hooks'],
}
```

> **Server-rendered-only option.** If your sites are generated as JSON and rendered
> server-side (never hand-edited in the Visual Builder), you can ship a module with
> **only** the PHP half — the `render_callback` above — and skip the entire
> `visual-builder/` build. The module then renders correctly from serialized markup;
> it is simply not editable in the VB until you add the compiled bundle. Everything
> in this file except this "Build Setup" section applies to that server-only case too.

---

## The `module.json` Attribute Schema

`module.json` is the central definition file. It declares all fields, their UI panels, and their CSS selectors. The attribute structure has **6 levels**:

```
title                        ← 1. Element (attribute key in module.json)
  decoration                 ← 2. Element Part: innerContent | decoration | meta | advanced
    font                     ← 3. Option (specific styling property)
      desktop                ← 4. Breakpoint: desktop | tablet | phone
        value                ← 5. State: value | hover | sticky
          { size: "18px" }   ← 6. Actual value
```

`innerContent` **skips level 3** — the breakpoint sits directly under it:
```
title.innerContent.desktop.value = "Hello"
```

**Full attribute entry (from official static module example):**
```json
"title": {
  "type": "object",
  "selector": "{{selector}} .my_module__title",
  "tagName": "h2",
  "inlineEditor": "plainText",
  "settings": {
    "innerContent": {
      "groupType": "group-item",
      "item": {
        "label": "Title",
        "component": { "name": "divi/text", "type": "field" }
      }
    },
    "decoration": {
      "font": { "priority": 10, "component": { "props": { "groupLabel": "Title Text" } } }
    }
  }
}
```

**The `module` attribute** opts into all decoration panels:
```json
"module": {
  "type": "object",
  "selector": "{{selector}}",
  "settings": {
    "decoration": {
      "background": {}, "spacing": {}, "border": {}, "sizing": {},
      "position": {}, "zIndex": {}, "boxShadow": {}, "animation": {},
      "overflow": {}, "transition": {}, "scroll": {}, "sticky": {}
    }
  }
}
```

**For custom modules, decoration panels must be explicitly opted into.** Unlike built-in `divi/*` modules (which pre-declare all decoration options), a custom module that omits `"border": {}` from its module attribute settings will have no border panel — and `module.decoration.border` will not appear in its serialized JSON output.

---

## `inlineEditor` Types → Content Encoding

| `inlineEditor` value | Content type | Encoding rule |
|---------------------|--------------|---------------|
| `"plainText"` | Plain text | No HTML allowed — raw string only |
| `"richText"` | HTML content | Encode `<` as `&lt;`, `>` as `&gt;` in JSON |

This maps directly to the encoding rules in DIVI5-BASE and DIVI5-MODULES-CONTENT.

---

## `tagName` → Heading Level Behavior

Declaring `"tagName": "h2"` on a title attribute enables the `headingLevel` override in the font decoration — the same mechanism built-in `divi/heading` uses. The serialized JSON can then include:
```json
"title": {
  "decoration": {
    "font": {
      "font": {"desktop": {"value": {"headingLevel": "h3"}}}
    }
  }
}
```

---

## The 5 Official Module Types

| Type | Built-in equivalent | When to use |
|------|--------------------|----|
| **Static Module** | `divi/blurb` | Fields render directly; no WP data fetching. Most common. |
| **Dynamic Module** | `divi/blog` | Uses WP REST API to fetch posts dynamically at render time |
| **Parent Module** | `divi/accordion` | Accepts child modules as block children; uses open+close block comment pair |
| **Child Module** | `divi/accordion-item` | Only valid inside its registered parent module |
| **Converted D4 Module** | — | Migration path from `ET_Builder_Module` — see official D4→D5 guide |

Parent modules in serialized JSON use open+close block comments (not self-closing):
```
<!-- wp:vendor/my-parent {"builderVersion":"5.9.0"} -->
<!-- wp:vendor/my-child {"builderVersion":"5.9.0"} /-->
<!-- wp:vendor/my-child {"builderVersion":"5.9.0"} /-->
<!-- /wp:vendor/my-parent -->
```

**Declaring the pair in `module.json`** (mirrors how `divi/accordion` +
`divi/accordion-item` do it — verified against the 5.9.0 source):

| Key | Parent | Child |
|-----|--------|-------|
| `category` | `"module"` | **`"child-module"`** |
| `childrenName` | `["vendor/my-child"]` | `[]` |
| `childModuleName` / `childModuleTitle` | the child's name/label | — |

**How the parent receives its children:** WordPress renders inner blocks *first*,
then passes their combined output to the parent's `render_callback` as `$content`
(child ids are also on `$block->parsed_block['innerBlocks']`). So a parent that
needs to inspect its children's *data* (e.g. to build structured data) can have each
child record what it needs during its own render and drain it in the parent — the
pattern a FAQ parent uses to emit FAQPage JSON-LD.

**Confirmed:** parent/child nesting survives the portability import intact — the
open+close comments round-trip and children render inside the parent (5.9.0).

---

## Portability Caveat

Custom module blocks **silently fail** (render as nothing or show a placeholder) if the plugin that registered them is not active on the target WordPress site. Built-in `divi/*` modules are always available when Divi is active; custom `vendor/*` modules are not.

When generating JSON that includes custom modules, always note the required plugin dependency.

---

## Official Resources

| What | URL |
|------|-----|
| 10-minute quickstart | https://dev.elegantthemes.com/docs/tutorials/module/beginner/create-simple-quick-module/ |
| Module attributes reference | https://dev.elegantthemes.com/docs/tutorials/module/beginner/module-attributes/ |
| Example modules (5 types) | https://github.com/elegantthemes/d5-extension-example-modules |
| Core module examples | https://github.com/elegantthemes/d5-example-core-modules |
| D4 → D5 conversion guide | https://github.com/elegantthemes/d5-tutorial-module-conversion |
| Dev state monitor tool | https://github.com/elegantthemes/d5-dev-tool |

---

*DIVI5 Custom Modules Skill — Builder Version 5.9.0 | Created by Shashank Gupta @ divilove.com*
*Contributed by MDHMatt (MDHosting) — render-confirmed + corrected on Divi 5.9.0 by building a real parent/child module pack; see the status note at the top.*
