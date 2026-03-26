# Overview

_This was the website for Swift Industries from 2010-2015._

Full-stack Rails ecommerce and marketing platform built for [Swift Industries](https://builtbyswift.com), a Seattle-based bike bags manufacturer.

## High Level Features

- order flow: product browsing → product customization → payment → shipping
- content management system for products, marketing pages, and 8 other models
- order management, order search, inventory management
- signup and pages for a community bikepacking event called Swift Campout

Built and maintained as a solo project. While in use, it was deployed to production on Heroku.

---

## Stack

| Layer      | Technology                                                   |
| ---------- | ------------------------------------------------------------ |
| Backend    | Ruby on Rails 4.2, Ruby 1.9.3                                |
| Database   | PostgreSQL, with Memcached for caching                       |
| Frontend   | AngularJS 1.2 (checkout + interactive features), jQuery, ERB |
| Payments   | Stripe                                                       |
| Shipping   | Postmaster API                                               |
| Hosting    | Heroku                                                       |
| Monitoring | New Relic                                                    |
| Email      | Mandrill                                                     |

Note: this was built in 2010-2015.

---

## Features

### Ecommerce

- Product catalog with three catalog types: standard products, accessories, and stock items
- Gift certificates sold as a purchasable item with automatic GUID generation and email delivery on checkout
- Products have independently priced parts, size variants, and color options — each with their own inventory counts
- Shopping cart persisted to `localStorage` (no server-side session or database cart)
- Checkout built as an Angular SPA within the Rails app: address entry, shipping rate selection, coupon/gift certificate application, and Stripe payment
- Orders assigned short random GUIDs (`SecureRandom.hex(4)`) for customer-facing order references
- Post-checkout: order confirmation email, admin notification email, gift certificate creation if applicable, inventory decrement

### Shipping

- Postmaster API integration for domestic and international shipping
- Real-time address validation and normalization before rate calculation
- Live rate fetching by carrier and service level: USPS, UPS; ground through overnight; international surface through express
- Shipment creation and tracking number capture from admin hub
- International orders: customs form fields (item descriptions, values, HS codes)
- Per-product flat-rate shipping as a fallback option

### Promotions

- **Coupons**: percent-off or cents-off, with optional date range validity windows, published/unpublished states
- **Gift certificates**: purchased as a product type, delivered by email with a GUID, redeemable at checkout with partial-use support (tracks original amount, remaining balance, amount applied per order)

### Wholesale

- Pre-approved dealer email list stored in the database
- On registration, email is checked against the list and the `wholesale` flag set automatically
- Wholesale users see separate pricing throughout the catalog (products, parts, colors, sizes all carry dual pricing)
- Admin hub shows dealers separately for management

### User Accounts

- Devise authentication: email/password, password reset, account lockout after failed attempts
- Users store a default shipping address, phone, and company info
- Addresses geocoded to latitude/longitude via Geocoder gem
- Order history view

### Admin Hub

- Order queue segmented by status: Not Shipped, Printed, Shipped, Deleted
- Full-text search across orders using pg_search: searches order GUID, customer name, email, phone, address, Stripe ID, and coupon code simultaneously
- Paginated "all orders" view
- Manual status updates, shipment creation, tracking number logging
- Inventory management: per-product and per-size-variant stock counts; products auto-set to Private when inventory hits zero
- CMS for pages, products, categories, colors, parts, sizes, testimonials, coupons, gift certificates, and pre-approved dealers
- Manual cache expiry controls for home page and Flickr photo sets

### Swift Campout

An annual bikecamping event run by Swift Industries. The app supports:

- User registration as a Campout attendee, with a nested camper profile capturing a structured Q&A (trip plans, gear, camp meals, crew name, etc.)
- Geocoded user locations plotted on an interactive Leaflet map
- Public/private profile toggle per attendee
- Nearby camper detection: finds other attendees within a 10-mile radius using Geocoder's `near` query
- Angular-powered map with markers and camper profile modals

### Content and Marketing

- Admin-managed CMS pages: rich text, Flickr photo set integration, video embedding, homepage featuring
- WordPress blog feed pulled and parsed via Nokogiri
- Twitter feed: hashtag search via Twitter REST API, cached
- Instagram feed: tag-based recent media via Instagram API, cached
- Flickr: photo lookup by tag, by set, and by individual photo ID; used for product galleries and page content; results aggressively cached

---

## Architecture Notes

### Checkout flow

The checkout is Angular, everything else is server-rendered Rails. Angular handles the multi-step form state, makes API calls to Rails endpoints for address validation (`/postmaster/validate`), shipping rates (`/postmaster/rates`), WA state tax (`/wa_state_taxes/rate`), coupon validation, and gift certificate lookup. It aggregates these into a live total before the user submits payment.

Payment tokenization happens client-side via Stripe.js — card data never touches the Rails server. The token is submitted with the order form and charged server-side.

### Caching by user role

Product and home pages are action-cached in four variants: admin, wholesale, signed-in, and anonymous. This avoids privilege leakage (wholesale pricing showing to regular users) while still serving cached HTML to the majority of unauthenticated traffic. Cache sweepers observe model changes and invalidate all four variants on update.

### Order search

The admin order search uses `pg_search` with a single scope across 13 fields. Searching by last name, email address, order GUID, or Stripe charge ID all hit the same endpoint.

### Postmaster adapter

The `PostmasterController` acts as an adapter between the Angular frontend and the Postmaster shipping API. It calls the API and returns structured JSON. The Angular `PostmasterService` treats it as a local API — the frontend has no direct knowledge of Postmaster.

### Flickr module

`app/modules/flickr.rb` wraps the `flickraw` gem with a caching layer. Photo sets, tag searches, and individual photo lookups are all cached in Memcached. The admin hub has a manual "expire Flickr cache" action for when photos are updated upstream.

---

## Database Schema Highlights

- `sales` — 25+ columns covering the full order: line items as JSON, shipping address, amounts (subtotal, shipping, tax, discount, total), coupon code, gift cert GUID and applied amount, Stripe charge ID, order status, GUID
- `products` — supports four `kind` values; carries dual pricing (`price` / `wholesale_price`); `related_products` stored as a serialized JSON array of IDs
- `parts` — has_and_belongs_to_many `colors`; each part carries its own wholesale pricing
- `sizes` — per-product size variants with independent inventory counts
- `gift_certificates` — tracks `amount`, `remaining_amount`, and `sale_id`; GUID-based lookup
- `coupons` — `discount_type` (percent/cents), `amount`, `valid_from` / `valid_to`, `published`
- `users` — Devise fields + `wholesale` boolean + `is_camper` boolean + geocoded `latitude` / `longitude` + `guid`
- `campers` — 1:1 with users; stores Campout Q&A responses and `public_profile` flag
- `shipments` — 1:many with sales; tracks Postmaster `shipment_id`, carrier, service, cost, tracking number
- `pages` — CMS content with `flickr_set_id`, `video_url`, `featured` boolean, `on_about_nav` boolean

---

## Third-Party Integrations

| Service    | Purpose                                                |
| ---------- | ------------------------------------------------------ |
| Stripe     | Payment processing                                     |
| Postmaster | Shipping rates, address validation, shipment creation  |
| Flickr     | Product and page photography                           |
| Twitter    | Hashtag feed on marketing pages                        |
| Instagram  | Hashtag feed on marketing pages                        |
| Geocoder   | User address to lat/long for Campout map               |
| Mandrill   | Transactional email (order confirmation, admin alerts) |
| New Relic  | Production performance monitoring                      |
| Memcachier | Memcached hosting on Heroku                            |
| WordPress  | Blog feed (parsed via Nokogiri, not a plugin)          |
