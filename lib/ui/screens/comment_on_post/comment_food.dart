import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/components/image_provider.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/edit_area.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

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
      Row(
        children: const [
          Positioned(left: 0, top: 0, child: ArrowBack()),
        ],
      ),
      Expanded(
        child: FutureBuilder<List<CommentData>>(
          future: fetch_comments(widget.food.id, 0, 10).toList(),
          builder: (BuildContext context,
              AsyncSnapshot<List<CommentData>> snapshot) {
            List<CommentData> listCommend;
            if (snapshot.hasData){
              listCommend = snapshot.data ?? [];
            } else{
              listCommend = [];
            }


            print("comment list");
            print(snapshot);
            return Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                image: DecorationImage(
                    image: NetworkImage(widget.food.outstandingIMGURL),
                    fit: BoxFit.cover),
              ),
              child: ListView.builder(
                reverse: true,
                itemCount: listCommend.length,
                itemBuilder: (context, index) {
                  CommentData data = listCommend[index];
                  return CommentComponent(
                    comment: data,
                    isNet: true,
                  );
                },
              ),
            );
          },
        ),
      ),
      const Divider(),
      getMyProfileId() != null // login requirement
          ? EditComment(food: widget.food)
          : SizedBox.shrink(),
    ]));
  }
}
