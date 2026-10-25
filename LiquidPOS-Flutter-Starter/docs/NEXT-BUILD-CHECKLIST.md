# Next build checklist

1. Install Flutter SDK and Android Studio on a Windows computer.
2. Generate a standard project: `flutter create --platforms=android --org app.hercules.liquidposupdated264071 liquid_pos_flutter`.
3. Copy this package's `lib/`, `test/`, and `pubspec.yaml` into the generated project (review rather than blindly overwrite generated Android files).
4. Run `flutter pub get`, `flutter analyze`, `flutter test`.
5. Merge the documented native Java bridge and Android permissions from the native source files.
6. Build: `flutter build apk --debug --dart-define=CONVEX_URL=https://steady-warbler-507.convex.cloud`.
7. Fix all build errors, then test login/backend and Bluetooth/USB/vibration on the actual device.

This package is source scaffolding, not a compiled or tested APK. Keep the current Hercules app installed as fallback.

8. Before building, review `docs/BACKEND-SOURCE-AUDIT.md`; the sales report function path has been corrected to `reports/sales:summary`.
9. Verify the paired `.convex.cloud` client URL in the deployment dashboard; the screenshot directly confirms only the `.convex.site` HTTP Actions URL.
