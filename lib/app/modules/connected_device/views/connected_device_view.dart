import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

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
        child: Column(
          children: [
            Obx(() {
              return Text(controller.connectionState.value);
            }),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.services.length,
                  itemBuilder: (_, index) {
                    final service = controller.services[index];

                    return ExpansionTile(
                      title: Text(service.serviceId.toString()),
                      children: service.characteristics.map((c) {
                        return ListTile(
                          title: Text(c.characteristicId.toString()),
                          subtitle: c.isReadable
                              ? FutureBuilder<List<int>>(
                                  future: controller.readCharacteristic(
                                    service.serviceId,
                                    c.characteristicId,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text(
                                        "Reading characteristic...",
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("""
            Readable: ${c.isReadable}
            Writable: ${c.isWritableWithResponse}
            Notifiable: ${c.isNotifiable}
            Error: ${snapshot.error}
            """);
                                    } else if (snapshot.hasData) {
                                      return Text("""
            Readable: ${c.isReadable}
            Writable: ${c.isWritableWithResponse}
            Notifiable: ${c.isNotifiable}
            Value: ${snapshot.data}
            """);
                                    } else {
                                      return Text("""
            Readable: ${c.isReadable}
            Writable: ${c.isWritableWithResponse}
            Notifiable: ${c.isNotifiable}
            """);
                                    }
                                  },
                                )
                              : c.isNotifiable
                                  ? StreamBuilder<List<int>>(
                                      stream:
                                          controller.subscribeToCharacteristic(
                                        service.serviceId,
                                        c.characteristicId,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text(
                                            "Waiting for notifications...",
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("""
            Readable: ${c.isReadable}
            Writable: ${c.isWritableWithResponse}
            Notifiable: ${c.isNotifiable}
            Error: ${snapshot.error}
            """);
                                        } else if (snapshot.hasData) {
                                          return Text("""
            Readable: ${c.isReadable}
            Writable: ${c.isWritableWithResponse}
            Notifiable: ${c.isNotifiable}
            Value: ${snapshot.data}
            """);
                                        } else {
                                          return Text("""
            Readable: ${c.isReadable}
            Writable: ${c.isWritableWithResponse}
            Notifiable: ${c.isNotifiable}
            """);
                                        }
                                      },
                                    )
                                  : Text("""
            Readable: ${c.isReadable}
            Writable: ${c.isWritableWithResponse}
            Notifiable: ${c.isNotifiable}
            """),
                        );
                      }).toList(),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
