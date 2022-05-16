import 'dart:io';

import 'package:flutter/material.dart';

Future<ImageProvider<Object>> any_image(String url, bool? isNet)async{
  /// hàm này nhận vào 1 url và trả về 1 ImageProvider có thể từ Net hoặc File
  /// , nếu isNet == null
  ImageProvider rs;
  if (isNet != null) {
    isNet ? rs = NetworkImage(url) : rs = FileImage(File(url));
  } else {
    if(await File(url).exists()) {
      var f = File(url);
      rs = FileImage(f);
    } else {
      rs = NetworkImage(url);
    }
  }
  return rs;
}
