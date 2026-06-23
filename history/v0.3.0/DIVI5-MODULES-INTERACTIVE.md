---
name: divi5-modules-interactive
description: Confirmed JSON structures for Divi 5 interactive modules — accordion, toggle, tabs, contact-form (all field types), signup, the full interaction trigger/target system, and canvas popup pattern.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — Interactive Modules
> **Part of the DIVI5 skill set. Attach when using accordion, toggle, tabs, contact-form, or signup.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE (this) · MODULES-MEDIA · MODULES-DATA · WORDPRESS · PATTERNS

---

## `divi/accordion` + `divi/accordion-item`

Expandable FAQ items. `accordion` is **NOT self-closing**. `accordion-item` **IS self-closing**.

```json
// accordion (parent — container):
{
  "builderVersion": "5.1.0"
}

// accordion-item (child — self-closing):
{
  "module": {
    "advanced": {"open": {"desktop": {"value": "on"}}}
  },
  "title":   {"innerContent": {"desktop": {"value": "Question text?"}}},
  "content": {"innerContent": {"desktop": {"value": "\u003cp\u003eAnswer text.\u003c/p\u003e"}}},
  "builderVersion": "5.1.0"
}
```

**`open`:** `"on"` = expanded by default, `"off"` = collapsed

**Confirmed working (real-render tested):** First item with `open: "on"` expands correctly; subsequent items with `open: "off"` collapse correctly. The accordion renders all items in a stacked list inside its column — do not set padding on the wrapping column (see BASE skill — Column Padding rule).

**FAQ pattern:** constrain the accordion's parent row to `max_width: '800px'` for readability:
```
Section → Row (max 800px) → Column → Accordion → Accordion-items
```

---

## `divi/toggle`

Single expand/collapse toggle. **Self-closing.** Confirmed working.

```json
{
  "title":   {"innerContent": {"desktop": {"value": "Toggle Title"}}},
  "content": {"innerContent": {"desktop": {"value": "\u003cp\u003eContent here.\u003c/p\u003e"}}},
  "builderVersion": "5.1.0"
}
```

**Confirmed (real-render tested):** Renders with expand/collapse affordance. Use inside a narrow row (`max_width: '800px'`) for readability. Unlike `accordion`, each `toggle` is a standalone self-closing module placed directly in a column — no container needed.

---

## `divi/tabs` + `divi/tab`

Tabbed panels. `tabs` is **NOT self-closing**. `tab` **IS self-closing**. Confirmed working.

```json
// tabs (parent — container):
{
  "builderVersion": "5.1.0"
}

// tab (child — self-closing):
{
  "title":   {"innerContent": {"desktop": {"value": "Tab Label"}}},
  "content": {"innerContent": {"desktop": {"value": "\u003cp\u003eTab content.\u003c/p\u003e"}}},
  "builderVersion": "5.1.0"
}
```

**Confirmed (real-render tested):** First tab is active by default. Other tabs render as clickable labels in a tab bar. On mobile the tab bar remains a horizontal row (may scroll). Place inside a narrow row (`max_width: '900px'`) to avoid overly wide tab content areas.

---

## `divi/contact-form` + `divi/contact-field`

`contact-form` is **NOT self-closing**. `contact-field` **IS self-closing**.

```json
// contact-form (parent — container):
{
  "module": {
    "advanced": {
      "uniqueId": {"desktop": {"value": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"}}
    },
    "decoration": {
      "background": {"desktop": {"value": {"color": "#FFFFFF"}}},
      "border": {"desktop": {"value": {"radius": {
        "topLeft": "16px", "topRight": "16px",
        "bottomLeft": "16px", "bottomRight": "16px", "sync": "on"
      }}}},
      "spacing": {"desktop": {"value": {"padding": {
        "top": "48px", "bottom": "48px", "left": "48px", "right": "48px"
      }}}}
    }
  },
  "builderVersion": "5.1.0"
}

// contact-field (child — self-closing):
{
  "module": {
    "decoration": {
      "sizing": {
        "desktop":   {"value": {"flexType": "12_24"}},
        "tablet":    {"value": {"flexType": "24_24"}},
        "phoneWide": {"value": {"flexType": "24_24"}},
        "phone":     {"value": {"flexType": "24_24"}}
      }
    }
  },
  "fieldItem": {
    "advanced": {
      "fullwidth": {"desktop": {"value": "on"}},
      "id":        {"desktop": {"value": "email"}},
      "type":      {"desktop": {"value": "email"}}
    },
    "innerContent": {"desktop": {"value": "Email Address"}}
  },
  "builderVersion": "5.1.0"
}
```

