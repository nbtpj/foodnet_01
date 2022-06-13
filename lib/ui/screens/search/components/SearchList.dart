// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/screen/chat_screens.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';

import '../../../../util/entities.dart';
import '../../../../util/global.dart';
import '../../../../util/navigate.dart';
import '../../profile/profile.dart';

//ignore: must_be_immutable
class SearchList extends StatefulWidget {
  late List<ProfileData>? searchList;
  final String? keyword;
  final String type;
  late List<RecentUserSearchData>? recentData;

  SearchList({
    Key? key,
    this.searchList,
    this.keyword,
    required this.type,
    this.recentData,
  }) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {

  Future<void> edit(ProfileData? editContent, String type, String? id, int? index) async {
    if (type == "erase") {
      bool success = await deleteRecentUsers(getMyProfileId(), id!);
      if (!success) {
        debugPrint("error");
      } else {
        setState(() {
          widget.recentData!.removeAt(index!);
        });
      }
    }
    if (type == "eraseAll") {
      bool success = await deleteAllRecentUsers(getMyProfileId());
      if (!success) {
        debugPrint("error");
      } else {
        setState(() {
          widget.recentData!.clear();
        });
      }
    }
    if (type == "add") {
      RecentUserSearchData data = RecentUserSearchData(userAsset: editContent!.userAsset, profileId: editContent.id, name: editContent.name, id: '', createAt: DateTime.now(),) ;
      await checkEqualRecentUsers(getMyProfileId(), data);
      bool success = await addRecentUsers(getMyProfileId(), data);
      if (!success) {
        debugPrint("error");
      }
    }
  }

  buildListItem(ProfileData? data, int index, RecentUserSearchData? rdata) {
    double height = SizeConfig.screenHeight;
    return InkWell(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: height / 42.65, ///20
          backgroundImage: NetworkImage(data != null ? data.userAsset : rdata!.userAsset),
        ),
        title: Text(data!= null ? data.name : rdata!.name),
        trailing: IconButton(
          icon: Icon(widget.keyword != null ? Icons.forward : Icons.clear),
          onPressed: () {
            if (widget.keyword == null) {
              edit(null, "erase", rdata!.id, index);
            }
          },
        ),
      ),
      onTap: () {
        if (widget.type == "user") {
          edit(data, "add", null, null);
          Navigate.pushPage(context, ProfilePage(id: data != null ? data.id : rdata!.profileId!,));
        } else {
          Navigate.pushPage(context, ChatScreens(userId: data!.id,));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(width / 41.1, height / 56.87, width / 41.1, height / 56.87), ///(10, 15, 10, 15)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.keyword == null ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text(recent_search_string, style: TextStyle(fontSize: height / 38.77, fontWeight: FontWeight.bold),), ///22
                    InkWell(
                      child: Text(delete_all_string, style: TextStyle(fontSize: height / 38.77, color: buttonColor, )), ///22,
                      onTap: () {
                        edit(null, "eraseAll", null, null);
                      },
                    ),
                  ],
                ) : const SizedBox(width: 0, height: 0,),

                ListView.builder(
                  padding: EdgeInsets.only(top: height / 85.3), ///10
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.searchList != null ? widget.searchList!.length : widget.recentData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildListItem(widget.searchList != null ? widget.searchList![index] : null, index, widget.recentData != null ? widget.recentData![index] : null);
                  },
                ),

                SizedBox(height: height / 85.3,), ///10
              ]
            ),
          ),
        )
    );
  }
}