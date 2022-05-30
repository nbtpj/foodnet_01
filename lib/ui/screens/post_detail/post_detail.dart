import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/detail_widget.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/food_image.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class PostDetailView extends StatefulWidget {
  final PostData food;
  final Function? notifyParent;

  const PostDetailView({Key? key, required this.food, this.notifyParent}) : super(key: key);

  @override
  _PostDetailView createState() => _PostDetailView();
}

class _PostDetailView extends State<PostDetailView> {
  refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.food.commitReaction()
      .then((_) {
        widget.notifyParent!();
      });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            FoodImage(food: widget.food, notifyParent: refresh,),
            DetailWidget(food: widget.food),
          ],
        ),
      ),
    );
  }
}