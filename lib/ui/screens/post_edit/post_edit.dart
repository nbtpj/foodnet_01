import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_edit/widgets/detail_widget.dart';
import 'package:foodnet_01/ui/screens/post_edit//widgets/food_image.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class PostEditView extends StatefulWidget {
  PostData food;
  PostEditView({required this.food});

  @override
  _PostEditView createState() => _PostEditView();
}

class _PostEditView extends State<PostEditView> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            FoodImage(food: widget.food),
            DetailWidget(food: widget.food),
          ],
        ),
      ),
    );
  }
}