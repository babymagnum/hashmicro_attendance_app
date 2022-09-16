import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:attendance_app/data/master_data/master_data.dart';
import 'package:attendance_app/data/model/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MapsController extends GetxController {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  var selectedUserId = INSIDE_MONAS.obs;
  var realUserLocation = Location(REAL_USER, 'Real User', const LatLng(-6.173974, 106.823323)).obs;

  GlobalKey realUserMarkerKey = GlobalKey();

  Location? selectedUser;
  GoogleMapController? googleMapController;
  StreamSubscription? locationStream;

  static Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }

  populateMarker() async {
    for (var element in masterAttendanceLocation) {
      final marker = Marker(
        markerId: MarkerId(element.name),
        position: element.latLng,
        infoWindow: InfoWindow(
          title: element.name,
        ),
      );

      markers[MarkerId(element.id)] = marker;
    }

    for (var element in masterUserLocation) {
      final marker = await getBytesFromAsset('assets/images/png/user.png', 100) != null ? Marker(
        markerId: MarkerId(element.name),
        position: element.latLng,
        icon: BitmapDescriptor.fromBytes((await getBytesFromAsset('assets/images/png/user.png', 100))!),
        infoWindow: InfoWindow(
          title: element.name,
        ),
      ) : Marker(
        markerId: MarkerId(element.name),
        position: element.latLng,
        infoWindow: InfoWindow(
          title: element.name,
        ),
      );

      markers[MarkerId(element.id)] = marker;
    }

    addRealUserMarker();
  }

  addRealUserMarker() async {
    RenderRepaintBoundary boundary = realUserMarkerKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) return;

    final realUserMarker = Marker(
      markerId: MarkerId(realUserLocation.value.id),
      position: realUserLocation.value.latLng,
      icon: BitmapDescriptor.fromBytes(byteData.buffer.asUint8List()),
      infoWindow: InfoWindow(
        title: realUserLocation.value.name,
      ),
    );

    markers[MarkerId(realUserLocation.value.id)] = realUserMarker;
  }

  streamLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    locationStream = Geolocator.getPositionStream().listen((Position position) {
      realUserLocation.value.latLng = LatLng(position.latitude, position.longitude);
      log('streamLocation ${realUserLocation.value.latLng.latitude}${realUserLocation.value.latLng.longitude}');

      addRealUserMarker();
    });
  }

  attendance() async {
    if (selectedUser == null) initUser();

    var inRadius = false;

    for (var element in masterAttendanceLocation) {
      final _distanceInMeters = Geolocator.distanceBetween(
        selectedUser!.latLng.latitude,
        selectedUser!.latLng.longitude,
        element.latLng.latitude,
        element.latLng.longitude,
      );
      
      if (_distanceInMeters <= 50) {
        inRadius = true;
        Get.snackbar('Sukses Absensi', '${element.name} ${element.latLng.latitude}, ${element.latLng.longitude}', backgroundColor: Colors.white, margin: const EdgeInsets.all(16));
        break;
      }
    }

    if (!inRadius) {
      Get.snackbar('Gagal Absensi', 'Anda tidak berada pada zona absensi', backgroundColor: Colors.white, margin: const EdgeInsets.all(16));
    }
  }
  
  initUser() {
    selectedUser = masterUserLocation.first;
  }

  @override
  void onInit() {
    initUser();
    
    streamLocation();

    populateMarker();

    super.onInit();
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    locationStream?.cancel();

    super.dispose();
  }
}