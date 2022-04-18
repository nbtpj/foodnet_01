import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/AuthWrapperHome.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:foodnet_01/ui/screens/home/components/food_part.dart';
import 'package:foodnet_01/ui/screens/home/widgets/discount_cart.dart';
import 'package:foodnet_01/ui/screens/home/widgets/popular.dart';
import 'package:foodnet_01/ui/screens/home/widgets/recommed.dart';
import 'package:foodnet_01/ui/screens/home/widgets/search_food.dart';
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
    SizeConfig().init(context);
    return Scaffold(
      appBar:
          AppBar(title: Text(name), automaticallyImplyLeading: false, actions: [
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const AuthWrapperHome();
              }));
            },
            icon: const Icon(Icons.logout))
      ]),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // UserNameText(),
            SearchFood(),
            DiscountCard(),
            FoodPart(partName: "Categories"),
            CategoriesFood(),
            FoodPart(partName: "Recommed"),
            RecommedFoods(),
            FoodPart(partName: "Popular"),
            PopularFoods(),
          ],
        ),
      ),
    );
  }
}
