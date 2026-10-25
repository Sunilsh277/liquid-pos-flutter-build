# Liquid POS Flutter native rebuild — starter

This is the separate Flutter project for rebuilding Liquid POS with native-rendered Flutter screens. It is **not yet a complete replacement APK** and has not been compiled in this workspace.

## Current contents

- Responsive starter dashboard and register preview.
- Separate configuration class for Convex/OIDC public configuration.
- Backend operation map based on the supplied Hercules Convex source.
- Source analysis and integration/security notes.

## Configuration

The Hercules screenshot confirms the Production HTTP Actions URL (`https://steady-warbler-507.convex.site`). The normal client deployment URL (`*.convex.cloud`) is not yet directly confirmed, so `CONVEX_URL` intentionally defaults to blank. Do not use the HTTP Actions URL for `/api/query` or `/api/mutation` calls, and do not use an inferred URL in production.

Once the correct values are available, run the app with public configuration values, for example:

```bash
flutter run \
  --dart-define=CONVEX_URL=https://YOUR-CONFIRMED-DEPLOYMENT.convex.cloud \
  --dart-define=OIDC_AUTHORITY=https://YOUR-AUTHORITY.hercules-auth.com \
  --dart-define=OIDC_CLIENT_ID=YOUR_PUBLIC_CLIENT_ID
```

These values only configure the app; they do **not** implement a working Convex client or OIDC login by themselves. Before live backend integration, choose/verify a supported Flutter Convex client and compatible OIDC authentication transport. Never put a Convex admin key, client secret, or access token in the app.

## Next implementation phases

1. Confirm the supported Flutter/Dart Convex client and authentication flow.
2. Implement real menu/category queries and loading/error states.
3. Implement cart using integer cents and connect order mutations.
4. Port tables and kitchen board; preserve backend authorization rules.
5. Port inventory, reports, staff and settings.
6. Bridge the working Java Bluetooth/USB printer and vibration code into Flutter, then device-test.
7. Build and sign release APK/AAB on a machine with Flutter + Android SDK installed.

Keep the existing Hercules app and working native wrapper as the production fallback until the new app has passed real-order and printer testing.


## Backend integration layer (in progress)
See `docs/BACKEND-INTEGRATION.md`. A Dart Convex HTTP client and repository layer have been added using public function paths from the supplied source. Live operation still requires the actual deployment URL and an OIDC sign-in flow that yields a valid user token. No production connection or APK build has been verified in this workspace.

## Latest development status

Typed Convex menu/category models and paise-safe cart arithmetic are included, with unit tests. Live authentication and live data are still pending because the native OIDC redirect must be supported by the existing Hercules client configuration and the production Convex URL must be supplied at build/run time. This is source code, not a verified APK.


## Latest development increment

This increment adds live-data table and kitchen widgets, repository methods for reservation and kitchen ticket status changes, and a Flutter MethodChannel contract for porting the tested Android printer implementation. See `docs/TABLES-KITCHEN-PRINTER-PORT.md`. These screens require an authenticated repository; the printer channel still needs its Android-side Flutter implementation and device verification.

## Backend source audit

See `docs/BACKEND-SOURCE-AUDIT.md` for function-path checks against the supplied Convex source. This is a static audit only; live backend/authentication and Flutter compilation are not yet verified.

## Cloud build (GitHub Actions)

See [`docs/CLOUD-BUILD-GITHUB.md`](docs/CLOUD-BUILD-GITHUB.md). The workflow under `.github/workflows/build-android.yml` creates a standard Android Flutter project on GitHub-hosted infrastructure, runs `flutter pub get`, `flutter analyze`, `flutter test`, and attempts a debug APK build. This only verifies/builds the current scaffold; it is not a production-ready POS or verified printer/backend integration.
