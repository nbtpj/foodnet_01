import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment_food.dart';
import 'package:foodnet_01/ui/screens/home/home.dart';
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
    return Column(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CommentFood(food: widget.food,)));
          },
          icon: const Icon(Icons.comment, color: Colors.white),
          color: Colors.white,
          iconSize: SizeConfig.screenHeight / 22.77,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              widget.food.changeReact();
            });
          },
          icon: widget.food.getReact() == 1
              ? const Icon(Icons.favorite, color: Colors.white)
              : widget.food.getReact() == 0 ? const Icon(
              Icons.favorite_outline, color: Colors.white) :
          const Icon(Icons.heart_broken, color: Colors.white),
          color: Colors.white,
          iconSize: SizeConfig.screenHeight / 22.77,
        )
      ],
    );
  }
}
