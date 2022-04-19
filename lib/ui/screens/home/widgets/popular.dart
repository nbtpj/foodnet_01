import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/post_detail/post_detail.dart';
import 'package:foodnet_01/util/constants/colors.dart';
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
    return get_posts(Filter(search_type: 'food')).toList();
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
                return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailView(food: food)));
                    },
                    child: Stack(
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                SizeConfig.screenWidth/34.25,             /// 12.0
                                SizeConfig.screenHeight/113.84,           /// 6.0
                                SizeConfig.screenWidth/34.25,             /// 12.0
                                SizeConfig.screenHeight/22.77             /// 30.0
                            ),
                            height: SizeConfig.screenHeight/3.105,        /// 220.0
                            width: SizeConfig.screenWidth/2.74,           /// 150.0
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Colors.black.withOpacity(0.3),
                                  )
                                ]),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: SizeConfig.screenHeight/6.83,         /// 100.0
                                      width: SizeConfig.screenWidth/2.74,           /// 150.0
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "${food.outstandingIMGURL}"),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                            topRight: Radius.circular(30.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${food.title}",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: SizeConfig.screenHeight/34.15,       /// 20
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${food.cateList.join(',')}",
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: SizeConfig.screenHeight/42.69,      /// 16
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(top: SizeConfig.screenHeight/136.6),   /// 5.0
                                            child: Text(
                                              "\$${food.price}",
                                              style: TextStyle(
                                                  color: buttonColor,
                                                  fontSize: SizeConfig.screenHeight/37.95,    /// 18
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: SizeConfig.screenHeight/13.66,          /// 50.0
                                    width: SizeConfig.screenWidth/8.22,             /// 50.0
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(30.0),
                                            topLeft: Radius.circular(30.0),
                                        )
                                    ),
                                    child: Icon(
                                      Icons.shopping_cart_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  );
              },
            ),
          );
        }
        else{
          return Center();
        }
      },
    );
  }
}
