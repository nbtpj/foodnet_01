import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/friend/friend_list.dart';
import 'package:foodnet_01/ui/screens/friend/friend_suggestions.dart';
import 'package:foodnet_01/util/navigate.dart';

import '../../../util/data.dart';
import '../../../util/entities.dart';
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
    return getFriends(
              Filter(search_type: "friend_invitations"), getMyProfileId()
          ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Bạn bè ",
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: IconButton(
                    onPressed: () {
                      Navigate.pushPage(context, const SearchPage(type: "user",));
                    },
                    icon: const Icon(Icons.search),
                    color: Colors.black,
                    iconSize: 30,
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
                            margin: const EdgeInsets.all(10),
                            width: 70,
                            height: 30,
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
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10),
                            width: 70,
                            height: 30,
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
                    const SizedBox(
                      height: 4,
                    ),
                    const Divider(
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                      child: Row(
                        children: const [
                          Text(
                            "Lời mời kết bạn",
                            style: TextStyle(
                                fontSize: 25,
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
                                return const SizedBox(
                                  height: 10,
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