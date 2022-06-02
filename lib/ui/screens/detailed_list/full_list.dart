import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/list_post_view_with_search.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
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
      case my_favorite_string:
        var foodSnapshot =  await postsRef.get();
        for (var doc in foodSnapshot.docs) {
          var d = doc.data();
          if (await d.getReact()==1){
            yield d;
          }
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
class _DetailList extends ListViewWithTextSearch<DetailList> {
  @override
  Stream<PostData> pseudoFullTextSearch() async*{
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
}
