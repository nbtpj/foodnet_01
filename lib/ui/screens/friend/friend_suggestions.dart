import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/search/search.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

import '../../../util/navigate.dart';
import '../../components/friend_item.dart';

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
      return get_friends(Filter(search_type: "friend_suggestions")).toList();
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
                  "Gợi ý",
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
                            "Những người bạn có thể biết",
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
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: height / 85.3, ///10
                                  );
                                },
                                itemCount: friendSuggestions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var friendItem = friendSuggestions[index];
                                  return FriendSuggestionItem(
                                    userAsset: friendItem.userAsset,
                                    name: friendItem.name,
                                    mutualism: friendItem.mutualism!,
                                    index: friendItem.id!,
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