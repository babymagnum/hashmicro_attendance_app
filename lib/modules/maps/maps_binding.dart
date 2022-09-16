import 'package:attendance_app/modules/maps/maps_controller.dart';
import 'package:get/instance_manager.dart';

class MapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapsController());
  }
}