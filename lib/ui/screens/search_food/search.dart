import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/ui/screens/search_food/components/build_components.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:foodnet_01/util/navigate.dart';

class SearchFoodPage extends StatefulWidget {
  const SearchFoodPage({
    Key? key,
  }) : super(key: key);

  @override
  _SearchFoodPageState createState() => _SearchFoodPageState();
}

class _SearchFoodPageState extends State<SearchFoodPage> {
  bool isTextFieldEmpty = true;
  String keyword = "";

  Widget _build_result_list(BuildContext context) {
    double height = SizeConfig.screenHeight;
    return FutureBuilder<List<SearchPostData>>(
        future: searchPost(keyword),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SearchPostData> data = snapshot.data!;
            return Padding(
                padding: EdgeInsets.only(left: height / 85.3),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, idx) =>
                        buildSearchItem(context, data[idx])),
            );
          } else {
            return loading;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height / 24.37,
          ),

          ///35
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigate.popPage(context);
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
              ),
              Container(
                width: width / 1.18,

                ///348
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(height / 34.12),

                  ///25
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: width / 27.4,
                          top: height / 85.3,
                          bottom: height / 85.3),

                      ///(15, 10, 10)
                      border: InputBorder.none,
                      isDense: true,
                      hintText: search_food_hint_string),
                  onChanged: (text) {
                    keyword = text;
                    setState(() {});
                    if (text == "") {
                      setState(() {
                        isTextFieldEmpty = true;
                      });
                    } else {
                      setState(() {
                        isTextFieldEmpty = false;
                      });
                    }
                  },
                ),
              )
            ],
          ),
          Expanded(child: _build_result_list(context))
        ],
      ),
    );
  }
}
