import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/category_selector.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/favourite_contact.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/recent_chat.dart';
import 'package:foodnet_01/ui/screens/nav_bar.dart';

class OnlineSelector extends StatefulWidget {
  const OnlineSelector({Key? key}) : super(key: key);

  @override
  _OnlineSelectorState createState() => _OnlineSelectorState();
}

class _OnlineSelectorState extends State<OnlineSelector> {
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
        child: FavoriteContacts()
      ),
    );
  }
}