**Field types (confirmed working):** `"input"` (text), `"email"`, `"text"` (textarea), `"select"` (dropdown), `"checkbox"` (multi-select), `"radio"` (single-select)

**Field layout:** use `module.decoration.sizing.flexType` to make fields half-width (`12_24`) or full-width (`24_24`). Always override tablet/phone to `24_24` so fields stack on small screens.

**Submit button:** Divi auto-injects a Submit button on every contact form. To customise its label and style, add a top-level `button` key to the `contact-form` module:

```json
{
  "module": { "advanced": {"uniqueId": {"desktop": {"value": "UUID"}}} },
  "button": {
    "decoration": {
      "button": {"desktop": {"value": {"enable": "on"}}},
      "background": {"desktop": {"value": {"color": "#2563eb"}}},
      "border": {"desktop": {"value": {"radius": {
        "topLeft": "2rem", "topRight": "2rem",
        "bottomLeft": "2rem", "bottomRight": "2rem", "sync": "on"
      }}}}
    },
    "innerContent": {"desktop": {"value": {"text": "Send Message"}}}
  },
  "builderVersion": "5.1.0"
}
```

`button.decoration.button.desktop.value.enable: "on"` must be present or the custom styles are ignored. The `text` field sets the button label.

**Auto-injected CAPTCHA:** Divi automatically adds a math CAPTCHA ("1 + 1 = ?") to every contact form. It cannot be removed and does not require any markup.

**`uniqueId`:** Required. Use any unique UUID-format string. Without it, multiple forms on the same page may conflict.

### Contact Field Options (confirmed working — real-render tested)

Options go in `fieldItem.advanced`, NOT in `innerContent` (so the array-crash rule does NOT apply here).

**SELECT (dropdown) — `selectOptions`:**
```python
contact_field('How did you hear about us?', 'select', 'source', extra_attrs={
    'selectOptions': {'desktop': {'value': [
        {'value': 'Please select one...', 'id': 'opt-placeholder'},
        {'value': 'Search engine',        'id': 'opt-search'},
        {'value': 'Social media',         'id': 'opt-social'},
        {'value': 'Friend or colleague',  'id': 'opt-referral'},
        {'value': 'Other',                'id': 'opt-other'},
    ]}}
})
```
Each option: `{'value': 'Display text', 'id': 'any-unique-string'}`

**CHECKBOX (multi-select) — `checkboxOptions`:**
```python
contact_field('Which features interest you?', 'checkbox', 'features', extra_attrs={
    'checkboxOptions': {'desktop': {'value': [
        {'value': 'Visual Builder', 'checked': '0', 'dragID': 'cb-1'},
        {'value': 'REST API',       'checked': '0', 'dragID': 'cb-2'},
        {'value': 'Global Tokens',  'checked': '1', 'dragID': 'cb-3'},  # pre-checked
    ]}}
})
```
Each option: `{'value': 'Label text', 'checked': '0'|'1', 'dragID': 'any-unique-string'}`
`checked: '1'` = pre-checked by default.

**RADIO (single-select) — `radioOptions`:**
```python
contact_field('What best describes you?', 'radio', 'role', extra_attrs={
    'radioOptions': {'desktop': {'value': [
        {'value': 'Freelance designer',  'checked': '0', 'dragID': 'rb-1'},
        {'value': 'Agency owner',        'checked': '0', 'dragID': 'rb-2'},
        {'value': 'In-house developer',  'checked': '1', 'dragID': 'rb-3'},  # pre-selected
    ]}}
})
```
Same structure as `checkboxOptions` — `checked: '1'` pre-selects that radio option.

**Optional link on checkbox option:**
```python
{'value': 'Terms text', 'checked': '0', 'dragID': 'cb-1',
 'link': {'url': 'https://example.com/terms', 'text': 'view terms'}}
```

**⚠️ `boolean_checkbox` type — does NOT render:** The `boolean_checkbox` field type (single agree/disagree checkbox) is silently skipped — the field does not appear in the rendered form. Use `checkbox` type with a single option instead for a "terms agree" checkbox.

**`fieldItem` structure for fields with options:**
```python
{
    'fieldItem': {
        'innerContent': {'desktop': {'value': 'Field Label'}},
        'advanced': {
            'type':     {'desktop': {'value': 'select'}},   # or checkbox / radio
            'id':       {'desktop': {'value': 'field-id'}},
            'required': {'desktop': {'value': 'off'}},
            'selectOptions': {'desktop': {'value': [...]}}  # or checkboxOptions / radioOptions
        }
    },
    'builderVersion': '5.1.0'
}
```

