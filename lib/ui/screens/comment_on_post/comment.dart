import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodnet_01/ui/components/media_viewer.dart';
import 'package:foodnet_01/ui/components/media_list_scroll_view.dart';
import 'package:foodnet_01/ui/screens/profile/profile.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/navigate.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentComponent extends StatefulWidget {
  late CommentData comment;
  late bool isNet;
  bool is_editing = false;

  CommentComponent(
      {Key? key,
      required this.comment,
      this.isNet = true,
      this.is_editing = false})
      : super(key: key);

  @override
  _CommentComponent createState() => _CommentComponent();

  String get userID {
    return "1";
  }
}

class _CommentComponent extends State<CommentComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(widget.comment.comment),
          leading: GestureDetector(
              onTap: () {
                Navigate.pushPage(context,
                    ProfilePage(type: "other", id: widget.comment.userID));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.comment.avatarUrl),
              )),
          subtitle: Text(timeago.format(widget.comment.timestamp)),
        ),
        widget.comment.mediaUrls.isNotEmpty
            ? MediaList(children: [
                for (String element in widget.comment.mediaUrls)
                  GestureDetector(
                    child: MediaWidget(
                      url: element,
                      isNet: widget.isNet,
                    ),
                    onTap: () {
                      setState(() {
                        widget.comment.mediaUrls.remove(element);
                        Fluttertoast.showToast(
                            msg: delete_success,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    },
                  )
              ])
            : const SizedBox.shrink(),
        const Divider(),
      ],
    );
  }
}
