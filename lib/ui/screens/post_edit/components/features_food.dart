import 'package:flutter/material.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FeaturesFood extends StatefulWidget {
  PostData food;
  FeaturesFood({Key? key, required this.food}) : super(key: key);

  @override
  _FeaturesFoodState createState() => _FeaturesFoodState();
}

class _FeaturesFoodState extends State<FeaturesFood> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (var feats in widget.food.get_features())
              ContainerFeatures(
                  percent_text: feats[0], features_text: feats[1]),
          ],
        ));
  }
}

class ContainerFeatures extends StatelessWidget {
  String percent_text;
  String features_text;

  ContainerFeatures(
      {Key? key, required this.percent_text, required this.features_text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight / 13.66,

        /// 50.0
        width: SizeConfig.screenWidth / 4.11,

        /// 100.0
        margin: EdgeInsets.only(top: SizeConfig.screenHeight / 34.15),

        /// 20.0
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black12, width: SizeConfig.screenWidth / 205.5

                /// 2.0
                ),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              percent_text,
              style: TextStyle(color: Colors.black38),
            ),
            Text(features_text, style: TextStyle(color: Colors.black38))
          ],
        ));
  }
}
