import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/media_viewer.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FoodDescription extends StatelessWidget {
  PostData food;
  bool is_editting;
  FoodDescription({Key? key, required this.food, required this.is_editting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight / 45.54),

        /// 15.0
        child: Column(
          children: [
            for(String element in food.mediaUrls) MediaWidget(url: element,isNet: true,),
            Text(
              food.description,
              style: const TextStyle(color: Colors.black38),
              textAlign: TextAlign.justify,
            ),
          ],
        )

        );
  }
}
