import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/food_thumb.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class MyFavoriteFoods extends StatefulWidget {
  const MyFavoriteFoods({Key? key}) : super(key: key);

  @override
  _MyFavoriteFoodsState createState() => _MyFavoriteFoodsState();
}

class _MyFavoriteFoodsState extends State<MyFavoriteFoods> {
  Future<List<PostData>> fetchFavoritePost() async{
    return getPosts(Filter(search_type: 'favorite')).toList();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostData>>(
      future: fetchFavoritePost(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          var foodList = snapshot.data ?? [];
          return SizedBox(
            height: SizeConfig.screenHeight/2.28,                 /// 300.0
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodList.length ,
              itemBuilder: (context, index){
                var food = foodList[index];
                return build_a_food_thumb(context, food);
              },
            ),
          );
        }
        else{
          return CircularProgressIndicator();

          // return const Center();
        }
      },
    );
  }
}
