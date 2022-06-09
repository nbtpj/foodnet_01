import 'package:flutter/material.dart';
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

  Widget buildFriendList(AsyncSnapshot<List<FriendData>> snapshot) {
    if (snapshot.hasData) {
      var friendList = snapshot.data ?? [];
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
    Future<List<FriendData>> fetchRootFriend() async {
      //todo: implement get root post (categorical post)
      return getFriends(Filter(search_type: "friend_list"), widget.id)
          .toList();
    }

    Future<List<FriendData>> fetchRootFriendByKey(String key) async {
      //todo: implement get root post (categorical post)
      return pseudoSearchFriend(widget.id, key)
          .toList();
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: width / 41.1,
                right: width / 41.1,
                top: height / 21.325,
                bottom: height / 85.3),

            ///(10, 10, 40, 10)
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigate.popPage(context);
                  },
                  icon:
                      const Icon(IconData(0xe094, fontFamily: 'MaterialIcons')),
                  color: Colors.black,
                  iconSize: height / 28.43,

                  ///30
                ),
                Text(
                  friendString + " " + (widget.name != null ? "của " +
                      widget.name!.split(' ')[widget.name!.split(' ').length - 1] : ""),
                  style: TextStyle(
                      fontSize: height / 28.43, fontWeight: FontWeight.bold),

                  ///30
                ),
                IconButton(
                  onPressed: () {
                    Navigate.pushPage(
                        context,
                        const SearchPage(
                          type: "user",
                        ));
                  },
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                  iconSize: height / 28.43,

                  ///30
                  padding: const EdgeInsets.only(right: 0),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black54,
          ),
          SizedBox(
            height: height / 170.6,

            ///5
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
              child: FutureBuilder<List<FriendData>>(
            future: isEmpty == true ? fetchRootFriend() : fetchRootFriendByKey(keyword),
            builder: (context, snapshot) {
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
                            "${snapshot.data?.length} $friend_string",
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