---

## `divi/signup`

Email subscription form. **Self-closing.**

```json
{
  "title": {
    "innerContent": {"desktop": {"value": "Stay in the Loop"}},
    "decoration": {"font": {"font": {"desktop": {"value": {
      "headingLevel": "h2", "size": "2rem", "weight": "800", "color": "#FFFFFF",
      "textAlign": "center"
    }}}}}
  },
  "content": {
    "innerContent": {"desktop": {"value": "\u003cp\u003eGet weekly tips delivered to your inbox.\u003c/p\u003e"}},
    "decoration": {"bodyFont": {"body": {"font": {"desktop": {"value": {
      "color": "#94a3b8", "size": "16px", "textAlign": "center"
    }}}}}}
  },
  "builderVersion": "5.1.0"
}
```

**Note:** The signup module renders with its own italic heading style. Title/content font overrides apply but the module may apply additional default typography. Constrain to a narrow row (`max_width: '600px'`) for a centered newsletter block.

---

## Interactions — Trigger/Target System

Interactions are **not a module** — they are decoration properties added to any existing module. **Confirmed working (real-render + live browser tested).**

### How it works

Two modules are linked by shared short IDs:

```
Trigger module:  interactionTrigger = "abc123"
                 interactions array contains: triggerClass = "et-interaction-trigger-abc123"

Target module:   interactionTarget  = "xyz789"   ← no prefix here
                 interactions array contains: targetClass  = "et-interaction-target-xyz789"
```

### Trigger module decoration

```python
{
  "interactionTrigger": "abc123",           # short unique ID — generate with uid()
  "interactions": {
    "desktop": {"value": {"interactions": [
      {
        "id":                   "unique-id",
        "enableInteraction":    "on",
        "trigger":              "click",    # see trigger types below
        "effect":               "toggleVisibility",  # see effects below
        "target": {
          "targetClass":  "et-interaction-target-xyz789",  # prefix + target ID
          "label":        "human label (builder UI only)",
          "moduleId":     "",
          "targetType":   "module",
        },
        "triggerClass":         "et-interaction-trigger-abc123",  # prefix + trigger ID
        "adminLabel":           "human label",
        "timeDelay":            "5000ms",   # optional — only for delayed effects
        "replaceExistingPreset": False,
        "sensitivity":          50,
        "mouseMovementType":    "translate",
        "cookieName":           "",
        "cookieValue":          "",
        "presetId":             "",
      }
    ]}}
  }
}
```

The interaction array can be set on **any** module — the trigger module, a parent section, or even a completely separate module. The IDs link them at runtime.

### Target module decoration

```python
{
  "interactionTarget": "xyz789",   # no prefix — just the short ID
  "disabledOn": {                  # hides the element initially
    "desktop": {"value": "on"},
    "tablet":  {"value": "on"},
    "phone":   {"value": "on"},
  }
}
```

### Trigger types (confirmed)

| `trigger` | When it fires |
|-----------|---------------|
| `"click"` | User clicks the trigger element |
| `"mouseEnter"` | Cursor enters the trigger element |
| `"mouseExit"` | Cursor leaves the trigger element |
| `"load"` | Page load (use with `timeDelay` for delayed reveal) |
| `"viewportEnter"` | Element scrolls into the viewport |
| `"viewportExit"` | Element scrolls out of the viewport |

### Effects (confirmed)

| `effect` | What it does |
|----------|--------------|
| `"toggleVisibility"` | Show/hide target on each trigger (bidirectional) |
| `"addVisibility"` | Make target visible (one-way) |
| `"removeVisibility"` | Hide target (one-way) |

### Python helper

```python
import random, string

def uid(n=10):
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=n))

def trigger_decoration(trigger_id, interactions_list):
    return {
        'interactionTrigger': trigger_id,
        'interactions': {'desktop': {'value': {'interactions': interactions_list}}}
    }

def target_decoration(target_id):
    return {
        'interactionTarget': target_id,
        'disabledOn': {
            'desktop': {'value': 'on'},
            'tablet':  {'value': 'on'},
            'phone':   {'value': 'on'},
        }
    }

def make_interaction(trigger_id, target_id, trigger, effect,
                     admin_label='', time_delay=None):
    obj = {
        'id': uid(), 'enableInteraction': 'on',
        'trigger': trigger, 'effect': effect,
        'target': {
            'targetClass': f'et-interaction-target-{target_id}',
            'label': admin_label, 'moduleId': '', 'targetType': 'module',
        },
        'triggerClass': f'et-interaction-trigger-{trigger_id}',
        'adminLabel': admin_label, 'presetId': '',
        'replaceExistingPreset': False, 'sensitivity': 50,
        'mouseMovementType': 'translate', 'cookieName': '', 'cookieValue': '',
    }
    if time_delay:
        obj['timeDelay'] = time_delay
    return obj
```

