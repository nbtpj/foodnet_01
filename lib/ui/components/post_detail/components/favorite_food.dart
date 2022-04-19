import 'package:flutter/material.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FavoriteFood extends StatefulWidget {
  PostData food;

  FavoriteFood({Key? key, required this.food}) : super(key: key);

  @override
  _FavoriteFoodState createState() => _FavoriteFoodState();
}

class _FavoriteFoodState extends State<FavoriteFood> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return IconButton(
      onPressed: () {
        setState(() {
          widget.food.change_react();
          });
      },
      icon: widget.food.get_react() == 1
          ? const Icon(Icons.favorite, color: Colors.white)
          : widget.food.get_react() == 0 ? const Icon(
          Icons.favorite_outline, color: Colors.white) :
      const Icon(Icons.heart_broken, color: Colors.white),
      color: Colors.white,
      iconSize: SizeConfig.screenHeight / 22.77,
    );
  }
}
