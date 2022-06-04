import 'package:flutter/material.dart';
import 'package:foodnet_01/util/navigate.dart';

import '../../../util/global.dart';

class PhotoPage extends StatelessWidget {
  final String picture;

  const PhotoPage({Key? key,
    required this.picture
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: const Color.fromRGBO(17, 17, 17, 1),
        margin: EdgeInsets.only(top: height / 42.65),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height / 42.65, ///20
              ),
              IconButton(
                icon: const Icon(IconData(0xe094, fontFamily: 'MaterialIcons')),
                color: Colors.white,
                iconSize: height / 42.65, ///20
                padding: const EdgeInsets.all(1),
                onPressed: () {
                  Navigate.popPage(context);
                }
              ),

              SizedBox(
                height: height * 0.83,
                child: Center(
                  child: Image.network(
                    picture,
                    fit: BoxFit.fitWidth,
                    width: width,
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}