### Usage examples

**Click to toggle:**
```python
trig, targ = uid(), uid()
trigger_module_decoration = trigger_decoration(trig, [
    make_interaction(trig, targ, 'click', 'toggleVisibility', 'show on click')
])
target_module_decoration = target_decoration(targ)
```

**Page load + 5s delay reveal (interaction on section):**
```python
trig, targ = uid(), uid()
section_decoration = {
    **trigger_decoration(trig, [
        make_interaction(trig, targ, 'load', 'addVisibility', 'delayed reveal', '5000ms')
    ]),
    'background': {'desktop': {'value': {'color': '#fff'}}},
    # ... other section decoration
}
target_module_decoration = target_decoration(targ)
```

**Hover show / mouse-leave hide (two separate triggers):**
```python
trig_enter, trig_exit, targ = uid(), uid(), uid()
hover_box_decoration = trigger_decoration(trig_enter, [
    make_interaction(trig_enter, targ, 'mouseEnter', 'addVisibility', 'show on hover')
])
exit_zone_decoration = trigger_decoration(trig_exit, [
    make_interaction(trig_exit, targ, 'mouseExit', 'removeVisibility', 'hide on leave')
])
target_module_decoration = target_decoration(targ)
```

### Canvas popup (local canvas + interactions)

A canvas can serve as a modal/popup overlay. The popup lives inside a local canvas, starts hidden via `disabledOn`, and is shown/hidden by interactions from the main page.

**Step 1 — Local canvas entry** in `canvases.local`. The canvas `zIndex` stacks it above page content:

```json
"canvases": {
  "local": {
    "UUID": {
      "id": "UUID",
      "name": "my-popup",
      "isMain": false,
      "isGlobal": false,
      "appendToMainCanvas": null,
      "zIndex": "9999",
      "content": "<!-- wp:divi/placeholder -->...<!-- /wp:divi/placeholder -->"
    }
  }
}
```

**Step 2 — Popup section inside the canvas** — fixed overlay, hidden by default:

```json
{
  "builderVersion": "5.1.0",
  "module": {
    "decoration": {
      "interactionTarget": "POPUP_TARGET_ID",
      "disabledOn": {
        "desktop": {"value": "on"},
        "tablet":  {"value": "on"},
        "phone":   {"value": "on"}
      },
      "position": {
        "desktop": {"value": {"mode": "fixed", "origin": {"fixed": "center center"}}}
      },
      "zIndex":   {"desktop": {"value": "99999"}},
      "sizing":   {"desktop": {"value": {"height": "100vh"}}},
      "overflow": {"desktop": {"value": {"y": "scroll"}}},
      "background": {"desktop": {"value": {"color": "rgba(0,0,0,0.8)"}}}
    }
  }
}
```

**Step 3 — Close icon (X) inside the canvas** — absolutely positioned, click fires `removeVisibility`:

```python
close_trig = uid()
close_icon_decoration = {
    **trigger_decoration(close_trig, [
        make_interaction(close_trig, 'POPUP_TARGET_ID', 'click', 'removeVisibility', 'close popup')
    ]),
    'position': {
        'desktop': {'value': {
            'mode': 'absolute',
            'origin': {'absolute': 'top right'},
            'offset': {'horizontal': '4px', 'vertical': '4px'}
        }}
    }
}
```

**Step 4 — Show trigger on main page** — `load` + delay fires `addVisibility` on the popup section:

```python
trig = uid()
page_section_decoration = {
    **trigger_decoration(trig, [
        make_interaction(trig, 'POPUP_TARGET_ID', 'load', 'addVisibility', 'show popup', '10000ms')
    ]),
    # ... other section decoration
}
```

For a button-triggered popup instead of auto-show, use `trigger: "click"` on the button module.

**Key rules:**
- Canvas `zIndex` (9999) + popup section `zIndex` (99999) must both be set high
- `disabledOn` on all 3 breakpoints ensures the popup starts hidden
- `POPUP_TARGET_ID` is the short ID used in both `interactionTarget` on the section and `targetClass: "et-interaction-target-POPUP_TARGET_ID"` in all interactions

---

*DIVI5 Interactive Modules Skill — V0.3.0 | Builder Version 5.1.0 | Created by Shashank Gupta @ divilove.com*
