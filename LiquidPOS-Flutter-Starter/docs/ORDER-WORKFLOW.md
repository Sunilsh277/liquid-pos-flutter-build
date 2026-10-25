# Order workflow integration (source-mapped)

This stage adds `PlaceOrderRequest` and `LiquidPosRepository.placeOrder()` mapped to the supplied Convex function `orders/mutations.ts` (`place`).

## Important behavior
- The client sends item IDs, selected variant names, add-on names, and quantities. It does **not** submit trusted prices; the existing Convex mutation recalculates prices from the live menu.
- Dine-in requires a table ID.
- Delivery requires a customer name and a valid phone number.
- `due` payment requires customer name and phone.
- Prices are integer paise in the current application, although the existing schema retains legacy field names such as `priceCents` and `tipCents`.
- Convex still checks staff access and register permissions.

## Exact function mapping
- Menu list: `menu/items:list`
- Category list: `menu/categories:list`
- Table list: `tables/tables:list`
- Place order: `orders/mutations:place`
- Open orders: `orders/open:list`
- Recent orders: `orders/queries:listRecent`

## Still required before live use
1. A valid deployment URL supplied at build time (`--dart-define=CONVEX_URL=...`).
2. A tested OIDC login flow that obtains a user JWT accepted by the Convex auth configuration. Do not hard-code a token or use a Convex admin key in the mobile app.
3. Verify the Convex HTTP request format against the target deployment and test the exact function names against the deployed functions.
4. Connect the Flutter register UI to this repository and handle loading, errors, duplicate-submit prevention, and successful order confirmation.
5. Run `flutter analyze`, unit tests, build APK, and test on the target Android device. This environment does not have Flutter/Android SDK available, so no build success is claimed here.
