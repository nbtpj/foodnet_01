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

class DetailList extends StatefulWidget {
  late String name;

  Stream<PostData> _fetcher() async* {
    switch (name) {
      case my_post_string:
        var foodSnapshot = await postsRef
            .where('author_uid', isEqualTo: getMyProfileId())
            .get();
        for (var doc in foodSnapshot.docs) {
          yield doc.data();
        }
        break;

      case popular_string:
        var foodSnapshot =
            await postsRef.orderBy('react', descending: true).limit(10).get();
        for (var doc in foodSnapshot.docs) {
          yield doc.data();
        }
        break;
      default:
        var foodSnapshot = await postsRef.get();
        for (var doc in foodSnapshot.docs) {
          yield doc.data();
        }
    }
  }

  DetailList({Key? key, required this.name}) : super(key: key);

  @override
  _DetailList createState() {
    return _DetailList();
  }
}

class _DetailList extends State<DetailList> {

  Widget _build_list(BuildContext context) {
    return FutureBuilder<List<PostData>>(
        future: pseudoFullTextSearch().toList(),
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
  String keyword = "";
  Widget _build_header(BuildContext context) {
    return Row(
      children: [
        const ArrowBack(),
        _build_search(context)
      ],
    );
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



  Stream<PostData> pseudoFullTextSearch() async* {
    var foodSnapshot = await widget._fetcher().toList();
    List<Tuple2> scores = [];
    for (var doc in foodSnapshot) {
      String txt = doc.title+doc.description;
      var similarity = keyword.toLowerCase().similarityTo(txt.toLowerCase());
      scores.add(Tuple2(similarity, doc));

    }
    scores.sort((Tuple2 a, Tuple2 b) {
      return a.item1.compareTo(b.item1)*-1;
    });
    for(var tuple in scores){
      yield tuple.item2 as PostData;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children:
            [Column(
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight / 24.37,
                ),
                _build_header(context),
                // Row(children: const [ArrowBack()],),
                Expanded(child: _build_list(context)
                )
              ],
            )
        ])
    );
  }
}
