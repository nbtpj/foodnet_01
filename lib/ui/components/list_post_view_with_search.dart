import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

Widget _build_food(BuildContext context, PostData food) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PostDetailView(food: food)));
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
                                      fontSize: SizeConfig.screenHeight / 42.69,

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

Widget build_pair(BuildContext context, List<PostData> foods) {
  return Row(
    children: [for (var food in foods) _build_food(context, food)],
  );
}

abstract class ListViewWithTextSearch<T extends StatefulWidget>
    extends State<T> {
  String keyword = "";
  final ScrollController _controller = ScrollController();

  Widget _build_header(BuildContext context) {
    return Row(
      children: [const ArrowBack(), _build_search(context)],
    );
  }

  Stream<PostData> pseudoFullTextSearch();

  Widget _build_list(BuildContext context) {
    return FutureBuilder<List<PostData>>(
        future: pseudoFullTextSearch().toList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PostData> ls = snapshot.data ?? [];
            var rows = [];
            int chunkSize = 2;
            for (var i = 0; i < ls.length; i += chunkSize) {
              rows.add(ls.sublist(
                  i, i + chunkSize > ls.length ? ls.length : i + chunkSize));
            }
            return ListView.builder(
                controller: _controller,
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  return build_pair(context, rows[index]);
                });
          } else {
            return loading;
          }
        });
  }

  Widget _build_search(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;

    return Container(
      width: width / 1.18,

      ///348
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(height / 34.12),

        ///25
      ),
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: width / 27.4, top: height / 85.3, bottom: height / 85.3),

            ///(15, 10, 10)
            border: InputBorder.none,
            isDense: true,
            hintText: search_food_hint_string),
        onChanged: (text) {
          setState(() {
            keyword = text;
          });
          _controller.animateTo(
            _controller.position.minScrollExtent,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight / 24.37,
              ),
              _build_header(context),
              Expanded(child: _build_list(context))
            ],
          )
        ]));
  }
}
