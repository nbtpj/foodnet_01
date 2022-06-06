import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppAnimations {
  static String chatAnimation = 'assets/animations/chat-anim.json';
}
void notify(String notice){
  Fluttertoast.showToast(
      msg: notice,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}