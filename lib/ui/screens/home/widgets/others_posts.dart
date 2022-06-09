import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/food_thumb.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class OtherFoods extends StatefulWidget {
  final String? id;
  const OtherFoods({Key? key, this.id,}) : super(key: key);

  @override
  _OtherFoodsState createState() => _OtherFoodsState();
}

class _OtherFoodsState extends State<OtherFoods> {
  Future<List<PostData>> fetchMyPost() async {
    return getPosts(Filter(search_type: 'others', keyword: widget.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostData>>(
      future: fetchMyPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var foodList = snapshot.data ?? [];
          return SizedBox(
            height: SizeConfig.screenHeight / 2.28,

            /// 300.0
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                var food = foodList[index];
                return build_a_food_thumb(context, food);
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
          // return const Center();
        }
      },
    );
  }
}
