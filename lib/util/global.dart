import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


/// định nghĩa các tham chiến global được sử dụng
/// tham chiếu realtime db
final database = FirebaseDatabase.instance;

/// tham chiếu authentication
final currentUser = FirebaseAuth.instance.currentUser;

/// tham chiếu cloud storage
final storage = FirebaseStorage.instance;

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
