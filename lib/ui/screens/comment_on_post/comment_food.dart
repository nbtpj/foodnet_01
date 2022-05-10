import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/edit_area.dart';
import 'package:foodnet_01/ui/screens/post_detail/components/arrow_back.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
// import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class CommentFood extends StatefulWidget {
  PostData food;

  CommentFood({Key? key, required this.food}) : super(key: key);

  @override
  _CommentFoodState createState() => _CommentFoodState();
}

class _CommentFoodState extends State<CommentFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      const ArrowBack(),
      Expanded(
        child: FutureBuilder<List<CommentData>>(
          future: fetch_comments(widget.food.id, 10).toList(),
          builder: (BuildContext context,
              AsyncSnapshot<List<CommentData>> snapshot) {
            var list_commend = snapshot.data ?? [];
            return ListView.builder(
              reverse: true,
              itemCount: list_commend.length,
              itemBuilder: (context, index) {
                  CommentData data = list_commend[index];
                  return CommentComponent(
                    comment: data,
                    isNet: true,
                  );
              },
            );
          },
        ),
      ),

      const Divider(),
      EditComment(),
    ]));
  }
}
