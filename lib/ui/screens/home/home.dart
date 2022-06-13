import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/chat.dart';
import 'package:foodnet_01/ui/screens/detailed_list/full_list.dart';
import 'package:foodnet_01/ui/screens/home/components/food_part.dart';
import 'package:foodnet_01/ui/screens/home/widgets/favorite_posts.dart';
import 'package:foodnet_01/ui/screens/home/widgets/my_posts.dart';
import 'package:foodnet_01/ui/screens/home/widgets/popular.dart';
import 'package:foodnet_01/ui/screens/home/widgets/recommend.dart';
import 'package:foodnet_01/ui/screens/home/widgets/recommend_on_top.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/global.dart';

import '../../../util/navigate.dart';
import '../search_food/search.dart';
import 'widgets/categories.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String name = currentUser?.displayName ?? "default user";

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigate.pushPage(context, const SearchFoodPage());
          },
          color: Colors.white,
          icon: const Icon(Icons.search),
          iconSize: height / 28.43,
          padding: const EdgeInsets.only(right: 10),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: buttonColor,
        toolbarHeight: height / 12.186, ///70
        title: Center(
          child: Text(
            homePageString,
            style: TextStyle(
              fontSize: height / 30.464, ///28
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigate.pushPage(context, Chat());
              },
              color: Colors.white,
              icon: const Icon(Icons.message),
              iconSize: height / 28.43,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 85.3,),
            // UserNameText(),

            const DiscountCard(),
            FoodPart(partName: tag_string),
            const CategoriesFood(),

            GestureDetector(
              onTap: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return DetailList(name: recommend_string);
                }));
              },
              child: FoodPart(partName: recommend_string),
            ),
            const RecommendFoods(),
            GestureDetector(
              onTap: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return DetailList(name: popular_string);
                }));
              },
              child: FoodPart(partName: popular_string),
            ),
            const PopularFoods(),

            GestureDetector(
                onTap: () async {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return DetailList(
                      name: my_post_string,
                    );
                  }));
                },
                child: FoodPart(partName: my_post_string)),
            getMyProfileId() != null ?  PostByAuthor() : const SizedBox.shrink(),
            GestureDetector(
                onTap: () async {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return DetailList(
                      name: my_favorite_string,
                    );
                  }));
                },
                child: FoodPart(partName: my_favorite_string)),
            getMyProfileId() != null
                ? const MyFavoriteFoods()
                : const SizedBox.shrink(), // login requirement
          ],
        ),
      ),
    );
  }
}
