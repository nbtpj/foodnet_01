import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/discovery/map_discovery.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
                    Icons.favorite,
                    color: textColor,
                  ),
                  Text(
                    "${widget.food.getUpvoteRate()}",
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenHeight / 45.54),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.heart_broken,
                    color: textColor,
                  ),
                  Text(
                    "${widget.food.getDownvoteRate()}",
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
                    child: Text("${widget.food.getNumRate()} Reviews",
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
              widget.food.getLocationName() == null
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Discovery(
                                      init_state: CameraPosition(
                                        target: widget.food.positions(),
                                        zoom: 16,
                                      ),
                                    )));
                      },
                      child: Row(
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
                          FutureBuilder<String?>(
                              future: widget.food.getLocationName(),
                              builder: (context, snapshot) => Text(
                                    snapshot.hasData
                                        ? snapshot.data ?? None
                                        : None,
                                    style: TextStyle(
                                        color: freeDelivery,
                                        fontWeight: FontWeight.bold,
                                        // overflow: TextOverflow.fade,
                                        fontSize:
                                            SizeConfig.screenHeight / 44.69),
                                  ))

                          /// 16
                        ],
                      ))
            ],
          ),
        ));
  }
}
