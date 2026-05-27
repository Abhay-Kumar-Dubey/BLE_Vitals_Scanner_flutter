import 'dart:async';

import 'package:ble_vitals_scanner/app/services/ble_services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class ConnectedDeviceController extends GetxController {
  final BleServices _bleServices = BleServices();

  RxList<DiscoveredDevice> devices = <DiscoveredDevice>[].obs;

  RxBool isScanning = false.obs;
  RxString connectionState = "Disconnected".obs;

  String deviceId = Get.arguments['deviceId'];

  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  final count = 0.obs;
  @override
  void onInit() {
    connectToDevice(deviceId);
    super.onInit();
  }

  void connectToDevice(String deviceId) async {
    /// cancel previous connection
    _connectionSubscription?.cancel();

    _connectionSubscription = _bleServices
        .connectToDevice(deviceId)
        .listen(
          (update) {
            print(update.connectionState);

            connectionState.value = update.connectionState.name;

            if (update.connectionState == DeviceConnectionState.connected) {
              print("Connected");
              _bleServices.discoverDeviceServices(deviceId);
            }
            ;

            if (update.connectionState == DeviceConnectionState.disconnected) {
              print("Disconnected");
            }
          },
          onError: (error) {
            print(error);

            connectionState.value = "Error";
          },
        );
  }
}
