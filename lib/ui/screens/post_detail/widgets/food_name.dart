import 'package:flutter/material.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FoodName extends StatefulWidget {
  PostData food;
  bool is_editting;
  FoodName({Key? key, required this.food, required this.is_editting}) : super(key: key);

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
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        for (String cate in widget.food.cateList)
                          GestureDetector(
                            onTap: (){},
                            child: Text(cate,style: const TextStyle(color: Colors.black45, fontSize: 18))
                          )
                      ],
                    )),
              ],
          ),
          const Spacer(),
          // Text("\$${widget.food.price}", style: TextStyle(color: Colors.black87, fontSize: SizeConfig.screenHeight/22.77),),  /// 30
        ]
    );
  }
}
