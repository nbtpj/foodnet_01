import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/ui/screens/detailed_list/components/buid_components.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tuple/tuple.dart';

class DetailCateList extends StatefulWidget {
  late PostData cate;


  DetailCateList({Key? key, required this.cate}) : super(key: key);

  @override
  _DetailCateList createState() {
    return _DetailCateList();
  }
}

class _DetailCateList extends State<DetailCateList> {

  String keyword = "";
  Widget _build_header(BuildContext context) {
    return Row(
      children: [
        const ArrowBack(),
        _build_search(context)
      ],
    );
  }


  Stream<PostData> pseudoFullTextSearchByCate() async* {
    var foodSnapshot = await postsRef.where('cateList', arrayContains: widget.cate.title).get();
    List<Tuple2> scores = [];
    for (var doc in foodSnapshot.docs) {
      var post = doc.data();
      String txt = post.title+post.description;
      var similarity = keyword.toLowerCase().similarityTo(txt.toLowerCase());
      scores.add(Tuple2(similarity, post));

    }
    scores.sort((Tuple2 a, Tuple2 b) {
      return a.item1.compareTo(b.item1)*-1;
    });
    for(var tuple in scores){
      yield tuple.item2 as PostData;
    }
  }

  Widget _build_list(BuildContext context) {
    return FutureBuilder<List<PostData>>(
        future: pseudoFullTextSearchByCate().toList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PostData> ls = snapshot.data ?? [];
            var rows = [];
            int chunkSize = 2;
            for (var i = 0; i < ls.length; i += chunkSize) {
              rows.add(ls.sublist(
                  i, i + chunkSize > ls.length ? ls.length : i + chunkSize));
            }
            return ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  return build_pair(context, rows[index]);
                });
          } else {
            return loading;
          }
        });
  }

  Widget _build_search(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;

    return Container(
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
                left: width / 27.4, top: height / 85.3, bottom: height / 85.3),

            ///(15, 10, 10)
            border: InputBorder.none,
            isDense: true,
            hintText: search_food_hint_string),
        onChanged: (text) {

          setState(() {keyword=text;});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight / 24.37,
              ),
              _build_header(context),
              Expanded(child: _build_list(context))
            ],
          )
        ]));
  }
}
