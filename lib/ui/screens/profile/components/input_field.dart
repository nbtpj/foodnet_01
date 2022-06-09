import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';

import '../../../../util/global.dart';

class InputField extends StatefulWidget {
  final String? icon;
  final String hintText;
  final void Function()? setonEdit;
  final Future<void> Function(String, String)? add;
  final void Function(String, String, int)? edit;
  final int? index;
  final String? subText;

  const InputField({
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
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField>{

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.setonEdit != null) {
      textController.text = widget.hintText;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Container(
      margin: EdgeInsets.only(top: height / 56.87, left: width / 41.1, right: width / 41.1, bottom: height / 85.3),
      child: TextField(
        controller: textController,
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
                widget.setonEdit != null ? saveString :
                addString,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),

            ),
            onTap: () {
              if (widget.setonEdit != null) {
                if (widget.subText == studyAtString) {
                  widget.edit!(textController.text, "schools", widget.index!);
                }
                if (widget.subText == worksAtString) {
                  widget.edit!(textController.text, "works", widget.index!);
                }
                if (widget.subText == favoriteString) {
                  widget.edit!(textController.text, "favorites", widget.index!);
                }
                if (widget.subText == liveAtString) {
                  widget.edit!(textController.text, "location", -1);
                }
                widget.setonEdit!();
              } else {
                if (widget.hintText == addEducationString) {
                  widget.add!(textController.text, "schools");
                }
                if (widget.hintText == addWorkString) {
                  widget.add!(textController.text, "works");
                }
                if (widget.hintText == addFavoriteString) {
                  widget.add!(textController.text, "favorites");
                }
                if (widget.hintText == addPlaceString) {
                  widget.add!(textController.text, "location");
                }
                textController.text = '';
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