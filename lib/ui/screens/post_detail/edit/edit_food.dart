import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/media_viewer.dart';
import 'package:foodnet_01/ui/screens/post_detail/components/arrow_back.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:timeago/timeago.dart' as timeago;

class EditFood extends StatefulWidget {
  PostData food;

  EditFood({Key? key, required this.food}) : super(key: key);

  @override
  _EditFoodState createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  @override
  Widget build(BuildContext context) {
    final editor = TextEditingController();
    return Scaffold(
      // appBar: header(context, titleText: "Comments"),
      body: Column(
        children: <Widget>[
          const ArrowBack(),
          Expanded(
              child: ListView.builder(
                reverse: true,
                itemBuilder: (context, index) {
                  CommentData data = widget.food.getPreviousComment();
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(data.comment),
                        leading: GestureDetector(
                            onTap:(){
                              //todo
                            },
                            child:CircleAvatar(
                              backgroundImage: NetworkImage(data.avatarUrl),
                            )
                        ),
                        subtitle: Text(timeago.format(data.timestamp)),
                      ),
                      for(String element in data.mediaUrls) MediaAsset(url: element,),
                      const Divider(),
                    ],
                  );
                },
              )),
          const Divider(),
          ListTile(
            title: TextFormField(
              controller: editor,
              decoration: const InputDecoration(labelText: "Write a comment..."),
            ),
            trailing: OutlinedButton(
              onPressed: () {
                editor.clear();
              },
              // borderSide: BorderSide.none,
              child: const Text("Post"),
            ),
          ),
        ],
      ),
    );
  }
}
