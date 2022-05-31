import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class RecommendFoods extends StatefulWidget {
  const RecommendFoods({Key? key}) : super(key: key);

  @override
  _RecommendFoodsState createState() => _RecommendFoodsState();
}

class _RecommendFoodsState extends State<RecommendFoods> {
  Future<List<PostData>> fetchRecommendPost() async {
    //todo: implement get popular post (categorical post)
    return getPosts(Filter(search_type: 'food')).toList();
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {});
    }
    return FutureBuilder<List<PostData>>(
      future: fetchRecommendPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var foodList = snapshot.data ?? [];
          return SizedBox(
            height: SizeConfig.screenHeight / 2.58,

            /// 265.0
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                var food = foodList[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailView(food: food, notifyParent: refresh)));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          SizeConfig.screenWidth / 34.25,

                          /// 12.0
                          SizeConfig.screenHeight / 170.75,

                          /// 4.0
                          SizeConfig.screenWidth / 41.1,

                          /// 10.0
                          SizeConfig.screenHeight / 170.75,

                          /// 4.0
                        ),
                        height: SizeConfig.screenHeight / 2.73,

                        /// 250.0
                        width: SizeConfig.screenWidth / 2.055,

                        /// 200.0
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(4, 6),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.3),
                              )
                            ]),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(food.outstandingIMGURL),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Positioned(
                                left: SizeConfig.screenWidth / 34.25,

                                /// 12.0
                                bottom: SizeConfig.screenHeight / 45.54,

                                /// 15.0
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(food.title,
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenHeight / 34.15,
                                            color: Colors.white)),

                                    /// 20
                                    Text(food.cateList.join(', '),
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenHeight / 48.79,
                                            color: Colors.white)),

                                    /// 14
                                    Text("\$${food.price}",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenHeight / 37.95,
                                            color: Colors.white))

                                    /// 18
                                  ],
                                )),
                            FutureBuilder<int>(
                              future: food.getReact(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final react = snapshot.data!;
                                  return Positioned(
                                      top: SizeConfig.screenHeight / 68.3,

                                      /// 10.0
                                      right: SizeConfig.screenWidth / 41.1,

                                      /// 10.0
                                      child: react == 1
                                          ? const Icon(Icons.favorite,
                                          color: Colors.white)
                                          : react == 0
                                          ? const Icon(Icons.favorite_outline,
                                          color: Colors.white)
                                          : const Icon(Icons.heart_broken,
                                          color: Colors.white));
                                } else {
                                  return Positioned(
                                      top: SizeConfig.screenHeight / 68.3,

                                      /// 10.0
                                      right: SizeConfig.screenWidth / 41.1,
                                      child: loading
                                  );
                                }
                              }
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
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
