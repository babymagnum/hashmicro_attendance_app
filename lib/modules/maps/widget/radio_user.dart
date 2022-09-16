import 'dart:developer';

import 'package:attendance_app/data/master_data/master_data.dart';
import 'package:attendance_app/data/model/location.dart';
import 'package:attendance_app/modules/maps/maps_controller.dart';
import 'package:attendance_app/modules/maps/widget/real_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RadioUser extends GetView<MapsController> {
  final Location location;

  const RadioUser({Key? key, required this.location}) : super(key: key);

  onChangeUser(String value) {
    controller.selectedUserId(value);

    if (value == REAL_USER) {
      controller.googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: controller.realUserLocation.value.latLng, zoom: 15)));
      controller.selectedUser = controller.realUserLocation.value;
    } else {
      final selectedUser = masterUserLocation.firstWhere((element) => element.id == value);
      controller.googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: selectedUser.latLng, zoom: 15)));
      controller.selectedUser = selectedUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChangeUser(location.id),
      child: Row(
        children: [
          Obx(() => Radio<String>(
              value: location.id,
              groupValue: controller.selectedUserId.value,
              onChanged: (String? value) => onChangeUser(value ?? ''),
            ),
          ),
          const SizedBox(width: 10,),
          Flexible(child: Text(location.name))
        ],
      ),
    );
  }
}
