import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/friend/friend_list.dart';
import 'package:foodnet_01/ui/screens/friend/friend_suggestions.dart';
import 'package:foodnet_01/util/navigate.dart';

import '../../../util/data.dart';
import '../../../util/entities.dart';
import '../../../util/global.dart';
import '../../components/friend_item.dart';
import '../search/search.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  dynamic friendList;
  void _eraseFriendsList(int index) {
    setState(() {
      friendList.removeAt(index);
    });
  }

  Future<List<FriendData>> fetchRootFriend() async {
    //todo: implement get root post (categorical post)
    return get_friends(Filter(search_type: "friend_invitations")).toList();
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: width / 41.1 , right: width / 41.1, top: height / 21.325, bottom: height / 85.3), ///(10, 10, 40, 10)
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bạn bè ",
                  style: TextStyle(
                      fontSize: height / 28.43, fontWeight: FontWeight.bold), ///30
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: IconButton(
                    onPressed: () {
                      Navigate.pushPage(context, const SearchPage(type: "user",));
                    },
                    icon: const Icon(Icons.search),
                    color: Colors.black,
                    iconSize: height / 28.43, ///30
                    padding: const EdgeInsets.only(right: 0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigate.pushPage(context, const FriendSuggestion());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.all(height / 85.3),
                            width: width / 5.87, ///70
                            height: height / 28.43, ///30
                            alignment: Alignment.center,
                            child: const Text(
                              "Gợi ý",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigate.pushPage(context, const FriendList());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(height / 42.65)),///20
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(height / 85.3), ///10
                            width: width / 5.87, ///70
                            height: height / 28.43, ///30
                            child: const Text(
                                "Bạn bè",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height / 213.25, ///4
                    ),
                    const Divider(
                      color: Colors.black54,
                    ),
                    SizedBox(
                      height: height / 170.6,///5
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width / 34.25, right: width / 34.25, top: height / 71.08),///(12, 12, 12)
                      child: Row(
                        children: [
                          Text(
                            "Lời mời kết bạn",
                            style: TextStyle(
                                fontSize: height / 34.12, ///25
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<FriendData>>(
                    future: fetchRootFriend(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        friendList = snapshot.data ?? [];
                        return SizedBox(
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: height / 85.3, ///10
                                );
                              },
                              itemCount: friendList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var friendItem = friendList[index];
                                return FriendItem(
                                  userAsset: friendItem.userAsset,
                                  name: friendItem.name,
                                  time: friendItem.time!,
                                  eraseFriendsList: _eraseFriendsList,
                                  index: index,
                                );
                              }),
                        );

                      } else {
                        return const Center();
                      }
                    }),
                  ],
                ),
              ),
          )


        ],
      ),
    );
  }
}