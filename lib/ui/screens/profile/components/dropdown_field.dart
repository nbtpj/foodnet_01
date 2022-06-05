import 'package:flutter/material.dart';

import '../../../../util/constants/colors.dart';
import '../../../../util/global.dart';

class DropDownField extends StatefulWidget {
  final String? icon;
  final String hintText;
  final void Function()? setonEdit;
  final Future<void> Function(String, String)? add;
  final void Function(String, String, int)? edit;
  final int? index;
  final String? subText;

  const DropDownField({
    Key? key,
    this.icon,
    required this.hintText,
    this.add,
    this.setonEdit,
    this.edit,
    this.index,
    this.subText,
  }) : super(key: key);

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  String selectedItem = "Giới tính";
  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Container(
      margin: EdgeInsets.only(top: height / 56.87, left: width / 41.1, right: width / 41.1, bottom: height / 85.3),
      child: DropdownButtonFormField <String>(
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.only(left: width / 82.2, right: width / 23.385,), ///(5, 8)
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(
                IconData(int.parse(widget.icon != null ? widget.icon! : "0xef8d"), fontFamily: 'MaterialIcons'),
                size: height / 28.43, ///30
                color: buttonColor,
              ),
            ),
          ),
          suffixIcon: InkWell(
            child: Container(
              width: width / 6.85,
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
                widget.edit!(selectedItem, "gender", -1);
                widget.setonEdit!();
              } else {
                widget.add!(selectedItem, "gender");
              }
            },
          ),
        ),
        value: selectedItem,
        onChanged: (value) {
          setState(() {
            selectedItem = value!;
          });
        },
        items: ["Giới tính", "Nam", "Nữ", "Khác"].map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                  fontSize: height / 42.65, ///20
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


}