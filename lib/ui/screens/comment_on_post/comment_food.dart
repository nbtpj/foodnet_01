import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/components/arrow_back.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/ui/screens/home/home.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/detail_widget.dart';
import 'package:foodnet_01/ui/screens/post_detail/widgets/food_image.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentFood extends StatefulWidget {
  PostData food;

  CommentFood({Key? key, required this.food}) : super(key: key);

  @override
  _CommentFoodState createState() => _CommentFoodState();
}

class _CommentFoodState extends State<CommentFood> {
  @override
  Widget build(BuildContext context) {
    final editor = TextEditingController();
    return Scaffold(
      // appBar: header(context, titleText: "Comments"),
      body: Column(
        children: <Widget>[
          ArrowBack(),
          Expanded(
              child: ListView.builder(
            reverse: true,
            itemBuilder: (context, index) {
              CommentData data = widget.food.get_a_previous_comment();
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(data.comment),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(data.avatarUrl),
                    ),
                    subtitle: Text(timeago.format(data.timestamp)),
                  ),
                  Divider(),
                ],
              );
            },
          )),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: editor,
              decoration: InputDecoration(labelText: "Write a comment..."),
            ),
            trailing: OutlineButton(
              onPressed: () {
                editor.clear();
              },
              borderSide: BorderSide.none,
              child: Text("Post"),
            ),
          ),
        ],
      ),
    );
  }
}
