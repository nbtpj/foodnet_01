import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/util/constants/images.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

import '../../../util/global.dart';
import '../../../util/navigate.dart';
import '../search/search.dart';
import 'components/friend_list_item.dart';

class FriendList extends StatefulWidget {
  final String id;
  final String? name;
  const FriendList({
    Key? key,
    required this.id,
    this.name,
  }) : super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  bool isEmpty = true;
  String keyword = "";

  void isDelete() {
    setState(() {});
  }

  Widget buildFriendList(AsyncSnapshot<List<ProfileData>> snapshot) {
    if (snapshot.hasData) {
      var friendList = snapshot.data ?? [];
      if (friendList.isEmpty) {
        return Container(
          height: SizeConfig.screenHeight/3,
          width: SizeConfig.screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(nothingAsset),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
        );
      }
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: friendList.length,
          itemBuilder: (BuildContext context, int index) {
            var friendItem = friendList[index];
            return FriendListItem(
              id: friendItem.id,
              userAsset: friendItem.userAsset,
              name: friendItem.name,
              mutualFriends: friendItem.mutualism,
              isDelete: isDelete,
            );
          });
    } else {
      return const Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    Future<List<ProfileData>> fetchRootFriend() async {
      return Relationship.friendProfile(widget.id).toList();
    }

    Future<List<ProfileData>> fetchRootFriendByKey(String key) async {
      return pseudoSearchFriend(widget.id, key)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigate.popPage(context);
          },
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          iconSize: height / 28.43,
          padding: const EdgeInsets.only(right: 10),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: height / 12.186, ///70
        title: Center(
          child: Text(
            friendString + " " + (widget.name != null ? "c???a " +
                widget.name!.split(' ')[widget.name!.split(' ').length - 1] : ""),
            style: TextStyle(
              fontSize: height / 30.464, ///28
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigate.pushPage(
                  context,
                  const SearchPage(
                    type: "user",
                  ));
            },
            color: Colors.black,
            icon: const Icon(Icons.search),
            iconSize: height / 28.43,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: height / 50,
          ),
          Container(
            margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,

                fillColor: Colors.grey[300],
                hintText: searchFriendString,
                contentPadding: EdgeInsets.only(top: height / 60.93),

                ///14
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(height / 85.3),

                  ///10
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(height / 85.3),

                  ///10
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
              ),
              onChanged: (text) {
                keyword = text;
                if (text == "") {
                  setState(() {
                    isEmpty = true;
                  });
                } else {
                  setState(() {
                    isEmpty = false;
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: height / 170.6,
          ),
          Expanded(
              child: FutureBuilder<List<ProfileData>>(
            future: isEmpty == true ? fetchRootFriend() : fetchRootFriendByKey(keyword),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return loading;
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: width / 34.25,
                          right: width / 34.25,
                          top: height / 71.08),

                      ///(12, 12, 12)
                      child: Row(
                        children: [
                          Text(
                            snapshot.data==null?loading_string:"${snapshot.data?.length} $friend_string",
                            style: TextStyle(
                              fontSize: height / 34.12,

                              ///25
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildFriendList(snapshot)
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
