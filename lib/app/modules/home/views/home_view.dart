import 'package:ble_vitals_scanner/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.bluetooth),
        title: const Text('BLE Scanner'),
        centerTitle: true,
        actions: [
          Obx(() {
            return controller.isScanning.value
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text('Scanning..'),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "Total Devices Found",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Obx(() => Text('${controller.deviceFound}')),
                  ],
                ),
              ),
            ),
          ),
          // Obx(
          //   () => ElevatedButton(
          //     onPressed: controller.isScanning.value
          //         ? controller.stopScan
          //         : controller.startScan,
          //     child: Text(
          //       controller.isScanning.value ? "Stop Scan" : "Start Scan",
          //     ),
          //   ),
          // ),
          Expanded(
            child: Center(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 5,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller.stopScan;
                          Get.toNamed(
                            Routes.CONNECTED_DEVICE,
                            arguments: {
                              "deviceId": device.id,
                              "deviceName": device.name,
                              "deviceRssi": device.rssi,
                              "deviceAddress": device.id,
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.blue),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Icon(Icons.bluetooth_audio_rounded),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      device.name.isNotEmpty
                                          ? device.name
                                          : "Unknown Device",
                                    ),
                                    Text(device.id),
                                  ],
                                ),
                                Text(device.rssi.toString()),
                                Icon(Icons.arrow_forward_ios_sharp),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    // return ListTile(
                    //   title: Text(
                    //     device.name.isNotEmpty ? device.name : "Unknown Device",
                    //   ),
                    //   subtitle: Text(device.id),
                    //   onTap: () {
                    //     controller.stopScan;
                    //     Get.toNamed(
                    //       Routes.CONNECTED_DEVICE,
                    //       arguments: {"deviceId": device.id},
                    //     );
                    //   },
                    // );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          controller.startScan();

          Future.delayed(const Duration(seconds: 6), () {
            controller.stopScan();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Obx(
              () =>
                  RotatingRefreshIcon(isScanning: controller.isScanning.value),
            ),
          ),
        ),
      ),
    );
  }
}

class RotatingRefreshIcon extends StatefulWidget {
  final bool isScanning;

  const RotatingRefreshIcon({super.key, required this.isScanning});

  @override
  State<RotatingRefreshIcon> createState() => _RotatingRefreshIconState();
}

class _RotatingRefreshIconState extends State<RotatingRefreshIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    if (widget.isScanning) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RotatingRefreshIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isScanning) {
      _animationController.repeat();
    } else {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animationController,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
