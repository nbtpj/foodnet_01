import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/detail_widget.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/food_image.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/food_image.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class PostDetailView extends StatefulWidget {
  PostData food;
  bool is_editting = false;
  PostDetailView({required this.food});

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
            FoodImage(food: widget.food),
            DetailWidget(food: widget.food,),
          ],
        ),
      ),
    );
  }
}