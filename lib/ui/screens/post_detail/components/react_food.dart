import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment_food.dart';
import 'package:foodnet_01/ui/screens/post_edit/post_edit.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FavoriteFood extends StatefulWidget {
  final PostData food;
  Future<int>? futureReact;
  final Function notifyParent;
  FavoriteFood({Key? key, required this.food, required this.notifyParent}) : super(key: key);

  @override
  _FavoriteFoodState createState() => _FavoriteFoodState();
}

class _FavoriteFoodState extends State<FavoriteFood> {
  @override
  void initState() {
    widget.futureReact = widget.food.getReact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommentFood(
                          food: widget.food,
                        )));
          },
          icon: const Icon(Icons.comment, color: Colors.white),
          color: Colors.white,
          iconSize: SizeConfig.screenHeight / 22.77,
        ),
        FutureBuilder<int>(
            future: widget.futureReact,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      widget.food.changeReact();
                      widget.notifyParent();
                    });
                  },
                  icon: widget.food.react == 1
                      ? const Icon(Icons.favorite, color: Colors.white)
                      : widget.food.react == 0
                      ? const Icon(Icons.favorite_outline, color: Colors.white)
                      : const Icon(Icons.heart_broken, color: Colors.white),
                  color: Colors.white,
                  iconSize: SizeConfig.screenHeight / 22.77,
                );
              } else {
                return const Center();
              }
            })
        ,
        widget.food.isEditable()
            ? IconButton(
                onPressed: () {
                  /// todo: điều hướng đến trang chỉnh sửa
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostEditForm(
                                food: widget.food,
                              )));
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                color: Colors.white,
                iconSize: SizeConfig.screenHeight / 22.77,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
