import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

Widget build_a_food_thumb_no_tap(PostData food) {
  return Stack(
    children: [
      Container(
        margin: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth / 34.25,
            SizeConfig.screenHeight / 113.84,
            SizeConfig.screenWidth / 34.25,
            SizeConfig.screenHeight / 22.77),
        height: SizeConfig.screenHeight / 3.105,
        width: SizeConfig.screenWidth / 2.74,
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
                  width: SizeConfig.screenWidth / 2.74,
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
                      SizedBox(
                        height: SizeConfig.screenHeight / 35,
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              food.title,
                              // softWrap: true,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: SizeConfig.screenHeight / 36.15,
                                  fontWeight: FontWeight.w700),
                            )),
                      )
                      ,
                      FutureBuilder<ProfileData?>(
                          future: food.getOwner(),
                          builder: (context, snap) =>
                          snap.hasData
                              ? SizedBox(
                              height: SizeConfig.screenHeight / 40,
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(snap.data?.name ?? None,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize:
                                          SizeConfig.screenHeight / 40,
                                          fontFamily: "Roboto"))))
                              : const SizedBox.shrink()),
                      food.cateList.isNotEmpty
                          ? SizedBox(
                          height: SizeConfig.screenHeight / 40,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                food.cateList.join(','),
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize:
                                    SizeConfig.screenHeight / 42.69,

                                    /// 16
                                    fontWeight: FontWeight.w400),
                              )))
                          : SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight / 136.6),
                        child: SizedBox(
                            height: SizeConfig.screenHeight / 30,
                            child: Text(
                              "${food.price}$current_string",
                              softWrap: true,
                              style: TextStyle(
                                  color: buttonColor,
                                  fontSize: SizeConfig.screenHeight / 37.95,
                                  fontWeight: FontWeight.bold),
                            )),
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
  );
}

Widget build_a_food_thumb(BuildContext context, PostData food) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PostDetailView(food: food)));
    },
    child: build_a_food_thumb_no_tap(food),
  );
}

Widget build_a_food_thumb_by_id(BuildContext context, String postId) {
  return FutureBuilder<PostData?>(
    future: getPost(postId),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data != null) {
        return build_a_food_thumb(context, snapshot.data!);
      } else {
        if (snapshot.data == null) {
          return const SizedBox.shrink();
        }
        return loading;
      }
    },
  );
}
