import 'package:flutter/material.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FoodName extends StatefulWidget {
  PostData food;
  FoodName({required this.food});

  @override
  _FoodNameState createState() => _FoodNameState();
}

class _FoodNameState extends State<FoodName> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(widget.food.title, style: TextStyle(color: Colors.black, fontSize: SizeConfig.screenHeight/22.77, fontFamily: "Roboto")),  /// 30
                Text((widget.food.cateList).join(", "), style: const TextStyle(color: Colors.black45, fontSize: 18)),
              ]
          ),
          const Spacer(),
          // Text("\$${widget.food.price}", style: TextStyle(color: Colors.black87, fontSize: SizeConfig.screenHeight/22.77),),  /// 30
        ]
    );
  }
}
