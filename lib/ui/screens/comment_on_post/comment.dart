import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodnet_01/ui/components/media_list_scroll_view.dart';
import 'package:foodnet_01/ui/components/media_viewer.dart';
import 'package:foodnet_01/ui/screens/profile/profile.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/navigate.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentComponent extends StatefulWidget {
  late CommentData comment;
  late bool isNet;
  bool is_editing = false;

  CommentComponent({Key? key,
    required this.comment,
    this.isNet = true,
    this.is_editing = false})
      : super(key: key);

  @override
  _CommentComponent createState() => _CommentComponent();

  String get userID {
    return comment.userID;
  }
}

class _CommentComponent extends State<CommentComponent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileData?>(
        future: getProfile(widget.comment.userID),
        builder: (context, snapshot) {
          print('current comment id is '+widget.comment.userID);
          print(snapshot);
          print('_________________________');
          if (snapshot.hasData
              // && snapshot.data!=null
          ) {
            print('current user of comment is'+widget.comment.userID);
            print(snapshot.data);

            ProfileData data = snapshot.data!;
            print('current user of comment is');
            print(data);
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(widget.comment.comment),
                  leading: GestureDetector(
                      onTap: () {
                        Navigate.pushPage(context,
                            ProfilePage(id: widget.comment.userID));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data.userAsset),
                      )),
                  subtitle: Text(timeago.format(widget.comment.timestamp)),
                ),
                widget.comment.mediaUrls.isNotEmpty
                    ? MediaList(children: [
                  for (String element in widget.comment.mediaUrls)
                    MediaWidget(
                      url: element,
                      isNet: widget.isNet,
                    )
                ])
                    : const SizedBox.shrink(),
                const Divider(),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        }
    );
  }
}
