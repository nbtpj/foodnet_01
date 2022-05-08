import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


/// định nghĩa các tham chiến global được sử dụng
/// tham chiếu realtime db
final database = FirebaseDatabase.instance;

/// tham chiếu authentication
final currentUser = FirebaseAuth.instance.currentUser;

/// tham chiếu cloud storage
final storage = FirebaseStorage.instance;

/// các biến liên quan đến location hiện tại
final Location location = Location();
bool _serviceEnabled = false;
PermissionStatus _permissionGranted = PermissionStatus.denied;
Future<bool> lp() async {
  _serviceEnabled ? 1 : _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return false;
    }
  }

  _permissionGranted == PermissionStatus.denied
      ? 1
      : _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}

Future<LatLng> current_pos() async {
  var loc = await location.getLocation();
  bool permit = await lp();
    if (permit) {
      return LatLng(loc.latitude ?? 20.8861024, loc.longitude ?? 106.4049451);
    }
  return const LatLng( 20.8861024, 106.4049451);
}

/// đối tượng sử dụng để config size
class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width??683;        /// 683
    screenHeight = _mediaQueryData?.size.height??411;      /// 411
  }
}
