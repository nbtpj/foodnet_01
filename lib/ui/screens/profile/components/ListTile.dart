import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/profile/components/input_field.dart';

class ProfileTitle extends StatefulWidget {
  final String? asset;
  final String subText;
  final String type;
  final String mainText;

  const ProfileTitle({
    Key? key,
    this.asset,
    required this.subText,
    required this.mainText,
    required this.type,
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
    return onEdit
        ? InputField(icon: widget.asset, hintText: widget.mainText, setonEdit: setonEdit,)
        : ListTile(
      title: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        text: TextSpan(
            children: [
              TextSpan(
                text: widget.subText,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 19
                ),
              ),
              TextSpan(
                  text: widget.mainText,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 19
                  )
              )
            ]
        ),
      ),
      leading: widget.asset != null ? CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(
          IconData(int.parse(widget.asset!), fontFamily: 'MaterialIcons'),
          size: 30,
          color: Colors.blue,
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