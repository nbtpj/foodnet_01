
import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';

import '../../../../util/entities.dart';

class SearchList extends StatefulWidget {
  final List<SearchData> searchList;
  final String type;
  final String? keyword;
  const SearchList({
    Key? key,
    required this.searchList,
    required this.type,
    this.keyword,
  }) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {

  buildListItem(String asset, String name, String type) {
    return InkWell(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: asset == "icon" ? const Icon(Icons.access_time, size: 40,)
        : CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(asset),
        ),
        title: Text(name),
        trailing: IconButton(
          icon: Icon(type == "recentSearch" ? Icons.clear : Icons.arrow_forward),
          onPressed: () {  },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.type == "recentSearch" ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    const Text("Recent Search", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    Text("Clear All", style: TextStyle(fontSize: 22, color: buttonColor, )),
                  ],
                ) : const SizedBox(width: 0, height: 0,),

                ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.searchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListItem(widget.searchList[index].asset == null ? "icon" : widget.searchList[index].asset!, widget.searchList[index].name, widget.type);
                    },
                ),

                const SizedBox(height: 10,),
                
                widget.keyword == null ? const SizedBox(width: 0, height: 0,)
                    : RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      children: [
                        TextSpan(
                          text:  "Xem kết quả cho ",
                          style: TextStyle(
                            fontSize: 18,
                            color: buttonColor,
                          ),
                        ),
                        TextSpan(
                          text: widget.keyword,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: buttonColor,
                          ),
                        )
                      ]
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}