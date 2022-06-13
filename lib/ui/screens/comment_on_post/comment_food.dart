import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment.dart';
import 'package:foodnet_01/util/constants/animations.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:image_picker/image_picker.dart';

import '../../../util/constants/colors.dart';
import '../../../util/constants/strings.dart';
import '../../../util/navigate.dart';

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
                notify(uploading_string);
                widget.comment.timestamp = DateTime.now();
                widget.comment.post().then((t) {
                  if (t) {
                    setState(() {
                      widget.editor.clear();
                      notify(upload_success);
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
    double height = SizeConfig.screenHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        toolbarHeight: height / 12.186, ///70
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.white,
          iconSize: height / 28.43, ///30
          onPressed: () {
            Navigate.popPage(context);
          },
        ),
      ),
        body: Column(children: <Widget>[
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
                              notify(delete_success);
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
