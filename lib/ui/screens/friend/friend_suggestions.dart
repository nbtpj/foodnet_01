import 'package:flutter/material.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

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
    Future<List<FriendData>> fetchRootFriend() async {
      //todo: implement get root post (categorical post)
      return get_friends(Filter(search_type: "friend_suggestions")).toList();
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
                  "Gợi ý",
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

          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                      child: Row(
                        children: const [
                          Text(
                            "Những người bạn có thể biết",
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
                            var friendSuggestions = snapshot.data ?? [];
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 10,
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