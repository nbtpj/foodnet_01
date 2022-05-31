import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../util/data.dart';
import '../../../util/entities.dart';
import '../../../util/global.dart';
import '../../../util/navigate.dart';
import 'components/SearchList.dart';

class SearchResult extends StatefulWidget {
  final String keyWord;
  final String type;

  const SearchResult({
    Key? key,
    required this.keyWord,
    required this.type,
}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();

}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    Future<List<SearchData>> fetchData(String type, String keyword) {
      return getSearchData(Filter(search_type: type, keyword: keyword)).toList();
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
                icon: const Icon(IconData(0xe094, fontFamily: 'MaterialIcons')),
                color: Colors.black,
              ),
              Container(
                width: width / 1.18, ///348
                height: height / 24.37, ///35
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(height / 34.12),  ///25
                ),
                child: Container(
                  margin: EdgeInsets.only(top: height / 85.3, left: width / 41.1),
                  child: Text(widget.keyWord, textAlign: TextAlign.left,),
                ),
              ),

            ],
          ),

          FutureBuilder <List<SearchData>>(
              future: fetchData(widget.type, widget.keyWord),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var searchList = snapshot.data ?? [];
                  return SearchList(searchList: searchList, type: widget.type, isResult: true);
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