import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

Widget buildSearchItem(BuildContext context, PostData post) {
  double height = SizeConfig.screenHeight;
  return InkWell(
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading:  CircleAvatar(
        radius: height / 42.65, ///20
        backgroundImage: NetworkImage(post.outstandingIMGURL),
      ),
      title: Text(post.title, softWrap: true,),
    ),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostDetailView(food: post)));
    },
  );
}