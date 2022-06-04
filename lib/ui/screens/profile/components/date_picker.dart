import 'package:flutter/material.dart';

import '../../../../util/constants/colors.dart';
import '../../../../util/global.dart';

//ignore: must_be_immutable
class DateBirth extends StatefulWidget {
  late String? mainText;
  final String type;
  final Future<void> Function(String, String) add;
  final void Function(String, String, int) edit;

  DateBirth({
    Key? key,
    this.mainText,
    required this.type,
    required this.add,
     required this.edit,
  }) : super(key: key) ;

  @override
  _DateBirthState createState() => _DateBirthState();

}

class _DateBirthState extends State<DateBirth> {
  double height = SizeConfig.screenHeight;
  double width = SizeConfig.screenWidth;

  @override
  Widget build(BuildContext context) {
    String hintText = widget.mainText != null ? 'Sinh nhật ' : widget.type == "me" ? 'Chưa có thông tin' : 'Không có thông tin để hiển thị';
    return ListTile(
      contentPadding: EdgeInsets.only(right: width / 41.1, left: width / 24.176, top: height / 284.33),
      title: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        text: TextSpan(
            children: [
              TextSpan(
                text: hintText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: widget.mainText != null ? FontWeight.normal : FontWeight.bold,
                  fontSize: height / 44.895, ///19
                ),
              ),
              TextSpan(
                  text: widget.mainText != null ? widget.mainText!.substring(0, 10) : "",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: height / 44.895, ///19
                  )
              )
            ]
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(
          widget.mainText != null ? Icons.cake : Icons.cake_outlined,
          size: height / 28.43, ///30
          color: buttonColor,
        ),
      ),
      trailing: widget.type == "me"
          ? (widget.mainText != null ?
      IconButton(
          onPressed: () async {
            DateTime? d = await showDatePicker(
              context: context,
              initialDate: DateTime.parse(widget.mainText!),
              firstDate: DateTime(DateTime.now().year - 70),
              lastDate: DateTime(DateTime.now().year),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: buttonColor,
                    ),
                  ),
                  child: child!,
                )
              }
            );
            setState(() {
              if (d != null) {
                widget.mainText = d.toString();
                widget.edit(widget.mainText!, "dayOfBirth", 0);
              }
            });
          },
          icon: const Icon(Icons.create_outlined))
      : InkWell(
        child: Container(
          width: width / 6.85,
          height: height / 18,
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0, height / 170.6, 0, height / 170.6), ///(5, 5)
          color: buttonColor,
          child: const Text(
            "Thêm",
            style: TextStyle(
              color: Colors.white,
            ),
          ),

        ),
        onTap: () async {
          DateTime? d = await showDatePicker(
              context: context,
              initialDate: DateTime.parse('1990-01-01'),
              firstDate: DateTime(DateTime.now().year - 70),
              lastDate: DateTime(DateTime.now().year),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: buttonColor,
                    ),
                  ),
                  child: child!,
                )
              }
          );
          setState(() {
            if (d != null) {
              print(d);
              widget.mainText = d.toString();
              widget.add(widget.mainText!, "dayOfBirth");
            }
          });
        },
      )) : const SizedBox(width: 0, height: 0,),
    );
  }


}