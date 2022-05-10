import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/profile/profile.dart';

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
    return InkWell(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: 90,
          height: 165,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Positioned(
                  left: 0,
                  top: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: Image.asset(
                      userAsset,
                      width: 90,
                      height: 102,
                      fit: BoxFit.cover,
                    ),
                  )),
              Positioned(
                left: 0,
                top: 110,
                child: SizedBox(
                    width: 90,
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
                            style: const TextStyle(fontSize: 12, color: Colors.black),
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
