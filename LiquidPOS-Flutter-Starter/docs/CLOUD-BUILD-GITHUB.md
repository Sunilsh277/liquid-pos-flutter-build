# Build Liquid POS in the cloud (GitHub Actions)

This workflow runs Flutter, Dart analysis, tests, and a debug APK build on a GitHub-hosted Linux runner. It does not require Flutter on your phone.

## Important status and limits

- This source is a Flutter UI/scaffold, not feature-complete Liquid POS.
- The current workflow generates a standard Android Flutter project and copies in `lib/`, `pubspec.yaml`, and `test/` before building.
- It does **not** add the Capacitor Java printer implementation to Flutter. Bluetooth, USB, vibration, live login, and live Convex workflows are not validated by this build.
- The `.convex.site` URL from the Hercules screenshot is the HTTP Actions URL; do not use it as the normal Convex client URL. Leave `CONVEX_URL` unset until the `*.convex.cloud` URL is confirmed.
- A successful debug APK is for testing only, not a signed release APK.

## Beginner steps

1. Open `https://github.com` and sign in or create an account.
2. Create a **private** repository named `liquid-pos-flutter-build`.
3. On the repository page, choose **Add file → Upload files**. Extract this ZIP first, then upload the contents of the `LiquidPOS-Flutter-Starter` folder, including the hidden `.github` folder and its workflow file. Commit to the `main` branch. (If the website does not include hidden files in the upload, create `.github/workflows/build-android.yml` using the exact file from this package.)
4. Open the repository's **Actions** tab. Approve/enable Actions if GitHub asks.
5. Choose **Liquid POS Flutter Android build** on the left, then **Run workflow → Run workflow**.
6. Open the run. If a step fails, open that step and copy its error log. If it succeeds, scroll to **Artifacts** and download `liquid-pos-debug-apk`.

## How to read the result

- **Green/success:** download the APK artifact and install it only for a test. It is a starter UI, not the full production POS.
- **Red/failure:** open the failed step and use its log to fix the actual error before trying again.
- The workflow uploads an APK only if dependency resolution, analysis, tests, and APK compilation all pass.

Do not upload secrets, Convex admin keys, passwords, or access tokens into the repository. Keep the repository private while the source is being reviewed.
