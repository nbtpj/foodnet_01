import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/ui/screens/post_edit/post_edit.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class MyFoods extends StatefulWidget {
  const MyFoods({Key? key}) : super(key: key);

  @override
  _MyFoodsState createState() => _MyFoodsState();
}

class _MyFoodsState extends State<MyFoods> {
  Future<List<PostData>> fetchMyPost() async {
    //todo: implement get My post (categorical post)
    return getPosts(Filter(search_type: 'my_food')).toList();
  }

  Widget _build_add_new(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            PostEditForm(food: PostData(
                title: add_title, description: add_description, ))));
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth / 34.25,

                /// 12.0
                SizeConfig.screenHeight / 113.84,

                /// 6.0
                SizeConfig.screenWidth / 34.25,

                /// 12.0
                SizeConfig.screenHeight / 22.77

              /// 30.0
            ),
            height: SizeConfig.screenHeight / 3.105,

            /// 220.0
            width: SizeConfig.screenWidth / 2.74,

            /// 150.0
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
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
                      height: SizeConfig.screenHeight / 6.83,

                      /// 100.0
                      width: SizeConfig.screenWidth / 2.74,

                      /// 150.0
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Thêm một bài đăng mới",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: SizeConfig.screenHeight / 34.15,

                                    /// 20
                                    fontWeight: FontWeight.w700),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_food(BuildContext context, PostData food) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => PostDetailView(food: food)));
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth / 34.25,

                /// 12.0
                SizeConfig.screenHeight / 113.84,

                /// 6.0
                SizeConfig.screenWidth / 34.25,

                /// 12.0
                SizeConfig.screenHeight / 22.77

              /// 30.0
            ),
            height: SizeConfig.screenHeight / 3.105,

            /// 220.0
            width: SizeConfig.screenWidth / 2.74,

            /// 150.0
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
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
                      height: SizeConfig.screenHeight / 6.83,

                      /// 100.0
                      width: SizeConfig.screenWidth / 2.74,

                      /// 150.0
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              food.outstandingIMGURL),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                food.title,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: SizeConfig.screenHeight / 34.15,

                                    /// 20
                                    fontWeight: FontWeight.w700),
                              )),
                           FutureBuilder<ProfileData?>(future: food.getOwner(),
                              builder: (context, snap)=>snap.hasData?
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child:Text(snap.data?.name ??None,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: SizeConfig.screenHeight / 40,
                                      fontFamily: "Roboto"))):
                              const SizedBox.shrink()),
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                food.cateList.join(','),
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: SizeConfig.screenHeight / 42.69,

                                    /// 16
                                    fontWeight: FontWeight.w400),
                              )),
                          Padding(
                            padding:
                            EdgeInsets.only(top: SizeConfig.screenHeight /
                                136.6),

                            /// 5.0
                            child: Text(
                              "${food.price}",
                              style: TextStyle(
                                  color: buttonColor,
                                  fontSize: SizeConfig.screenHeight / 37.95,

                                  /// 18
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                food.isGood ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: SizeConfig.screenHeight / 13.66,

                    /// 50.0
                    width: SizeConfig.screenWidth / 8.22,

                    /// 50.0
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        )
                    ),
                    child: const Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white,
                    ),
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
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
              itemCount: foodList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _build_add_new(context);
                } else {
                  var food = foodList[index - 1];
                  return _build_food(context, food);
                }
              },
            ),
          );
        }
        else {
          return const Center();
        }
      },
    );
  }
}
