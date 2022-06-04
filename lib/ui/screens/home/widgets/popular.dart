import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/food_thumb.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class PopularFoods extends StatefulWidget {
  const PopularFoods({Key? key}) : super(key: key);

  @override
  _PopularFoodsState createState() => _PopularFoodsState();
}

class _PopularFoodsState extends State<PopularFoods> {
  Future<List<PostData>> fetchPopularPost() async{
    //todo: implement get popular post (categorical post)
    return getPosts(Filter(search_type: 'popular_food')).toList();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostData>>(
      future: fetchPopularPost(),
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
