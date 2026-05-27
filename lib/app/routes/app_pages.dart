import 'package:get/get.dart';

import '../modules/connected_device/bindings/connected_device_binding.dart';
import '../modules/connected_device/views/connected_device_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTED_DEVICE,
      page: () => const ConnectedDeviceView(),
      binding: ConnectedDeviceBinding(),
    ),
  ];
}
