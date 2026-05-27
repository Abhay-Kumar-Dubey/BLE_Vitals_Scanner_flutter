import 'package:ble_vitals_scanner/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Scanner'), centerTitle: true),
      body: Column(
        children: [
          Obx(
            () => ElevatedButton(
              onPressed: controller.isScanning.value
                  ? controller.stopScan
                  : controller.startScan,
              child: Text(
                controller.isScanning.value ? "Stop Scan" : "Start Scan",
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];

                    return ListTile(
                      title: Text(
                        device.name.isNotEmpty ? device.name : "Unknown Device",
                      ),
                      subtitle: Text(device.id),
                      onTap: () {
                        Get.toNamed(
                          Routes.CONNECTED_DEVICE,
                          arguments: {"deviceId": device.id},
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
