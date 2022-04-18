import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/friend_list.dart';
import 'package:foodnet_01/util/navigate.dart';

import '../components/friend_item.dart';

List friends = [
  {"name": "Luong Dat", "time": "31W", "userAsset": "images/tarek.jpg"},
  {"name": "Minh Quang", "time": "31H", "userAsset": "images/tarek.jpg"},
  {"name": "Dao Tuan", "time": "31W", "userAsset": "images/tarek.jpg"},
  {"name": "Pham Trong", "time": "31M", "userAsset": "images/tarek.jpg"},
  {"name": "Luong Dat", "time": "31W", "userAsset": "images/tarek.jpg"},
  {"name": "Minh Quang", "time": "31H", "userAsset": "images/tarek.jpg"},
  {"name": "Dao Tuan", "time": "31W", "userAsset": "images/tarek.jpg"},
  {"name": "Pham Trong", "time": "31M", "userAsset": "images/tarek.jpg"},
];

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  void _eraseFriendsList(int index) {
    setState(() {
      friends.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                      color: Colors.black,
                      iconSize: 30,
                      padding: const EdgeInsets.only(right: 0),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.all(10),
                  width: 70,
                  height: 30,
                  alignment: Alignment.center,
                  child: const Text("Gợi ý"),
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
                    child: const Text("Bạn bè"),
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
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: friends.length,
                itemBuilder: (BuildContext context, int index) {
                  Map friendItem = friends[index];
                  return FriendItem(
                    userAsset: friendItem['userAsset'],
                    name: friendItem['name'],
                    time: friendItem['time'],
                    eraseFriendsList: _eraseFriendsList,
                    index: index,
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}