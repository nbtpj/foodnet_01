import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';

import '../../../../util/global.dart';

class InputField extends StatefulWidget {
  final String? icon;
  final String hintText;
  final void Function()? setonEdit;

  const InputField({
    Key? key,
    this.icon,
    required this.hintText,
    this.setonEdit,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField>{

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Container(
      margin: EdgeInsets.only(top: height / 56.87, left: width / 41.1, right: width / 41.1, bottom: height / 85.3),
      child: TextField(
        cursorColor: Colors.black,
        style: TextStyle(
            fontSize: height / 42.65, ///20
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.only(left: width / 82.2, right: width / 51.385,), ///(5, 8)
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(
                IconData(int.parse(widget.icon != null ? widget.icon! : "0xef8d"), fontFamily: 'MaterialIcons'),
                size: height / 28.43, ///30
                color: Colors.black,
              ),
            ),
          ),

          suffixIcon: InkWell(
            child: Container(
              width: 60,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, height / 170.6, 0, height / 170.6), ///(5, 5)
              color: buttonColor,
              child: Text(
                widget.setonEdit != null ? "Lưu" :
                "Thêm",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),

            ),
            onTap: () {
              if (widget.setonEdit != null) {
                widget.setonEdit!();
              }
            },
          ),

          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.orange,
          ),
          contentPadding: EdgeInsets.only(left: width / 8.22, top: height / 65.615), ///(50, 13)
        ),
      ),
    );
  }


}