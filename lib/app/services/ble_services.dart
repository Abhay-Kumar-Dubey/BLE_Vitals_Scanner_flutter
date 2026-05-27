import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BleServices {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  /// List of discovered devices
  final List<DiscoveredDevice> discoveredDevices = [];

  /// Start scanning
  void startScan({
    required Function(List<DiscoveredDevice>) onDeviceFound,
    required Function(String error) onError,
  }) {
    discoveredDevices.clear();

    _scanSubscription?.cancel();

    _scanSubscription = _ble
        .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
        .listen(
          (device) {
            final alreadyExists = discoveredDevices.any(
              (d) => d.id == device.id,
            );

            if (!alreadyExists) {
              discoveredDevices.add(device);

              print("Found Device:");
              print("Name: ${device.name}");
              print("Id: ${device.id}");

              onDeviceFound(discoveredDevices);
            }
          },
          onError: (error) {
            print("Scan Error: $error");
            onError(error.toString());
          },
        );
  }

  /// Stop scanning
  Future<void> stopScan() async {
    await _scanSubscription?.cancel();
  }

  /// Connect to a selected device
  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    );
  }

  Future<void> discoverDeviceServices(String deviceId) async {
    try {
      final services = await _ble.discoverServices(deviceId);

      for (final service in services) {
        print("================================");
        print("SERVICE UUID: ${service.serviceId}");

        for (final characteristic in service.characteristics) {
          print("Characteristic UUID: ${characteristic.characteristicId}");

          print("Readable: ${characteristic.isReadable}");
          print(
            "WritableWithResponse: ${characteristic.isWritableWithResponse}",
          );
          print(
            "WritableWithoutResponse: ${characteristic.isWritableWithoutResponse}",
          );
          print("Notifiable: ${characteristic.isNotifiable}");
          print("Indicatable: ${characteristic.isIndicatable}");

          print("--------------------------------");
        }
      }
    } catch (e) {
      print("Discover Error: $e");
    }
  }

  /// Disconnect
  Future<void> dispose() async {
    await _scanSubscription?.cancel();
  }
}
