import 'package:flutter/material.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

import '../../../util/navigate.dart';
import '../../components/friend_item.dart';

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
      return get_friends(Filter(search_type: "friend_list")).toList();
    }
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
                    onPressed: () {},
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
              decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(top: 1, bottom: 10, left: 15, right: 15),
              padding: const EdgeInsets.only(left: 7),
              height: 30,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.search),
                  /*TextField(
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm bạn bè",
                      fillColor: Colors.black,
                    ),
                  ),*/
                  Text("Tìm kiếm bạn bè"),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
              child: Row(
                children: const [
                  Text(
                    "710 người bạn",
                    style: TextStyle(fontSize: 25),
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
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
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
                })

          ],
        ),
      ),
    );
  }
}