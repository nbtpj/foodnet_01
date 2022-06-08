import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/search/search.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

import '../../../util/constants/strings.dart';
import '../../../util/navigate.dart';
import 'components/friend_item.dart';

class FriendSuggestion extends StatefulWidget {
  const FriendSuggestion({Key? key}) : super(key: key);

  @override
  _FriendSuggestionState createState() => _FriendSuggestionState();
}

class _FriendSuggestionState extends State<FriendSuggestion> {
  /*void _eraseFriendsList(int index) {
    setState(() {
      friend1s.removeAt(index);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    Future<List<FriendData>> fetchRootFriend() async {
      //todo: implement get root post (categorical post)
      return getFriends(Filter(search_type: "friend_suggestions"), getMyProfileId()).toList();
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: width / 41.1 , right: width / 41.1, top: height / 21.325, bottom: height / 85.3), ///(10 ,10, 40, 10)
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigate.popPage(context);
                  },
                  icon: const Icon(IconData(0xe094, fontFamily: 'MaterialIcons')),
                  color: Colors.black,
                  iconSize: height / 28.43, ///30
                ),
                Text(
                  suggestionString,
                  style: TextStyle(
                      fontSize: height / 28.43, fontWeight: FontWeight.bold), ///30
                ),
                IconButton(
                  onPressed: () {
                    Navigate.pushPage(context, const SearchPage(type: "user",));
                  },
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                  iconSize: height / 28.43, ///30
                  padding: const EdgeInsets.only(right: 0),
                ),
              ],
            ),
          ),

          const Divider(
            color: Colors.black54,
          ),
          SizedBox(
            height: height / 170.6, ///5
          ),

          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: width / 34.25, right: width / 34.25, top: height / 71.08), ///(12, 12, 12)
                      child: Row(
                        children: [
                          Text(
                            friendMayKnowString,
                            style: TextStyle(
                              fontSize: height / 34.12, ///25
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
                            var friendSuggestions = snapshot.data ?? [];
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: friendSuggestions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var friendItem = friendSuggestions[index];
                                  return FriendItem(
                                    id: friendItem.id,
                                    userAsset: friendItem.userAsset,
                                    name: friendItem.name,
                                    time: friendItem.time_string,
                                    mutualism: friendItem.mutualism,
                                    index: index,
                                    type: "suggestion",
                                  );
                                }
                            );
                          } else {
                            return const Center();
                          }
                        })
                  ],
                ),
              )
          )

        ],
      ),
    );
  }
}