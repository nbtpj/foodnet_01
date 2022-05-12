import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/media_viewer.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/edit_area.dart';
import 'package:foodnet_01/ui/screens/post_detail/components/arrow_back.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_picker/image_picker.dart';


class CommentFood extends StatefulWidget {
  PostData food;

  CommentFood({Key? key, required this.food}) : super(key: key);

  @override
  _CommentFoodState createState() => _CommentFoodState();
}

class _CommentFoodState extends State<CommentFood> {
  @override
  Widget build(BuildContext context) {;
    return  Scaffold(
        body:
        Column(
          children: <Widget>[
            ArrowBack(),
            Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    CommentData data = widget.food.getPreviousComment();
                    return CommentComponent(comment: data,isNet: false,);
                  },
                )),
            const Divider(),
            EditComment(),
          ]
      )
    );
  }
}
