---
name: divi5-modules-woocommerce
description: Source-verified reference for the Divi 5 WooCommerce module family — shop/products grid, single-product element modules (title, price, images, add-to-cart, reviews, tabs, etc.), cart modules, and checkout modules. Requires WooCommerce active on the target site.
author: Shashank Gupta @ divilove.com
---

# DIVI5 Skill — WooCommerce Modules
> **Part of the DIVI5 skill set. Attach when building WooCommerce shop / product / cart / checkout layouts.**
> Skill files: BASE · LAYOUT · STYLING · MODULES-CONTENT · MODULES-INTERACTIVE · MODULES-MEDIA · MODULES-DATA · MODULES-DYNAMIC · MODULES-WOOCOMMERCE (this) · WORDPRESS · PATTERNS

> **Status (5.7.0): ✓ ENTIRE FAMILY render-confirmed** — all 25 modules verified at all 3 breakpoints against fixture products with real data (scenarios 29 product page, 30 cart, 31 checkout). Earlier-empty modules now confirmed with data: **product-gallery** (3-image gallery), **product-rating** (stars), **product-stock** ("7 in stock"), **product-reviews** (reviews list + form), **product-upsell** (shows the product's up-sells), **related-products** (same-category products), **cross-sells** (cart items' cross-sells), and the full **cart** (notice/products/totals) and **checkout** (billing/shipping/additional-info/order-details/payment) sets. Requires **WooCommerce active**. Single-product modules work on a product Theme Builder template OR anywhere by passing a specific product ID.

> ⚠️ **Insert-time gotcha (cart/checkout):** Divi renders a page's blocks at **save time** (to build critical CSS). The checkout modules `checkout-billing`, `-shipping`, `-additional-info`, `-payment-info` **fatal (HTTP 500) during a plain REST page insert when the WC cart/session is empty** — only `checkout-order-details` saves cleanly. In normal use this is a non-issue because you place them on the actual WC **Checkout** page / a **Checkout Theme Builder template**, where a cart context exists. For programmatic/REST insertion, boot a WC cart first (`wc_load_cart(); WC()->cart->add_to_cart($id);`) within the insert request. Cart modules (`cart-products` etc.) do **not** fatal on insert and render whenever `WC()->cart` is non-empty (no `is_cart()` page required — confirmed in `WooCommerceCartProductsModule.php:223`).

> **✓ Confirmed (scenario 21):** single-product modules accept a **specific product ID string** (e.g. `"86"`) in `content.advanced.product` — not only `"dynamic"` — so you can show a chosen product on any page. `divi/shop` with `type:"recent"` listed the product; price rendered in the site currency. Products with **no featured image** show a placeholder box in the grid.

---

## Two shared patterns

**1. Single-product element modules** (`product-title`, `product-price`, `product-images`, `product-add-to-cart`, …) target a product via:
```json
"content": {"advanced": {"product": {"desktop": {"value": "dynamic"}}}}
```
- `"dynamic"` = the **current product** (product single template / loop item).
- Or a **product post ID** string (e.g. `"42"`) to show a specific product anywhere.
- `"current"` / `"latest"` are also accepted in some modules for template contexts.

**2. Collection modules** (`products`/shop, `related-products`, `cross-sells`, `upsell`) use `content.advanced` query keys: `type`, `postsNumber`, `columnsNumber`, `offsetNumber`, `orderby`, `useCurrentLoop`.

All WooCommerce modules are **self-closing**.

---

## Module slug reference

### Showcase / collection
| Slug | Module | Notes |
|------|--------|-------|
| `divi/shop` | **Woo Products** (shop grid) | the main product grid; folder name `products` but slug is `divi/shop` |
| `divi/woocommerce-related-products` | Related Products | uses current product's categories |
| `divi/woocommerce-cross-sells` | Cross-Sells | cart cross-sell items |
| `divi/woocommerce-product-upsell` | Up-Sells | product upsell items |

### Single-product elements
| Slug | Module |
|------|--------|
| `divi/woocommerce-product-title` | Product Title |
| `divi/woocommerce-product-price` | Product Price |
| `divi/woocommerce-product-images` | Product Images (main image/badge) |
| `divi/woocommerce-product-gallery` | Product Gallery (grid of images) |
| `divi/woocommerce-product-description` | Product Description / short description |
| `divi/woocommerce-product-add-to-cart` | Add to Cart (qty + button) |
| `divi/woocommerce-product-meta` | Product Meta (SKU, categories, tags) |
| `divi/woocommerce-product-rating` | Star Rating |
| `divi/woocommerce-product-reviews` | Reviews + review form |
| `divi/woocommerce-product-stock` | Stock status |
| `divi/woocommerce-product-tabs` | Product Tabs (description / additional info / reviews) |
| `divi/woocommerce-product-additional-info` | Additional Information (attributes table) |
| `divi/woocommerce-breadcrumb` | Woo Breadcrumb trail |

### Cart
| Slug | Module |
|------|--------|
| `divi/woocommerce-cart-products` | Cart line items table |
| `divi/woocommerce-cart-totals` | Cart Totals + change-address |
| `divi/woocommerce-cart-notice` | Cart/shop notices |

