
import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';

import '../../../../util/entities.dart';

class RecentSearch extends StatefulWidget {
  final List<SearchData> searchList;
  const RecentSearch({
    Key? key,
    required this.searchList,
  }) : super(key: key);

  @override
  _RecentSearchState createState() => _RecentSearchState();
}

class _RecentSearchState extends State<RecentSearch> {

  buildRecentItem(String asset, String name) {
    return InkWell(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(asset),
        ),
        title: Text(name),
        trailing: IconButton(
          icon: const Icon(Icons.clear),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    const Text("Recent Search", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    Text("Clear All", style: TextStyle(fontSize: 22, color: buttonColor, )),
                  ],
                ),

                ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.searchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildRecentItem(widget.searchList[index].asset!, widget.searchList[index].name);
                    },
                ),
              ],
            ),
          ),
        )
    );
  }
}