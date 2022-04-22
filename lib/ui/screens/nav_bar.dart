import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/friend/friend_invitations.dart';
import 'package:foodnet_01/ui/screens/home/home.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/global.dart';




class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screen = [
    Home(),
    // SearchPageView(),
    // CartView(),
    // FavoritePageView(),
    // ProfilePageView(),
    Friends(),
  ];
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    final items = [
      Icon(Icons.home, size: SizeConfig.screenHeight/22.77),          /// 30.0
      // Icon(Icons.search, size: SizeConfig.screenHeight/22.77),
      // Icon(Icons.shopping_cart, size: SizeConfig.screenHeight/22.77),
      // Icon(Icons.favorite, size: SizeConfig.screenHeight/22.77),
      Icon(Icons.people, size: SizeConfig.screenHeight/22.77),
    ];
    Size size = MediaQuery.of(context).size;
    return Container(
      color: buttonColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: screen[index],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(color: Colors.white)
            ),
            child: CurvedNavigationBar(
              key: navigationKey,
              color: Colors.black45,
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: buttonColor,
              height: SizeConfig.screenHeight/11.39,               /// 60.0
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 400),
              index: index,
              items: items,
              onTap: (index) => setState(() => this.index = index),
            ),
          ),
        ),
      ),
    );
  }
}