### Checkout
| Slug | Module |
|------|--------|
| `divi/woocommerce-checkout-billing` | Billing fields |
| `divi/woocommerce-checkout-shipping` | Shipping fields |
| `divi/woocommerce-checkout-additional-info` | Additional info (order notes) — folder `checkout-information` |
| `divi/woocommerce-checkout-order-details` | Order review table |
| `divi/woocommerce-checkout-payment-info` | Payment methods |

---

## `divi/shop` — Woo Products grid

```json
{
  "content": {
    "advanced": {
      "type":           {"desktop": {"value": "recent"}},
      "postsNumber":    {"desktop": {"value": "12"}},
      "columnsNumber":  {"desktop": {"value": "0"}},
      "offsetNumber":   {"desktop": {"value": "0"}},
      "orderby":        {"desktop": {"value": "default"}},
      "useCurrentLoop": {"desktop": {"value": "off"}}
    }
  },
  "builderVersion": "5.8.1"
}
```
| Field (`content.advanced.*`) | Values |
|------|--------|
| `type` | `"recent"`, `"featured"`, `"sale"`, `"best_selling"`, `"top_rated"`, `"product_category"` |
| `postsNumber` | products to show (string) |
| `columnsNumber` | `"0"` = auto, or `"1"`–`"6"` |
| `orderby` | `"default"`, `"date"`, `"price"`, `"price-desc"`, `"popularity"`, `"rating"`, `"title"`, `"menu_order"` |
| `useCurrentLoop` | `"on"` to use the page's existing Woo query (archive/category templates) |

---

## Single-product element examples

### `divi/woocommerce-product-title`
```json
{
  "content": {"advanced": {"product": {"desktop": {"value": "dynamic"}}}},
  "title":   {"decoration": {"font": {"font": {"desktop": {"value": {"headingLevel": "h1"}}}}}},
  "builderVersion": "5.8.1"
}
```

### `divi/woocommerce-product-price`
```json
{
  "content": {"advanced": {"product": {"desktop": {"value": "dynamic"}}}},
  "builderVersion": "5.8.1"
}
```

### `divi/woocommerce-product-add-to-cart`
```json
{
  "content": {"advanced": {"product": {"desktop": {"value": "dynamic"}}}},
  "elements": {
    "advanced": {
      "showQuantity": {"desktop": {"value": "on"}},
      "showStock":    {"desktop": {"value": "on"}}
    }
  },
  "builderVersion": "5.8.1"
}
```

> Every other single-product element follows the same shape: `content.advanced.product = "dynamic"` (or a product ID) plus that module's own toggles/design groups. Button icons, field focus styling, and select-field colors all use the standard decoration + pseudo-class systems (STYLING §10c).

---

## `divi/woocommerce-related-products`
```json
{
  "content": {
    "advanced": {
      "product":       {"desktop": {"value": "dynamic"}},
      "postsNumber":   {"desktop": {"value": "dynamic"}},
      "columnsNumber": {"desktop": {"value": "dynamic"}},
      "offsetNumber":  {"desktop": {"value": "0"}},
      "orderby":       {"desktop": {"value": "default"}}
    }
  },
  "builderVersion": "5.8.1"
}
```
`"dynamic"` for count/columns = inherit WooCommerce theme defaults. "Included Categories → All Categories" uses all product categories; "Current Category" restricts to the current product's categories.

---

## Cart & checkout modules

These render the live WooCommerce cart/checkout for the current session and have minimal required attrs — typically just `builderVersion` plus design groups:

```json
{ "builderVersion": "5.8.1" }
```

**✓ Render-confirmed (scenarios 30/31)** with a populated session cart (2 line items):
- `cart-notice` → "added to your cart" notices; `cart-products` → line-item table (product/price/qty/subtotal, coupon, update); `cart-totals` → subtotal/total + Proceed to checkout; `cross-sells` → "You may be interested in…" using the cart items' cross-sell products.
- `checkout-billing` → full billing form (name/country/address/city/state/postcode/phone/email); `checkout-additional-info` → order-notes textarea; `checkout-order-details` → "Your order" review table incl. a **Shipment** line when a shipping method exists; `checkout-payment-info` → enabled payment gateways (e.g. Cash on Delivery) + Place order.
- `checkout-shipping` renders but shows fields only when "ship to a different address" is toggled / shipping is configured (standard WC behavior).

**To render them you need a cart context:** the actual WC **Cart**/**Checkout** pages, or a **Cart/Checkout Theme Builder template**, or any page viewed in a session whose cart is non-empty. See the insert-time gotcha in the status note above for programmatic creation.

Notable design hooks (from 5.x fixes): checkout billing/shipping **select fields** honor Fields text colors and focus borders; cart-totals change-address fields apply focus styling; Woo Notice buttons render configured icons and a default white button background.

---

## Coverage note

The WooCommerce family is **fully render-confirmed (5.7.0)** against fixture products with gallery images, managed stock, reviews, sale prices, and upsell/cross-sell relationships, plus a live session cart and checkout (scenarios 29–31). Modules whose output depends on store data/config (gallery, rating, stock, reviews, upsell/related/cross-sell, shipping line, payment methods) show that output only when the data/config exists.

---

*DIVI5 WooCommerce Modules Skill — V0.6.0 | Builder Version 5.8.1 | Created by Shashank Gupta @ divilove.com*
