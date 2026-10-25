# Backend source audit (25 October 2026)

This is a static comparison of the Flutter repository's function paths against the supplied Hercules Convex source files. It is not a live deployment test.

## Function paths confirmed in supplied source

- `menu/items:list` — `convex/menu/items.ts`, exported `list`
- `menu/categories:list` — `convex/menu/categories.ts`, exported `list`
- `tables/tables:list` — `convex/tables/tables.ts`, exported `list`
- `tables/tables:setReserved` — `convex/tables/tables.ts`, exported `setReserved`; args are `tableId` and `isReserved`
- `kitchen/tickets:board` — `convex/kitchen/tickets.ts`, exported `board`
- `kitchen/tickets:setStatus` — `convex/kitchen/tickets.ts`, exported `setStatus`; args are `ticketId` and `status`
- `orders/mutations:place` — `convex/orders/mutations.ts`, exported `place`; expects the source-defined order schema
- `orders/queries:listRecent` — `convex/orders/queries.ts`, exported `listRecent`
- `orders/open:list` — `convex/orders/open.ts`, exported `list`
- `inventory/summary:summary` — `convex/inventory/summary.ts`, exported `summary`
- `reports/sales:summary` — `convex/reports/sales.ts`, exported `summary`; requires ISO `from` and `to` strings

## Correction made

The Flutter repository previously called `reports/sales:report`. The supplied source exports `summary`, not `report`. The repository now calls `reports/sales:summary`.

## Remaining verification

- No live requests have been made from this source-only workspace.
- The `.convex.site` HTTP Actions URL is confirmed by the user screenshot. The paired `.convex.cloud` client URL remains inferred and should be confirmed in the deployment dashboard.
- OIDC issuer, client ID, redirect URI, and actual token acceptance must be verified in a built app. Never embed admin/deploy keys in the APK.
- Static function-name agreement does not prove argument compatibility, authorization, or live data correctness.
