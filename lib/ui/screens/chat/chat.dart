import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/category_selector.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/favourite_contact.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/recent_chat.dart';
import 'package:foodnet_01/ui/screens/home/home.dart';
import 'package:foodnet_01/ui/screens/nav_bar.dart';


class Chat extends StatefulWidget {
  @override
  State<Chat> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon:const Icon(
            Icons.arrow_back,
          ),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
        title:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:const[
            Text("FoodNet",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
              ),  ),
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon:const Icon(
              Icons.search,
            ),
            onPressed: (){
              // TODO: search user
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const  CategorySelector(),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}