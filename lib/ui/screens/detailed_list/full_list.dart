import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/screens/home/components/food_part.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class DetailList extends StatefulWidget {
  late String name;

  Stream<PostData> _fetcher() async* {
    switch (name) {
      case my_post_string:
        var foodSnapshot = await postsRef
            .where('author_uid', isEqualTo: getMyProfileId())
            .limit(10)
            .get();
        for (var doc in foodSnapshot.docs) {
          yield doc.data();
        }
        break;

      case popular_string:
        var foodSnapshot =
            await postsRef.orderBy('react', descending: true).limit(10).get();
        for (var doc in foodSnapshot.docs) {
          yield doc.data();
        }
        break;
      default:
        var foodSnapshot = await postsRef.limit(10).get();
        for (var doc in foodSnapshot.docs) {
          yield doc.data();
        }
    }
  }

  DetailList({Key? key, required this.name}) : super(key: key);

  @override
  _DetailList createState() {
    return _DetailList();
  }
}

class _DetailList extends State<DetailList> {
  Widget _build_food(BuildContext context, PostData food) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostDetailView(food: food)));
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth / 34.25,
                SizeConfig.screenHeight / 113.84,
                SizeConfig.screenWidth / 34.25,
                SizeConfig.screenHeight / 22.77),
            height: SizeConfig.screenHeight / 3.105,
            width: SizeConfig.screenWidth / 2.3,
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
                      width: SizeConfig.screenWidth / 2.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(food.outstandingIMGURL),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          FutureBuilder<ProfileData?>(
                              future: food.getOwner(),
                              builder: (context, snap) => snap.hasData
                                  ? FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(snap.data?.name ?? None,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize:
                                                  SizeConfig.screenHeight / 40,
                                              fontFamily: "Roboto")))
                                  : const Center()),
                          food.cateList.isNotEmpty
                              ? FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    food.cateList.join(','),
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize:
                                            SizeConfig.screenHeight / 42.69,

                                        /// 16
                                        fontWeight: FontWeight.w400),
                                  ))
                              : const SizedBox.shrink(),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight / 136.6),

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
                food.isGood
                    ? Positioned(
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
                              )),
                          child: const Icon(
                            Icons.shopping_cart_rounded,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_pair(BuildContext context, List<PostData> foods) {
    return Row(
      children: [for (var food in foods) _build_food(context, food)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.deepOrangeAccent,
                child: Row(
                  children: [
                    const ArrowBack(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          SizeConfig.screenWidth / 27.4,

                          /// 15.0
                          SizeConfig.screenHeight / 68.3,

                          /// 10.0
                          SizeConfig.screenWidth / 41.1,

                          /// 10.0
                          SizeConfig.screenHeight / 68.3

                        /// 10.0
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                              child: Text(
                                widget.name,
                                style: TextStyle(
                                    fontSize: SizeConfig.screenHeight / 34.15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              )

                            /// 20.0
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black45,
                            size: SizeConfig.screenHeight / 21.35,
                          )

                          /// 32.0
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
          child:
          FutureBuilder<List<PostData>>(
            future: widget._fetcher().toList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PostData> ls = snapshot.data ?? [];
                print('debug 1');
                print(ls.toList());
                var rows = [];
                int chunkSize = 2;
                for (var i = 0; i < ls.length; i += chunkSize) {
                  rows.add(ls.sublist(
                      i,
                      i + chunkSize > ls.length
                          ? ls.length
                          : i + chunkSize));
                }
                return ListView.builder(
                  // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      return _build_pair(context, rows[index]);
                    });
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
          ]
      ),
    );
  }
}