import 'package:flutter/material.dart';
import 'package:foodnet_01/util/global.dart';
class ArrowBack extends StatelessWidget {
  const ArrowBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        height: SizeConfig.screenHeight/19.51,
        width: SizeConfig.screenWidth/10.28,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: IconButton(
          onPressed: (){Navigator.pop(context);},
          icon : Icon(Icons.arrow_back),
          color: Colors.white,
        )
    );
  }
}
