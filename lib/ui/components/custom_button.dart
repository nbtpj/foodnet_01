import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/enum.dart';

class CustomButton extends StatelessWidget {
  final FormMode label;
  final Function onPressed;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () async {
          await onPressed();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                color ?? Theme.of(context).colorScheme.secondary),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            )),
        child: Text(
          label == FormMode.LOGIN ? loginString
              : label == FormMode.REGISTER ? registerString : confirmString,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
