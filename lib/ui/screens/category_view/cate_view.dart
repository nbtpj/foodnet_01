import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/list_post_view_with_search.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
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

class _DetailCateList extends ListViewWithTextSearch<DetailCateList>{
  @override
  Stream<PostData> pseudoFullTextSearch() async*{
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

}

