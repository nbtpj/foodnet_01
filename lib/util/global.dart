import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

/// định nghĩa các tham chiến global được sử dụng
/// tham chiếu realtime db
final database = FirebaseDatabase.instance;

/// tham chiếu authentication
final currentUser = FirebaseAuth.instance;

/// tham chiếu cloud storage
final storage = FirebaseStorage.instance;

/// đối tượng sử dụng để config size
class SizeConfig {
  static late double screenWidth, screenHeight;

  void init(BuildContext context) {
  }
}
