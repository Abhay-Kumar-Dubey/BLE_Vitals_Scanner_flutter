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
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back),
        ),
        title: const Text('Device Details'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  controller.deviceName.isNotEmpty
                                      ? controller.deviceName
                                      : "Unknown Device",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Obx(() {
                                  return Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color:
                                                controller
                                                        .connectionState
                                                        .value ==
                                                    'connected'
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(controller.connectionState.value),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  "SIGNAL",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(controller.deviceRssi),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(height: 1, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "MAC ADDRESS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // fontSize: 20,
                              ),
                            ),
                            Spacer(),
                            Text(controller.deviceId),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              controller.deviceName == 'TestBLEDevice'
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    "Counter",
                                    style: TextStyle(
                                      // fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: StreamBuilder(
                                    stream: controller
                                        .subscribeToCharacteristic(
                                          controller.serverUuid,
                                          controller.charUuid,
                                        ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          String.fromCharCodes(snapshot.data!),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                      return SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    "Temperature",
                                    style: TextStyle(
                                      // fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: StreamBuilder(
                                    stream: controller
                                        .subscribeToCharacteristic(
                                          controller.serverUuid,
                                          controller.tempUuid,
                                        ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          String.fromCharCodes(snapshot.data!),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Text(snapshot.error.toString());
                                      }
                                      return SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: ExpansionTile(
                    title: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.miscellaneous_services),
                            SizedBox(width: 9),
                            Text(
                              "Available Services",
                              style: TextStyle(
                                // fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    children: [
                      Obx(() {
                        if (controller.services.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("No services discovered yet..."),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.services.length,
                          itemBuilder: (_, index) {
                            final service = controller.services[index];

                            return ExpansionTile(
                              title: Text(service.serviceId.toString()),
                              children: service.characteristics.map((c) {
                                return ListTile(
                                  title: Text(c.characteristicId.toString()),
                                  subtitle: c.isNotifiable
                                      ? StreamBuilder<List<int>>(
                                          stream: controller
                                              .subscribeToCharacteristic(
                                                service.serviceId,
                                                c.characteristicId,
                                              ),
                                          builder: (context, snapshot) {
                                            print(
                                              "STREAM DATA: ${snapshot.data}",
                                            );
                                            print(
                                              "STREAM ERROR: ${snapshot.error}",
                                            );

                                            if (snapshot.hasError) {
                                              return Text("""
Readable: ${c.isReadable}
Writable: ${c.isWritableWithResponse}
Notifiable: ${c.isNotifiable}

Error: ${snapshot.error}
""");
                                            }

                                            if (!snapshot.hasData) {
                                              return Text("""
Readable: ${c.isReadable}
Writable: ${c.isWritableWithResponse}
Notifiable: ${c.isNotifiable}

Waiting for notifications...
""");
                                            }

                                            final decodedValue =
                                                String.fromCharCodes(
                                                  snapshot.data!,
                                                );

                                            return Text("""
Readable: ${c.isReadable}
Writable: ${c.isWritableWithResponse}
Notifiable: ${c.isNotifiable}

Raw: ${snapshot.data}

Decoded: $decodedValue
""");
                                          },
                                        )
                                      : c.isReadable
                                      ? FutureBuilder<List<int>>(
                                          future: controller.readCharacteristic(
                                            service.serviceId,
                                            c.characteristicId,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                "Error: ${snapshot.error}",
                                              );
                                            }

                                            if (!snapshot.hasData) {
                                              return const Text(
                                                "Reading characteristic...",
                                              );
                                            }

                                            return Text("""
Readable: ${c.isReadable}
Writable: ${c.isWritableWithResponse}
Notifiable: ${c.isNotifiable}

Value: ${String.fromCharCodes(snapshot.data!)}
""");
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
