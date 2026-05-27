import 'dart:async';

import 'package:ble_vitals_scanner/app/services/ble_services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class ConnectedDeviceController extends GetxController {
  final BleServices _bleServices = BleServices();

  RxList<DiscoveredDevice> devices = <DiscoveredDevice>[].obs;

  RxBool isScanning = false.obs;
  RxString connectionState = "Disconnected".obs;
  RxList<DiscoveredService> services = <DiscoveredService>[].obs;

  String deviceId = Get.arguments['deviceId'];

  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  
  // Store characteristic streams to avoid multiple subscriptions
  final Map<String, Stream<List<int>>> _characteristicStreams = {};

  final count = 0.obs;
  
  @override
  void onInit() {
    connectToDevice(deviceId);
    super.onInit();
  }

  @override
  void onClose() {
    _connectionSubscription?.cancel();
    _characteristicStreams.clear();
    super.onClose();
  }

  Future<List<int>> readCharacteristic(
      Uuid serviceId, Uuid characteristicId) async {
    return await _bleServices.readCharacteristic(
      deviceId,
      serviceId,
      characteristicId,
    );
  }

  Stream<List<int>> subscribeToCharacteristic(
      Uuid serviceId, Uuid characteristicId) {
    final key = '${serviceId}_${characteristicId}';
    
    // Return existing stream if already subscribed
    if (_characteristicStreams.containsKey(key)) {
      return _characteristicStreams[key]!;
    }

    // Create new broadcast stream
    final stream = _bleServices
        .subscribeToCharacteristic(deviceId, serviceId, characteristicId)
        .asBroadcastStream();
    
    _characteristicStreams[key] = stream;
    return stream;
  }

  Future<void> discoverServices(String deviceId) async {
    try {
      print("Starting service discovery...");
      final result = await _bleServices.discoverServices(deviceId);
      print("Discovered ${result.length} services");

      services.assignAll(
        result
            .map(
              (service) => DiscoveredService(
                serviceId: service.id,
                characteristics: service.characteristics
                    .map(
                      (char) => DiscoveredCharacteristic(
                        characteristicId: char.id,
                        serviceId: service.id,
                        characteristicInstanceId: char.id.toString(),
                        isReadable: char.isReadable,
                        isWritableWithResponse: char.isWritableWithResponse,
                        isWritableWithoutResponse: char.isWritableWithoutResponse,
                        isNotifiable: char.isNotifiable,
                        isIndicatable: char.isIndicatable,
                      ),
                    )
                    .toList(),
                characteristicIds: service.characteristics
                    .map((characteristic) => characteristic.id)
                    .toList(),
                serviceInstanceId: service.id.toString(),
              ),
            )
            .toList(),
      );
      print("Services assigned to observable list: ${services.length}");
    } catch (e) {
      print("Error discovering services: $e");
    }
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
              discoverServices(deviceId);
            }

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
