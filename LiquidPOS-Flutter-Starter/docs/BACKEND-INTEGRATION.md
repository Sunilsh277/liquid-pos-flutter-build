# Liquid POS backend integration layer

This stage adds a small Dart HTTP client and repository for the Convex public query/mutation endpoints. It does not claim the app is live-connected yet.

## Files
- `lib/backend/convex_http_client.dart`: POSTs queries/mutations to `/api/query` and `/api/mutation`, supplies a signed-in user's JWT as a bearer token, and handles common response/error cases.
- `lib/backend/liquid_pos_repository.dart`: maps the actual public function paths found in the supplied Convex source for menu items/categories, tables, kitchen board, recent/open orders and inventory summary.
- `lib/config/backend_config.dart`: reads public deployment/auth configuration using `--dart-define`.

## Critical requirements before live testing
1. Use the real Convex deployment URL. Do not use `localhost` or guess a deployment.
2. Complete Hercules OIDC login in Flutter and pass the user's access token to `ConvexHttpClient`. The OIDC authority/client ID alone do not authenticate requests.
3. Confirm Convex accepts the issuer/audience and the user has staff/area permissions. The existing functions call `requireStaff` / `requireArea`; this is intentional.
4. Verify every function's exact argument schema before invoking mutations. In particular, placing an order requires validated line structures, payment method, discount and order type; do not submit guessed payloads.
5. Add automated tests and device tests before production use.

## Configuration
Use only public values: `CONVEX_URL`, `OIDC_AUTHORITY`, `OIDC_CLIENT_ID`. Never ship client secrets, admin keys or static tokens inside an APK.

## Source-derived function paths
- `menu/items:list`
- `menu/categories:list`
- `tables/tables:list`
- `kitchen/tickets:board`
- `orders/queries:listRecent`
- `orders/open:list`
- `inventory/summary:summary`

These are based on the uploaded `convex/_generated/api.d.ts` and module exports. The service uses the HTTP API rather than an official Dart Convex SDK; validate protocol compatibility against the deployed Convex version before production.

## Native menu model and cart foundation (added)

- `lib/models/menu_item.dart` maps Convex `menuItems` and `menuCategories` documents to typed Dart models.
- `lib/models/cart_line.dart` calculates quantities, selected variants and add-ons in integer paise, matching `convex/schema/menu.ts` and the existing pricing convention. The legacy backend field name `priceCents` actually stores paise in this app.
- `test/menu_item_test.dart` covers JSON mapping and exact cart arithmetic.

These are client-side foundations only; they do not claim live menu loading or order placement. The existing backend requires a valid signed-in user token and a production Convex deployment URL. Do not ship a Convex admin key in the app. The current HTTP helper should be verified against the deployment and Convex's supported client/auth behavior before production use; the original React app uses Convex's reactive JavaScript client, which is not equivalent to a generic REST API.

## Authentication constraint

The web app's redirect defaults to `${window.location.origin}/auth/callback`. A native OIDC redirect must be registered with the Hercules identity provider before Flutter AppAuth can be tested. Do not assume a custom URI is authorized. Once the authorized redirect is known, implement PKCE authorization-code flow and store refresh/access tokens only in platform-secure storage.
