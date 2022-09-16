import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  String id;
  String name;
  LatLng latLng;

  Location(this.id, this.name, this.latLng);
}