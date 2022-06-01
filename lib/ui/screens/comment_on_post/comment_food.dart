import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:image_picker/image_picker.dart';

import '../../../util/constants/strings.dart';

class CommentFood extends StatefulWidget {
  PostData food;
  late CommentData comment;
  final editor = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  CommentFood({Key? key, required this.food}) : super(key: key) {
    comment = CommentData(
        postID: food.id,
        userID: getMyProfileId(),
        commentID: "new",
        comment: "",
        mediaUrls: [],
        timestamp: DateTime.now());
  }

  @override
  CommentFoodState createState() => CommentFoodState();
}
// todo: update realtime + sort by time

class CommentFoodState extends State<CommentFood> {
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
                Fluttertoast.showToast(
                    msg: uploading_string,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0);
                widget.comment.timestamp = DateTime.now();
                widget.comment.post().then((t) {
                  if (t) {
                    setState(() {
                      widget.editor.clear();
                      Fluttertoast.showToast(
                          msg: upload_success,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      widget.comment = CommentData(
                          postID: widget.food.id,
                          userID: getMyProfileId(),
                          commentID: "new",
                          comment: '',
                          mediaUrls: [],
                          timestamp: DateTime.now());
                    });
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

  Widget _build_edit_area(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Row(
        children: const [
          Positioned(left: 0, top: 20, child: ArrowBack()),
        ],
      ),
      Expanded(
        child: FutureBuilder<List<CommentData>>(
          future: fetch_comments(widget.food.id).toList(),
          builder: (BuildContext context,
              AsyncSnapshot<List<CommentData>> snapshot) {
            List<CommentData> listCommend;
            if (snapshot.hasData) {
              listCommend = snapshot.data ?? [];
            } else {
              listCommend = [];
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    image: NetworkImage(widget.food.outstandingIMGURL),
                    fit: BoxFit.cover),
              ),
              child: ListView.builder(
                reverse: true,
                itemCount: listCommend.length,
                itemBuilder: (context, index) {
                  CommentData data = listCommend[index];
                  return GestureDetector(
                      onLongPress: () async {
                        if (data.userID == getMyProfileId()) {
                          bool t = await data.delete();
                          setState(() {
                            if (t) {
                              Fluttertoast.showToast(
                                  msg: delete_success,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          });
                        }
                      },
                      child: CommentComponent(
                        comment: data,
                        isNet: true,
                      ));
                },
              ),
            );
          },
        ),
      ),
      const Divider(),
      getMyProfileId() != null // login requirement
          ? _build_edit_area(context)
          : const SizedBox.shrink(),
    ]));
  }
}
