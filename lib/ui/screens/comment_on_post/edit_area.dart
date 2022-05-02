import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/comment_on_post/comment.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:image_picker/image_picker.dart';

class EditComment extends StatefulWidget {
  final editor = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  CommentData comment = CommentData(comment:"", mediaUrls: [], timestamp: DateTime.now());

  EditComment({Key? key}) : super(key: key);

  @override
  _EditComment createState() => _EditComment();
}

class _EditComment extends State<EditComment> {
  _buildCommentComposer(){
    return Container(
      height: 70.0,
      color: Colors.white,
      padding:const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          IconButton(onPressed: ()async{
            final List<XFile>? images =
            await widget._picker.pickMultiImage();
            setState(() {
              widget.comment.mediaUrls = [for (var img in images!) img.path ];
            });},
              icon: Icon(Icons.photo,size: 29.0,
                color: Theme.of(context).primaryColor,
              )),
           Expanded(child:TextField(
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: widget.editor,
            decoration: const InputDecoration(
                hintText: let_comment,
            ),
          )),
          IconButton(onPressed: (){
            setState(() async {
              widget.editor.clear();
              widget.comment.timestamp = DateTime.now();
              if(await widget.comment.post()){
                widget.comment = CommentData(comment:'', mediaUrls: [], timestamp: DateTime.now());
              }
            });
          },
              icon: Icon(Icons.send,size: 29.0,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    widget.editor.addListener(() {setState(() {
      widget.comment.comment = widget.editor.text;
    });});

    return SingleChildScrollView(child:
    Column(children: [
      !widget.comment.isEmpty()? CommentComponent(comment: widget.comment, isNet: false,):const SizedBox.shrink(),
      _buildCommentComposer()
      // ListTile(
      //         title: TextFormField(
      //           keyboardType: TextInputType.multiline,
      //           maxLines: null,
      //           controller: widget.editor,
      //           decoration: const InputDecoration(labelText: "Write a comment..."),
      //         ),
      //         trailing: SizedBox(
      //             height: SizeConfig.screenHeight / 22.0,
      //             width: SizeConfig.screenWidth / 6.0,
      //             child: ListView(scrollDirection: Axis.horizontal, children: [
      //               IconButton(
      //                 onPressed: () {
      //                   setState(() async {
      //                     widget.editor.clear();
      //                     widget.comment.timestamp = DateTime.now();
      //                     if(await widget.comment.post()){
      //                       widget.comment = CommentData(comment:'', mediaUrls: [], timestamp: DateTime.now());
      //                     }
      //                   });
      //                 },
      //                 // borderSide: BorderSide.none,
      //                 icon: const Icon(
      //                   Icons.send,
      //                 ),
      //                 iconSize: SizeConfig.screenWidth / 12.0,
      //               ),
      //               IconButton(
      //                 onPressed: () async {
      //                   // Pick images
      //                   final List<XFile>? images =
      //                   await widget._picker.pickMultiImage();
      //
      //                   setState(() {
      //
      //                     widget.comment.mediaUrls = [
      //                       for (var img in images!) img.path
      //                     ];
      //                   });
      //                 },
      //                 icon: const Icon(
      //                   Icons.image,
      //                 ),
      //                 iconSize: SizeConfig.screenWidth / 12.0,
      //               )
      //             ]))),
    ])
    );
  }
}
