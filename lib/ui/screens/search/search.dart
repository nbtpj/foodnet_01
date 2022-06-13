import 'package:flutter/material.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/navigate.dart';

import '../../../util/constants/strings.dart';
import '../../../util/global.dart';
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
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;

    Stream<RecentUserSearchData> fetchRecentUserData() {
        return getRecentUsers(getMyProfileId());
    }

    Future<List<ProfileData>> fetchData(String type, String keyword) {
        return searchUser(keyword, null);
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: height / 24.37,), ///35
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
                width: width / 1.18, ///348
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(height / 34.12),  ///25
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: width / 27.4 ,top: height / 85.3, bottom: height / 85.3), ///(15, 10, 10)
                      border: InputBorder.none,
                      isDense: true,
                      hintText: widget.type == "user" ? searchUserString
                          : searchConversation,
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

          (isTextFieldEmpty == true && widget.type == "user") ?
          FutureBuilder <List<RecentUserSearchData>?> (
              future: fetchRecentUserData().toList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var searchList = snapshot.data ?? [];
                  return SearchList(recentData: searchList, type: widget.type);
                } else {
                  return const SizedBox(width: 0, height: 0,);
                }
              }
          ) : FutureBuilder <List<ProfileData>?>(
              future: fetchData(widget.type, keyword),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var searchList = snapshot.data ?? [];
                  return SearchList(searchList: searchList, keyword: keyword, type: widget.type);
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