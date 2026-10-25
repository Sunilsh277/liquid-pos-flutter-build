import 'package:flutter/services.dart';

/// Flutter-facing contract for the native Android printer implementation.
/// The MethodChannel must be registered in Flutter's Android MainActivity;
/// the existing Capacitor plugin cannot be called directly from Flutter.
class NativePrinterService {
  NativePrinterService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('app.hercules.liquidposupdated264071/printer');
  final MethodChannel _channel;

  Future<List<Map<String, dynamic>>> discoverBluetooth() async {
    final result = await _channel.invokeMethod<List<dynamic>>('discoverBluetooth');
    return (result ?? const []).whereType<Map>().map((e) => Map<String,dynamic>.from(e)).toList();
  }

  Future<void> connectBluetooth(String address) =>
      _channel.invokeMethod<void>('connectBluetooth', {'address': address});

  Future<void> printBluetooth({required String address, required List<int> bytes}) =>
      _channel.invokeMethod<void>('printBluetooth', {'address': address, 'bytes': bytes});

  Future<List<Map<String, dynamic>>> discoverUsb() async {
    final result = await _channel.invokeMethod<List<dynamic>>('discoverUsb');
    return (result ?? const []).whereType<Map>().map((e) => Map<String,dynamic>.from(e)).toList();
  }

  Future<void> printUsb({required String deviceId, required List<int> bytes}) =>
      _channel.invokeMethod<void>('printUsb', {'deviceId': deviceId, 'bytes': bytes});
}
