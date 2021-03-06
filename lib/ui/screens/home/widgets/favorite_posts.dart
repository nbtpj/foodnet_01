import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/food_thumb.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class MyFavoriteFoods extends StatefulWidget {
  const MyFavoriteFoods({Key? key}) : super(key: key);

  @override
  _MyFavoriteFoodsState createState() => _MyFavoriteFoodsState();
}

class _MyFavoriteFoodsState extends State<MyFavoriteFoods> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<ReactionData>>(
      stream: get_my_reaction_list(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ReactionData> postReactions =
              snapshot.data!.docs.map((e) => e.data()).toList();
          if (postReactions.isEmpty) {
            return SizedBox(
              height: SizeConfig.screenHeight / 7,
            );
          }
          return SizedBox(
            height: SizeConfig.screenHeight / 2.28,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: postReactions.length,
              itemBuilder: (context, index) {
                var postId = postReactions[index].postId;
                return build_a_food_thumb_by_id(context, postId);
              },
            ),
          );
        } else {
          return loading;
        }
      },
    );
  }
}
