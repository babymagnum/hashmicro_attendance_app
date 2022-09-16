import 'package:attendance_app/modules/maps/maps_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RealUser extends StatelessWidget {
  RealUser({Key? key}) : super(key: key);

  final MapsController mapsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: mapsController.realUserMarkerKey,
      child: Column(
        children: [
          Image.asset('assets/images/png/real_user.png', width: 24, height: 24,),
          const SizedBox(height: 2,),
          const Text('Real User')
        ],
      ),
    );
  }
}
