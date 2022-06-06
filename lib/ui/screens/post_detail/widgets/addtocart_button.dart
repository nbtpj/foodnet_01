import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodnet_01/util/constants/animations.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class AddToCartButton extends StatelessWidget {
  PostData food;

  AddToCartButton({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.screenWidth / 20.55,
        SizeConfig.screenHeight / 34.15,
        SizeConfig.screenWidth / 20.55,
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(
                SizeConfig.screenWidth / 1.37,
                SizeConfig.screenHeight / 11.66)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            notify(developing_option_string);
          },
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(right: SizeConfig.screenWidth / 51.38),
                child: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                ),
              ),
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    add2cart_string,
                    style: TextStyle(
                      fontSize: SizeConfig.screenHeight / 34.15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
