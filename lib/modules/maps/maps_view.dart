import 'package:attendance_app/data/master_data/master_data.dart';
import 'package:attendance_app/modules/maps/maps_controller.dart';
import 'package:attendance_app/modules/maps/widget/radio_user.dart';
import 'package:attendance_app/modules/maps/widget/real_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends GetView<MapsController> {
  const MapsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), offset: const Offset(-4, -4), spreadRadius: 0, blurRadius: 8
            )
          ]
        ),
        child: ElevatedButton(
          onPressed: () => controller.attendance(),
          child: const Text(
            'Online Attendance',
            textAlign: TextAlign.center,
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            primary: Colors.blue,
          ),
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            Positioned(child: RealUser(), top: -200,),
            Positioned.fill(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: const CameraPosition(target: LatLng(-6.175328396028417, 106.82717425548299), zoom: 15),
                onMapCreated: (GoogleMapController _controller) {
                  controller.googleMapController = _controller;
                },
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: controller.markers.values.toSet(),
              ),
            ),
            Positioned(
              bottom: 0, right: 0, left: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [...masterUserLocation.map((e) {
                    return RadioUser(location: e);
                  }).toList(),
                    ...[
                      RadioUser(location: controller.realUserLocation.value)
                    ]],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
