import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/list_post_view_with_search.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tuple/tuple.dart';

class DetailList extends StatefulWidget {
  late String name;
  final Filter? filter;
  DetailList({Key? key, required this.name, this.filter}) : super(key: key);

  @override
  _DetailList createState() {
    return _DetailList();
  }
}

class _DetailList extends ListViewWithTextSearch<DetailList> {
  @override
  Stream<PostData> pseudoFullTextSearch() async* {
    var foodSnapshot = widget.filter!=null ? await getPosts(widget.filter!).toList():await detail_list_fetcher(widget.name).toList();
    List<Tuple2> scores = [];
    for (var doc in foodSnapshot) {
      String txt = doc.title + doc.description;
      var similarity = keyword.toLowerCase().similarityTo(txt.toLowerCase());
      scores.add(Tuple2(similarity, doc));
    }
    scores.sort((Tuple2 a, Tuple2 b) {
      return a.item1.compareTo(b.item1) * -1;
    });
    for (var tuple in scores) {
      yield tuple.item2 as PostData;
    }
  }
}
