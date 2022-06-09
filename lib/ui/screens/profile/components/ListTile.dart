import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/profile/components/input_field.dart';
import 'package:foodnet_01/util/constants/colors.dart';

import '../../../../util/constants/strings.dart';
import '../../../../util/global.dart';
import 'dropdown_field.dart';

class ProfileTitle extends StatefulWidget {
  final String? asset;
  final String subText;
  final String type;
  final String mainText;
  final void Function(String, String, int)? edit;
  final int? index;

  const ProfileTitle({
    Key? key,
    this.asset,
    this.edit,
    required this.subText,
    required this.mainText,
    required this.type,
    this.index,
  }) : super(key: key);

  @override
  _ProfileTitleState createState() => _ProfileTitleState();
}

class _ProfileTitleState extends State<ProfileTitle> {
  bool onEdit = false;

  void setonEdit() {
    setState(() {
      onEdit = !onEdit;
    });
  }
  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    return onEdit
        ? (widget.subText != genderString ? InputField(icon: widget.asset, hintText: widget.mainText, setonEdit: setonEdit, edit: widget.edit, index: widget.index, subText: widget.subText,)
        : DropDownField(icon: "0xe497", hintText: addGenderString, edit: widget.edit, setonEdit: setonEdit))
        : ListTile(
      title: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        text: TextSpan(
            children: [
              TextSpan(
                text: widget.subText,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: height / 44.895, ///19
                ),
              ),
              TextSpan(
                  text: widget.mainText,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: height / 44.895, ///19
                  )
              )
            ]
        ),
      ),
      leading: widget.asset != null ? CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(
          IconData(int.parse(widget.asset!), fontFamily: 'MaterialIcons'),
          size: height / 28.43, ///30
          color: buttonColor,
        ),
      ) : const SizedBox(height: 0, width: 0,),
      trailing: widget.type == "me"
          ? IconButton(
          onPressed: () {
            setonEdit();
          },
          icon: const Icon(Icons.create_outlined))
          : const SizedBox(width: 0, height: 0,),
    );
  }

}