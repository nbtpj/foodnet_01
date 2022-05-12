import 'package:flutter/material.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

import '../../../util/navigate.dart';
import '../../components/friend_item.dart';
import '../search/search.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  /*void _eraseFriendsList(int index) {
    setState(() {
      friend1s.removeAt(index);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    Future<List<FriendData>> fetchRootFriend() async {
      //todo: implement get root post (categorical post)
      return getFriends(Filter(search_type: "friend_list"), getMyProfileId()).toList();
    }
    return Scaffold(
      body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigate.popPage(context);
                    },
                    icon: const Icon(IconData(0xe094, fontFamily: 'MaterialIcons')),
                    color: Colors.black,
                    iconSize: 30,
                  ),
                  const Text(
                    "Bạn bè ",
                    style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigate.pushPage(context, const SearchPage(type: "user",));
                    },
                    icon: const Icon(Icons.search),
                    color: Colors.black,
                    iconSize: 30,
                    padding: const EdgeInsets.only(right: 0),
                  ),
                ],
              ),
            ),

            const Divider(
              color: Colors.black54,
            ),
            const SizedBox(
              height: 5,
            ),

            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,

                  fillColor: Colors.grey[300],
                  hintText: 'Tìm kiếm bạn bè',
                  contentPadding: const EdgeInsets.only(top: 14),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 5,),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Row(
                          children: const [
                            Text(
                              "710 người bạn",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      FutureBuilder<List<FriendData>>(
                          future: fetchRootFriend(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var friendList = snapshot.data ?? [];
                              return ListView.separated(
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
                                    return FriendListItem(
                                      userAsset: friendItem.userAsset,
                                      name: friendItem.name,
                                      mutual_friends: friendItem.mutualism!,
                                    );
                                  }
                              );
                            } else {
                              return const Center();
                            }
                          },
                      )
                    ],
                  ),
                )
            )

          ],
      ),
    );
  }
}