import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/favourite_contact.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/recent_chat.dart';

class MessagesSelector extends StatefulWidget {
  const MessagesSelector({Key? key}) : super(key: key);

  @override
  _MessagesSelectorState createState() => _MessagesSelectorState();
}

class _MessagesSelectorState extends State<MessagesSelector> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: Container(
              decoration:const BoxDecoration(
                color: Color(0xFFFDF8E9),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)
                ),
              ),
              child: Column(
                children:  <Widget>[
                  FavoriteContacts(),
                  RecentChats(),
                ],
              ),
            ),
          );
  }
}