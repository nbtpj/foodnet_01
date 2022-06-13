import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/ui/screens/friend/friend_list.dart';
import 'package:foodnet_01/ui/screens/friend/friend_suggestions.dart';
import 'package:foodnet_01/util/navigate.dart';

import '../../../util/constants/strings.dart';
import '../../../util/data.dart';
import '../../../util/entities.dart';
import '../../../util/global.dart';
import '../search/search.dart';
import 'components/friend_item.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  dynamic friendList;

  Future<List<Relationship>> fetchRootFriend() async {
    return Relationship.invitationRel(getMyProfileId()).toList();
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
                  friendString,
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
                                borderRadius: BorderRadius.circular(height / 42.65)), ///20
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
                            Navigate.pushPage(context, FriendList(id: getMyProfileId(),));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(height / 42.65)), ///20
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(height / 85.3), ///10
                            width: width / 5.87, ///70
                            height: height / 28.43, ///30
                            child: const Text(
                                friendString,
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
                            friendInvitation,
                            style: TextStyle(
                                fontSize: height / 34.12, ///25
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Relationship>>(
                    future: fetchRootFriend(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        friendList = snapshot.data ?? [];
                        return SizedBox(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: friendList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Relationship friendItem = friendList[index];
                                return FutureBuilder<ProfileData?>(
                                  future: getProfile(friendItem.get_other_id_but_me),
                                  builder: (context, snap){
                                    if(snap.connectionState == ConnectionState.waiting){
                                      return loading;
                                    }
                                    if (snap.hasData && snap.data!=null){
                                      return FriendItem(
                                        id: snap.data!.id,
                                        userAsset: snap.data!.userAsset,
                                        name: snap.data!.name,
                                        time: friendItem.time_string,
                                        mutualism: snap.data!.mutualism,
                                        index: index,
                                        type: "invitation",
                                      );
                                    }
                                    return const Center();
                                  },
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