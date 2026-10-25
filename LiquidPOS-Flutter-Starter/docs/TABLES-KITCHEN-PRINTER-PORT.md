# Tables, kitchen board, and printer port

## Backend functions checked in the supplied Convex source

- `tables/tables:list` returns table records including `name`, `seats`, `shape`, `isReserved`, and optional `draft`.
- `tables/tables:setReserved` accepts `{ tableId, isReserved }` and enforces the user's tables-area permission.
- `kitchen/tickets:board` returns an object with `new`, `preparing`, and `ready` arrays (not a flat list).
- `kitchen/tickets:setStatus` accepts `{ ticketId, status }`, where status is `new`, `preparing`, `ready`, or `served`, and synchronizes the related order.

The Flutter repository now models the kitchen board as these three columns and exposes the reservation/status mutations. `TablesScreen` and `KitchenScreen` are live-data widgets that require a `LiquidPosRepository` created from a real authenticated session. They deliberately show request errors rather than fake data.

## Native printer integration

`lib/services/native_printer_service.dart` defines the Flutter `MethodChannel` contract:

- `discoverBluetooth`
- `connectBluetooth(address)`
- `printBluetooth(address, bytes)`
- `discoverUsb`
- `printUsb(deviceId, bytes)`

The existing Android wrapper's printer code is implemented as a Capacitor plugin. Flutter cannot invoke a Capacitor plugin directly. Port the existing `LuminaPrinterBridge`, `BluetoothDiscovery`, `UsbPrinters`, and `SocketPrinter` implementation behind this Flutter channel in the Flutter project's Android `MainActivity` (or a registered Flutter plugin). Do not copy the Capacitor `Plugin` class unchanged. Retain the original Bluetooth and USB permissions and handle Android runtime permissions and USB attach/device permission flows.

The channel contract is a boundary definition, not proof that native printing is already connected to Flutter. Run device tests for Bluetooth scan/connect/print, USB permission/print, disconnect/reconnect, and receipt formatting before replacing the current production app.

## Current status

- Tables and kitchen UI source has been added, but the application shell still needs an authenticated repository/session provider to instantiate these screens.
- The Convex URL and OIDC client setup must be supplied by the real deployment configuration; do not guess it or use a privileged API key in the app.
- Flutter SDK is not available in the authoring environment, so `flutter analyze`, unit tests, and APK build must be run in Android Studio/Flutter SDK environment.
