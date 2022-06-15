import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/nav_bar.dart';
import 'package:foodnet_01/ui/screens/profile/components/ListTile.dart';
import 'package:foodnet_01/ui/screens/profile/components/date_picker.dart';
import 'package:foodnet_01/ui/screens/profile/components/dropdown_field.dart';
import 'package:foodnet_01/ui/screens/profile/components/input_field.dart';
import 'package:foodnet_01/ui/screens/profile/profile.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/entities.dart';

import '../../../util/constants/colors.dart';
import '../../../util/global.dart';
import '../../../util/navigate.dart';

//ignore: must_be_immutable
class DetailProfile extends StatefulWidget {
  late ProfileData profile;
  final String type;
  DetailProfile({
    Key? key,
    required this.profile,
    required this.type,
  }) : super(key: key);

  @override
  _DetailProfileState createState() => _DetailProfileState();

}

class _DetailProfileState extends State<DetailProfile> {
  Future<void> add(String addContent, String type) async {
    if (type == "schools" && addContent != "") {
      widget.profile.schools!.add(addContent);
    }
    if (type == "works" && addContent != "") {
      widget.profile.works!.add(addContent);
    }
    if (type == "favorites" && addContent != "") {
      widget.profile.favorites!.add(addContent);
    }
    if (type == "location" && addContent != "") {
      widget.profile.location = addContent;
    }
    if (type == "gender" && addContent != defaultGender) {
      widget.profile.gender = addContent;
    }
    if (type == "dayOfBirth") {
      widget.profile.dayOfBirth = addContent;
    }
    bool success = await widget.profile.update(type);
    if (success) {
      setState(() {
        widget.profile = widget.profile;
      });
    }
  }

  Future<void> edit(String editContent, String type, int index) async {
    if (type == "schools") {
      if (editContent == "") {
        widget.profile.schools!.removeAt(index);
      } else {
        widget.profile.schools![index] = editContent;
      }
    }
    if (type == "works") {
      if (editContent == "") {
        widget.profile.works!.removeAt(index);
      } else {
        widget.profile.works![index] = editContent;
      }
    }
    if (type == "favorites") {
      if (editContent == "") {
        widget.profile.favorites!.removeAt(index);
      } else {
        widget.profile.favorites![index] = editContent;
      }
    }
    if (type == "location") {
      if (editContent == "") {
        widget.profile.location = null;
      } else {
        widget.profile.location = editContent;
      }
    }
    if (type == "gender") {
      if (editContent == defaultGender) {
        widget.profile.gender = null;
      } else {
        widget.profile.gender = editContent;
      }
    }
    if (type == "dayOfBirth") {
      widget.profile.dayOfBirth = editContent;
    }
    bool success = await widget.profile.update(type);
    if (success) {
      setState(() {
        widget.profile = widget.profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        toolbarHeight: height / 12.186, ///70
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back,
          ),
          color: Colors.white,
          iconSize: height / 28.43, ///30
          onPressed: () {
            Navigate.popPage(context);
            Navigate.pushPageReplacement(context, MyHomePage(index: 3,));
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: width / 5.4),
          child: Text(
            introductionString,
            style: TextStyle(
              fontSize: height / 30.464, ///28
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                worksString,
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.type == "me" ?
            InputField(icon: "0xe6f4", hintText: addWorkString, add: add,)
                : const SizedBox(width: 0, height: 0,),

            widget.profile.works!.isNotEmpty ?
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.profile.works!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.type == "me") {
                    return ProfileTitle(subText: worksAtString, mainText: widget.profile.works![index], type: widget.type, edit: edit, index: index,);
                  } else {
                    return ProfileTitle(subText: worksAtString, mainText: widget.profile.works![index], type: widget.type, asset: "0xe6f2",);
                  }
                }
            ) : widget.type == "me" ? const SizedBox(width: 0, height: 0,) : ProfileTitle(subText: "", mainText: noInfoString, type: widget.type, asset: "0xe6f2",),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                educationString,
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.type == "me" ?
            InputField(icon: "0xf33c", hintText: addEducationString, add: add,)
                : const SizedBox(width: 0, height: 0,),

            widget.profile.schools!.isNotEmpty ?
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.profile.schools!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.type == "me") {
                    return ProfileTitle(subText: studyAtString, mainText: widget.profile.schools![index], type: widget.type, edit: edit, index: index,);
                  } else {
                    return ProfileTitle(subText: studyAtString, mainText: widget.profile.schools![index], type: widget.type, asset: "0xe559",);
                  }
                }
            ) : widget.type == "me" ? const SizedBox(width: 0, height: 0,) : ProfileTitle(subText: "", mainText: noInfoString, type: widget.type, asset: "0xe559",),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                locationString,
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.profile.location != null ?
            ProfileTitle(subText: liveAtString, mainText: widget.profile.location!, type: widget.type, asset: "0xf7f5", edit: edit,) :
            widget.type == "me" ? InputField(icon: "0xf107", hintText: addPlaceString, add: add,) : ProfileTitle(subText: "", mainText: noInfoString, type: widget.type, asset: "0xf7f5",),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                basicInfoString,
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.profile.gender != null ?
            ProfileTitle(subText: genderString, mainText: widget.profile.gender!, type: widget.type, asset: "0xe491", edit: edit,) :
            widget.type == "me" ? DropDownField(icon: "0xe497", hintText: addGenderString, add: add,) : ProfileTitle(subText: "", mainText: noInfoString, type: widget.type, asset: "0xe491",),

            DateBirth(mainText: widget.profile.dayOfBirth, type: widget.type, add: add, edit: edit,),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                favoriteString,
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.type == "me" ?
            InputField(icon: "0xe25c", hintText: addFavoriteString, add: add,)
                : const SizedBox(width: 0, height: 0,),

            widget.profile.favorites!.isNotEmpty ?
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.profile.favorites!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.type == "me") {
                    return ProfileTitle(subText: favoriteString, mainText: widget.profile.favorites![index], type: widget.type, edit: edit, index: index,);
                  } else {
                    return ProfileTitle(subText: favoriteString, mainText: widget.profile.favorites![index], type: widget.type, asset: "0xe25b",);
                  }
                }
            ) : widget.type == "me" ? const SizedBox(width: 0, height: 0,) : ProfileTitle(subText: "", mainText: noInfoString, type: widget.type, asset: "0xe25b",),
          ],
        ),
      )
    );
  }

}