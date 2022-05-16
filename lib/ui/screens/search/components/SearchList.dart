// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/profile/profile.dart';
import 'package:foodnet_01/util/constants/colors.dart';

import '../../../../util/entities.dart';
import '../../../../util/global.dart';
import '../../../../util/navigate.dart';

class SearchList extends StatefulWidget {
  final List<SearchData> searchList;
  final String type;
  final String? keyword;
  final bool? isResult;
  const SearchList({
    Key? key,
    required this.searchList,
    required this.type,
    this.keyword,
    this.isResult,
  }) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {

  buildListItem(String asset, String name, String type) {
    double height = SizeConfig.screenHeight;
    return InkWell(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: asset == "icon" ? Icon(Icons.access_time, size: height / 21.325,) ///40
        : CircleAvatar(
          radius: height / 42.65, ///20
          backgroundImage: AssetImage(asset),
        ),
        title: Text(name),
        trailing: IconButton(
          icon: Icon(type == "recentSearch" ? Icons.clear : Icons.arrow_forward),
          onPressed: () {},
        ),
      ),
      onTap: () {
        if (widget.type == "user" || (widget.type == "recentSearch" && asset != "icon")) {
          Navigate.pushPage(context, const ProfilePage(type: 'other', id: '1',));
        }
      },
    );
  }

  buildResultItem(String asset, String name, String type) {
    double height = SizeConfig.screenHeight;
    return InkWell(
      child: ListTile(
        isThreeLine: true,
        contentPadding: EdgeInsets.zero,
        leading: asset == "icon" ?  Icon(Icons.access_time, size: height / 21.325,) ///40
            : CircleAvatar(
          radius: height / 28.43, ///30
          backgroundImage: AssetImage(asset),
        ),
        title: Text(
            name,
            style: TextStyle(
              fontSize: height / 42.65, ///20
            ),
        ),
        subtitle: const Text("Bạn bè - Trường Đại học Công nghệ Đại học quốc gia Hà Nội - Sống tại Hà Nội"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(width / 41.1, height / 56.87, width / 41.1, height / 56.87), ///(10, 15, 10, 15)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.type == "recentSearch" ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("Tìm kiếm gần đây", style: TextStyle(fontSize: height / 38.77, fontWeight: FontWeight.bold),), ///22
                    Text("Xoá tất cả", style: TextStyle(fontSize: height / 38.77, color: buttonColor, )), ///22
                  ],
                ) : widget.isResult != null && widget.isResult!
                    ? Text("Kết quả", style: TextStyle(fontSize: height / 38.77, fontWeight: FontWeight.bold),) ///22
                    : const SizedBox(width: 0, height: 0,),

                ListView.builder(
                    padding: EdgeInsets.only(top: height / 85.3), ///10
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.searchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (widget.isResult != null && widget.isResult!) {
                        return buildResultItem(widget.searchList[index].asset!, widget.searchList[index].name, widget.type);
                      } else {
                        return buildListItem(widget.searchList[index].asset == null ? "icon" : widget.searchList[index].asset!, widget.searchList[index].name, widget.type);
                      }
                    },
                ),

                SizedBox(height: height / 85.3,), ///10

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
                            fontSize: height / 47.39, ///18
                            color: buttonColor,
                          ),
                        ),
                        TextSpan(
                          text: widget.keyword,
                          style: TextStyle(
                            fontSize: height / 47.39, ///18
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