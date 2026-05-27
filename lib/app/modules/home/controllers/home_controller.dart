import 'dart:async';

import 'package:ble_vitals_scanner/app/services/ble_services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final BleServices _bleServices = BleServices();

  RxList<DiscoveredDevice> devices = <DiscoveredDevice>[].obs;

  RxBool isScanning = false.obs;
  RxString connectionState = "Disconnected".obs;

  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  void startScan() {
    isScanning.value = true;

    _bleServices.startScan(
      onDeviceFound: (deviceList) {
        devices.assignAll(deviceList);
      },
      onError: (error) {
        Get.snackbar("Error", error);
      },
    );
  }

  void stopScan() async {
    isScanning.value = false;
    await _bleServices.stopScan();
    isScanning.value = false;
  }

  @override
  void onClose() {
    _bleServices.dispose();
    super.onClose();
  }
}
