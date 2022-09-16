import 'package:attendance_app/data/model/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const INSIDE_MONAS = '50m_inside_monas';
const OUTSIDE_MONAS = 'outside_monas';
const REAL_USER = 'real_user';

final masterAttendanceLocation = [
  Location('gbk', 'Gelora Bung Karno', const LatLng(-6.218666086825135, 106.80187199966154)),
  Location('gedung_sate', 'Gedung Sate', const LatLng(-6.902368335302182, 107.61865318247192)),
  Location('monas', 'Monas', const LatLng(-6.175328396028417, 106.82717425548299)),
  Location('istana_bogor', 'Istana Presiden Bogor', const LatLng(-6.594409648090026, 106.7982582769214)),
];

final masterUserLocation = [
  Location(INSIDE_MONAS, '50m Inside Monas', const LatLng(-6.1754, 106.8272)),
  Location(OUTSIDE_MONAS, 'Outside Monas', const LatLng(-6.173803, 106.838113)),
];