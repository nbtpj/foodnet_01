import 'package:flutter/material.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';



class PostView extends StatefulWidget {
  late PostData post;

  PostView({Key? key}) : super(key: key);
  @override
  _PostView createState() => _PostView();
}

class _PostView extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.35),
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black54, blurRadius: 10, offset: Offset(0, -1))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Container(
              width: SizeConfig.screenWidth / 3.43,

              /// 120.0
              height: SizeConfig.screenHeight / 227.67,

              /// 3.0
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12),
            ),
            SizedBox(
              height: SizeConfig.screenHeight / 34.15,
            ),

          ],
        ),
      ),
    );
  }
}
