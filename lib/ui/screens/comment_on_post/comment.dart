import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/media_viewer.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/media_list_scroll_view.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentComponent extends StatefulWidget{
  late CommentData comment;
  late bool isNet;
  CommentComponent({Key? key, required this.comment, this.isNet=true}) : super(key: key);
  @override
  _CommentComponent createState() => _CommentComponent();
  }

class _CommentComponent extends State<CommentComponent>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(widget.comment.comment),
          leading: GestureDetector(
              onTap: () {
                //todo
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.comment.avatarUrl),
              )
          ),
          subtitle: Text(timeago.format(widget.comment.timestamp)),
        ),

        widget.comment.mediaUrls.isNotEmpty? MediaList(children: [for(String element in widget.comment.mediaUrls) MediaAsset(
          url: element,isNet: widget.isNet,)]):const SizedBox.shrink(),

        const Divider(),
      ],
    );
  }
}