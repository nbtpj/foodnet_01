import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/profile/profile.dart';

import '../../../../util/global.dart';
import '../../../../util/navigate.dart';

class Friend extends StatelessWidget {
  final String userAsset;
  final String? firstName;
  final String? lastName;
  final String? name;
  const Friend({
    Key? key,
    required this.userAsset,
    this.firstName,
    this.lastName,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return InkWell(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height / 85.3)), ///10
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 85.3), ///10
            color: Colors.white,
          ),
          width: width / 4.567, ///90
          height: height / 5.17, ///165
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Positioned(
                  left: 0,
                  top: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(height / 85.3), ///10
                        topRight: Radius.circular(height / 85.3)), ///10
                    child: Image.asset(
                      userAsset,
                      width: width / 4.567, ///90
                      height: height / 8.36, ///102
                      fit: BoxFit.cover,
                    ),
                  )),
              Positioned(
                left: 0,
                top: height / 7.755, ///110
                child: SizedBox(
                    width: width / 4.567, ///90,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /*Text(
                      firstName!,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(lastName!,
                        style: const TextStyle(fontSize: 12, color: Colors.black)),*/
                          Text(
                            name!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: height / 71.08, color: Colors.black), ///12
                            maxLines: 2,
                          )
                        ],
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigate.pushPage(context, const ProfilePage(type: "other", id: "2"));
      },
    );
  }
}
