import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/components/arrow_back.dart';
import 'package:foodnet_01/ui/screens/post_detail/components/react_food.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FoodImage extends StatefulWidget {
  PostData food;
  bool is_editting;
  FoodImage({required this.food, required this.is_editting});

  @override
  _FoodImageState createState() => _FoodImageState();
}

class _FoodImageState extends State<FoodImage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.screenHeight * 0.45,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        image: DecorationImage(
            image: AssetImage(widget.food.outstandingIMGURL),
            fit: BoxFit.fitWidth
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth/13.7, vertical: SizeConfig.screenHeight/34.15),     /// 30.0 - 20.0
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArrowBack(),
              // CommentFood(food: widget.food),
              FavoriteFood(food: widget.food, is_edditing: widget.is_editting,),
            ],
          ),
        ),
      ),
    );
  }
}
