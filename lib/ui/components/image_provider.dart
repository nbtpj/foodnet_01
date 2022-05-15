import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider any_image(String url, bool? isNet) {
  ImageProvider rs;
  if (isNet != null) {
    isNet ? rs = NetworkImage(url) : rs = FileImage(File(url));
  } else {
    try{
      rs = NetworkImage(url);
    } catch (e){
      rs = FileImage(File(url));
    }
  }
  return rs;
}
