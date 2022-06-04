import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/search_food/search.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:foodnet_01/util/navigate.dart';


class SearchFood extends StatefulWidget {
  const SearchFood({Key? key}) : super(key: key);

  @override
  _SearchFoodState createState() => _SearchFoodState();
}

class _SearchFoodState extends State<SearchFood> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth/20.55,                /// 20.0
            SizeConfig.screenHeight/85.375,              /// 8.0
            SizeConfig.screenWidth/85.375,                /// 20.0
            SizeConfig.screenHeight/85.375,              /// 8.0
        ),
        child: InkWell(
          onTap: (){
            Navigate.pushPage(context, const SearchFoodPage());
          },
          child: Container(
            height: SizeConfig.screenHeight/13.66,          /// 50.0
            width: SizeConfig.screenWidth/1.068,            /// 385.0
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.3),
                )
              ]
            ),
            child:Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.search, color: Colors.black26,),
                ),
                Text(search_string, style: TextStyle(color: Colors.black26, fontSize: SizeConfig.screenHeight/42.69))     /// 16
              ],
            )
          ),
        ),
      ),
    );
  }
}
