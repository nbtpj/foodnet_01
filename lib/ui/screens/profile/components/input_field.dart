import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';

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
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
      child: TextField(
        cursorColor: Colors.black,
        style: const TextStyle(
            fontSize: 20
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 5, right: 8,),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(
                IconData(int.parse(widget.icon != null ? widget.icon! : "0xef8d"), fontFamily: 'MaterialIcons'),
                size: 30,
                color: Colors.black,
              ),
            ),
          ),

          suffixIcon: InkWell(
            child: Container(
              width: 60,
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
          contentPadding: const EdgeInsets.only(left: 50, top: 13),
        ),
      ),
    );
  }


}