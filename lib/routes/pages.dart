import 'package:attendance_app/modules/maps/maps_binding.dart';
import 'package:attendance_app/modules/maps/maps_view.dart';
import 'package:attendance_app/routes/routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.maps,
      page: () => const MapsView(),
      binding: MapsBinding(),
    ),
  ];
}
