import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/connected_device_controller.dart';

class ConnectedDeviceView extends GetView<ConnectedDeviceController> {
  const ConnectedDeviceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConnectedDeviceView'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() {
          return Text(controller.connectionState.value);
        }),
      ),
    );
  }
}
