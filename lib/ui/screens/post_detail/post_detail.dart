import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/detail_widget.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/food_image.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class PostDetailView extends StatefulWidget {
  PostData food;
  bool is_editting;
  PostDetailView({required this.food, this.is_editting=false});

  @override
  _PostDetailView createState() => _PostDetailView();
}

class _PostDetailView extends State<PostDetailView> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            FoodImage(food: widget.food, is_editting: widget.is_editting,),
            DetailWidget(food: widget.food,is_editting: widget.is_editting,),
          ],
        ),
      ),
    );
  }
}