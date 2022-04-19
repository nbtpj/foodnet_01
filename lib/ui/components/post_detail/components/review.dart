import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class ReviewStars extends StatefulWidget {
  PostData food;

  ReviewStars({Key? key, required this.food}) : super(key: key);

  @override
  _ReviewStarsState createState() => _ReviewStarsState();
}

class _ReviewStarsState extends State<ReviewStars> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight / 45.54),

        /// 15.0
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: textColor,
                  ),
                  Text(
                    "${widget.food.get_rate()}",
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenHeight / 45.54),
                  ),

                  /// 15.0
                  Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.screenWidth / 51.38),

                    /// 8.0
                    child: Text("${widget.food.get_num_rate()} Reviews",
                        style: TextStyle(color: Colors.black26)),
                  )
                ],
              ),
              Container(
                height: SizeConfig.screenHeight / 34.15,
                width: SizeConfig.screenWidth / 137,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth / 51.38),

                        /// 8.0
                        child: Icon(
                          Icons.location_pin,
                          color: freeDelivery,
                          size: SizeConfig.screenHeight / 22.77,
                        ),
                      ),
                      Text(
                        widget.food.get_location_name(),
                        style: TextStyle(
                            color: freeDelivery,
                            fontWeight: FontWeight.bold,
                            // overflow: TextOverflow.fade,
                            fontSize: SizeConfig.screenHeight / 44.69),
                      )

                      /// 16
                    ],
                  )
            ],
          ),
        )
    );
  }
}
