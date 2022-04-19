import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class DiscountCard extends StatefulWidget {
  const DiscountCard({Key? key}) : super(key: key);

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  final List<String> imageList = [
    "assets/discount/discount1.png",
    "assets/discount/discount2.png",
    "assets/discount/discount3.png",
  ];
  Future<List<PostData>> fetchDiscountGood() async{
    //todo: implement get discount post (categorical post)
    return get_posts(Filter(search_type: 'food')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight/34.15, bottom: SizeConfig.screenHeight/68.3),    /// 20.0 - 10.0
      child: FutureBuilder<List<PostData>>(
        future: fetchDiscountGood(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return SizedBox(
              height: SizeConfig.screenHeight/3.415,               /// 200.0
              width: SizeConfig.screenWidth,                        /// 411.0
              child: CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  autoPlay: false,
                ),
                items: imageList.map((e) => ClipRRect(
                  borderRadius : BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(e, fit: BoxFit.cover,)
                    ],
                  ),
                )).toList(),
              ),
            );
          }
          else{
            return Center();
          }
        },
      ),
    );
  }
}