import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider any_image(String url, bool? isNet) {
  /// hàm này nhận vào 1 url và trả về 1 ImageProvider có thể từ Net hoặc File
  /// , nếu isNet == null
  ImageProvider rs;
  if (isNet != null) {
    isNet ? rs = NetworkImage(url) : rs = FileImage(File(url));
  } else {
    try {
      var f = File(url);
      rs = FileImage(f);
    } catch (e) {
      rs = NetworkImage(url);
    }
  }
  return rs;
}
