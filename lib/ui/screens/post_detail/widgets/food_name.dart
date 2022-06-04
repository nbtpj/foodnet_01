import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/category_view/cate_view.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FoodName extends StatefulWidget {
  PostData food;

  FoodName({Key? key, required this.food}) : super(key: key);

  @override
  _FoodNameState createState() => _FoodNameState();
}

class _FoodNameState extends State<FoodName> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(widget.food.title,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.screenHeight / 22.77,
                      fontFamily: "Roboto"))),
          FutureBuilder<ProfileData?>(
              future: widget.food.getOwner(),
              builder: (context, snap) => snap.hasData
                  ? FittedBox(
                      fit: BoxFit.fitWidth,
                      child: GestureDetector(
                          onTap: () {
                            /// todo: điều hướng đến trang người dùng
                          },
                          child: Text(snap.data?.name ?? None,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: SizeConfig.screenHeight / 40,
                                  fontFamily: "Roboto"))))
                  : const SizedBox.shrink()),
          // FittedBox(
          //     fit: BoxFit.fitWidth,
          //     child: GestureDetector(
          //         onTap: () {
          //           /// todo: điều hướng đến trang người dùng
          //         },
          //         child:  FutureBuilder<String>(future: widget.food.getOwner(),
          //                 builder: (context, snap)=>snap.hasData?
          //                 Text(snap.data??None,
          //                     style: TextStyle(
          //                         color: Colors.green,
          //                         fontSize: SizeConfig.screenHeight / 40,
          //                         fontFamily: "Roboto")):
          //                 const SizedBox.shrink()))),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  for (String cate in widget.food.cateList)
                    TextButton(
                        onPressed: () async {
                          var c = await categoriesRef
                              .where('title', isEqualTo: cate)
                              .get();
                          if (c.size > 0) {
                            var m = c.docs[0].data();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailCateList(cate: m)));
                          }
                        },
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(cate,
                                softWrap: true,
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 18))))
                ],
              )),
        ],
      ),
      const Spacer(),
      // Text("\$${widget.food.price}", style: TextStyle(color: Colors.black87, fontSize: SizeConfig.screenHeight/22.77),),  /// 30
    ]);
  }
}
