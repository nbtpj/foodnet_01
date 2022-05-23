import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:image_picker/image_picker.dart';

class EditComment extends StatefulWidget {
  final editor = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late PostData food;
  late CommentData comment;

  EditComment({Key? key, required this.food}) : super(key: key) {
    comment = CommentData(
        postID: food.id,
        userID: getMyProfileId()!,
        commentID: "new",
        comment: "",
        mediaUrls: [],
        timestamp: DateTime.now());
  }

  @override
  _EditComment createState() => _EditComment();
}

class _EditComment extends State<EditComment> {
  _buildCommentComposer() {
    return Container(
      height: 70.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () async {
                final List<XFile>? images =
                    await widget._picker.pickMultiImage();

                print('current comment media');
                print(widget.comment.mediaUrls);
                print('_______________');
                setState(() {
                  widget.comment.mediaUrls = [
                    for (var img in images!) img.path
                  ];
                });
              },
              icon: Icon(
                Icons.photo,
                size: 29.0,
                color: Theme.of(context).primaryColor,
              )),
          Expanded(
              child: TextField(
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: widget.editor,
            decoration: const InputDecoration(
              hintText: let_comment,
            ),
          )),
          IconButton(
              onPressed: () {
                setState(() async {
                  widget.editor.clear();
                  widget.comment.timestamp = DateTime.now();
                  if (await widget.comment.post()) {
                    widget.comment = CommentData(
                        postID: widget.food.id,
                        userID: getMyProfileId()!,
                        commentID: "new",
                        comment: '',
                        mediaUrls: [],
                        timestamp: DateTime.now());
                  }
                });
              },
              icon: Icon(
                Icons.send,
                size: 29.0,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.editor.addListener(() {
      setState(() {
        widget.comment.comment = widget.editor.text;
      });
    });

    return SingleChildScrollView(
        child: Column(children: [
      !widget.comment.isEmpty()
          ? CommentComponent(
              comment: widget.comment,
              isNet: false,
            )
          : const SizedBox.shrink(),
      _buildCommentComposer()
    ]));
  }
}
