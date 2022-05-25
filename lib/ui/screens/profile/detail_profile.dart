import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/profile/components/ListTile.dart';
import 'package:foodnet_01/ui/screens/profile/components/input_field.dart';
import 'package:foodnet_01/util/entities.dart';

import '../../../util/global.dart';
import '../../../util/navigate.dart';

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
    bool success = await widget.profile.update(type);
    if (success) {
      setState(() {
        widget.profile = widget.profile;
      });
    }
  }

  /*Future<void> deleteSchool(String school) async {
    widget.profile.schools!.add(school);
    bool success = await widget.profile.updateSchools();
    if (success) {
      setState(() {
        widget.profile = widget.profile;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: height / 12.186, ///70
        leading: IconButton(
          icon: const Icon(
              IconData(0xe094, fontFamily: 'MaterialIcons'),
          ),
          color: Colors.black,
          iconSize: height / 28.43, ///30
          onPressed: () {
            Navigate.popPage(context);
          },
        ),
        title: Center(
          child: Text(
            "Giới thiệu ",
            style: TextStyle(
              fontSize: height / 30.464, ///28
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.black,
            iconSize: height / 28.43, ///30
            padding: const EdgeInsets.only(right: 0),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                "Công việc ",
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.type == "me" ?
            InputField(icon: "0xe6f4", hintText: "Thêm công việc", add: add,)
                : const SizedBox(width: 0, height: 0,),

            widget.profile.works!.isNotEmpty ?
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.profile.works!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.type == "me") {
                    return ProfileTitle(subText: "Làm việc tại ", mainText: widget.profile.works![index], type: widget.type, edit: edit, index: index,);
                  } else {
                    return ProfileTitle(subText: "Làm việc tại ", mainText: widget.profile.works![index], type: widget.type, asset: "0xe6f2",);
                  }
                }
            ) : widget.type == "me" ? const SizedBox(width: 0, height: 0,) : ProfileTitle(subText: "", mainText: "Không có thông tin để hiển thị", type: widget.type, asset: "0xe6f2",),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                "Học vấn ",
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.type == "me" ?
            InputField(icon: "0xf33c", hintText: "Thêm trường học", add: add,)
                : const SizedBox(width: 0, height: 0,),

            widget.profile.schools!.isNotEmpty ?
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.profile.schools!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.type == "me") {
                    return ProfileTitle(subText: "Học tại ", mainText: widget.profile.schools![index], type: widget.type, edit: edit, index: index,);
                  } else {
                    return ProfileTitle(subText: "Học tại ", mainText: widget.profile.schools![index], type: widget.type, asset: "0xe559",);
                  }
                }
            ) : widget.type == "me" ? const SizedBox(width: 0, height: 0,) : ProfileTitle(subText: "", mainText: "Không có thông tin để hiển thị", type: widget.type, asset: "0xe559",),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                "Nơi sống ",
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.profile.location != null ?
            ProfileTitle(subText: "Đến từ ", mainText: widget.profile.location!, type: widget.type, asset: "0xf7f5", edit: edit,) :
            widget.type == "me" ? InputField(icon: "0xf107", hintText: "Thêm nơi sống", add: add,) : ProfileTitle(subText: "", mainText: "Không có thông tin để hiển thị", type: widget.type, asset: "0xf7f5",),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                "Thông tin cơ bản ",
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.profile.gender != null ?
            ProfileTitle(subText: "Giới tính ", mainText: widget.profile.gender!, type: widget.type, asset: "0xe491",) :
            widget.type == "me" ? InputField(icon: "0xe497", hintText: "Thêm giới tính", add: add,) : ProfileTitle(subText: "", mainText: "Không có thông tin để hiển thị", type: widget.type, asset: "0xe491",),

            widget.profile.dayOfBirth != null ?
            ProfileTitle(subText: "Sinh nhật ", mainText: widget.profile.dayOfBirth!.substring(0, 10), type: widget.type, asset: "0xe120",) :
            widget.type == "me" ? InputField(icon: "0xef0f", hintText: "Thêm sinh nhật", add: add) : ProfileTitle(subText: "", mainText: "Không có thông tin để hiển thị", type: widget.type, asset: "0xe120",),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top : height / 56.87, left: width / 41.1), ///(15, 10)
              child: Text(
                "Sở thích ",
                style: TextStyle(
                  fontSize: height / 30.464, ///28
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            widget.type == "me" ?
            InputField(icon: "0xe25c", hintText: "Thêm sở thích", add: add,)
                : const SizedBox(width: 0, height: 0,),

            widget.profile.favorites!.isNotEmpty ?
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.profile.favorites!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.type == "me") {
                    return ProfileTitle(subText: "Sở thích ", mainText: widget.profile.favorites![index], type: widget.type, edit: edit, index: index,);
                  } else {
                    return ProfileTitle(subText: "Sở thích ", mainText: widget.profile.favorites![index], type: widget.type, asset: "0xe25b",);
                  }
                }
            ) : widget.type == "me" ? const SizedBox(width: 0, height: 0,) : ProfileTitle(subText: "", mainText: "Không có thông tin để hiển thị", type: widget.type, asset: "0xe25b",),
          ],
        ),
      )
    );
  }

}