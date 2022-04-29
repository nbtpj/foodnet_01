import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/navigate.dart';

import 'components/SearchList.dart';

class SearchPage extends StatefulWidget {
  final String type;

  const SearchPage({
    Key? key,
    required this.type,
  }) :super (key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isTextFieldEmpty = true;
  String keyword = "";

  @override
  Widget build(BuildContext context) {

    Future<List<SearchData>> fetchData(String type, String keyword) {
      return getSearchData(Filter(search_type: type, keyword: keyword)).toList();
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 35,),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigate.popPage(context);
                },
                icon: const Icon(IconData(0xe094, fontFamily: 'MaterialIcons')),
                color: Colors.black,
              ),
              Container(
                width: 348,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 15 ,top: 10, bottom: 10),
                      border: InputBorder.none,
                      isDense: true,
                      hintText: widget.type == "user" ? "Tìm kiếm người dùng"
                          : widget.type == "chat" ? "Tìm kiếm cuộc trò chuyện" : "Bạn muốn ăn gì?"
                  ),
                  onChanged: (text) {
                    keyword = text;
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

          FutureBuilder <List<SearchData>>(
              future: fetchData((isTextFieldEmpty && widget.type == "user") ? "recentUser" : widget.type,
                  keyword),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var searchList = snapshot.data ?? [];
                  return isTextFieldEmpty ? SearchList(searchList: searchList, type: "recentSearch",)
                      : SearchList(searchList: searchList, type: widget.type, keyword: keyword,);
                } else {
                  return const SizedBox(width: 0, height: 0,);
                }
              }
          ),

        ],
      ),
    );
  }

}