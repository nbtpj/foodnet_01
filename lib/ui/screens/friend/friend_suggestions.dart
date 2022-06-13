import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
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

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    Future<List<ProfileData>> fetchRootFriend() async {
      return Relationship.friendRecommend(getMyProfileId(), null).toList();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigate.popPage(context);
          },
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          iconSize: height / 28.43,
          padding: const EdgeInsets.only(right: 10),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: height / 12.186, ///70
        title: Center(
          child: Text(
            suggestionString,
            style: TextStyle(
              fontSize: height / 30.464, ///28
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigate.pushPage(
                  context,
                  const SearchPage(
                    type: "user",
                  ));
            },
            color: Colors.black,
            icon: const Icon(Icons.search),
            iconSize: height / 28.43,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: height / 50,
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

                    SizedBox(height: height / 50,),

                    FutureBuilder<List<ProfileData>>(
                        future: fetchRootFriend(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting){
                            return loading;
                          }
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