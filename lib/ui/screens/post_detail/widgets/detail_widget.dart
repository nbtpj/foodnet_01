import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/components/features_food.dart';
import 'package:foodnet_01/ui/screens/post_detail/components/review.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/addtocart_button.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/food_description.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/increase_decrease_button.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'food_name.dart';

class DetailWidget extends StatefulWidget {
  PostData food;

  DetailWidget({Key? key, required this.food}) : super(key: key);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.35),
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black54, blurRadius: 10, offset: Offset(0, -1))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: widget.food.isGood
              ? [
                  Container(
                    width: SizeConfig.screenWidth / 3.43,

                    /// 120.0
                    height: SizeConfig.screenHeight / 227.67,

                    /// 3.0
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 34.15,
                  ),

                  /// 20.0
                  FoodName(food: widget.food),
                  ReviewStars(food: widget.food),
                  FeaturesFood(food: widget.food),
                  FoodDescription(food: widget.food),
                  IncreaseDecrease(food: widget.food),
                  AddToCartButton(food: widget.food)
                ]
              : [
                  Container(
                    width: SizeConfig.screenWidth / 3.43,

                    /// 120.0
                    height: SizeConfig.screenHeight / 227.67,

                    /// 3.0
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 34.15,
                  ),

                  /// 20.0
                  FoodName(food: widget.food),
                  ReviewStars(food: widget.food),
                  FeaturesFood(food: widget.food),
                  FoodDescription(food: widget.food),
                ],
        ),
      ),
    );
  }
}
