# Liquid POS source analysis (from supplied Hercules archive)

## Existing stack

- Frontend: React + TypeScript + Vite.
- Backend: Convex (`convex` package in package.json; functions under `convex/`).
- Auth: `@usehercules/auth`, `oidc-client-ts`, `react-oidc-context`; Convex provider is configured in `convex/auth.config.ts` using `HERCULES_OIDC_AUTHORITY` and `HERCULES_OIDC_CLIENT_ID`.
- Existing frontend reads `import.meta.env.VITE_CONVEX_URL` in `src/lib/convex-client.ts` and falls back to `http://localhost:3000`. That fallback is for local development, not a production URL.
- Existing printer-related code is in `src/lib/printer-transport.ts`, `printer-usb.ts`, `printer-bluetooth.ts`, and `printer-bridge.ts`; the separate Android wrapper contains the tested Java native bridges.

## Backend areas discovered

- Menu: `convex/menu/items.ts`, `categories.ts`, `settings.ts`.
- Orders and payment: `convex/orders/open.ts`, `mutations.ts`, `queries.ts`, `payments.ts`, `history.ts`, `lines.ts`, `pricing.ts`, `handover.ts`.
- Tables: `convex/tables/tables.ts`.
- Kitchen: `convex/kitchen/tickets.ts`, `sync.ts`, `helpers.ts`.
- Inventory: `convex/inventory/catalog.ts`, `levels.ts`, `materials.ts`, `purchases.ts`, `recipes.ts`, `usage.ts`, `waste.ts`, `expiry.ts`, `summary.ts`, `report.ts`, `deduct.ts`.
- Printing: `convex/printing/printers.ts`, `assignments.ts`, `settings.ts`, `jobs.ts`, `validate.ts`.
- Staff and auth: `convex/staff/members.ts`, `access.ts`, `roles.ts`, `convex/auth.config.ts`.
- Reports and dues: `convex/reports/sales.ts`, `aggregate.ts`, `convex/dues/dues.ts`.

## Connection status and security

The source archive has the variable *names* but no production `VITE_CONVEX_URL` value. The database snapshot is data, not a live deployment address or a backend server. Do not guess a URL, import the snapshot into a new production database, or use a Convex admin key in a mobile app.

The Flutter project exposes compile-time configuration via `--dart-define` but does not yet connect. Before implementing live data, verify the official supported Flutter/Dart Convex client and OIDC-compatible auth flow. The web client relies on Convex reactive queries/mutations and Hercules OIDC; an arbitrary REST request is not a drop-in replacement.

## Important implementation rules

1. Reuse the existing Convex deployment and function names when available.
2. Keep authorization in Convex functions; never embed admin keys/secrets in Flutter.
3. Keep the current Hercules app and Android printer wrapper intact until the Flutter replacement is tested.
4. Port money as integer cents (`priceCents`, `tipCents`, etc.) to avoid floating-point billing errors.
5. Treat any screen with placeholder data as a preview only; don't create fake production orders.
