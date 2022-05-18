import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/messages_selector.dart';
import 'package:foodnet_01/ui/screens/nav_bar.dart';

import '../../../util/navigate.dart';
import '../search/search.dart';


class Chat extends StatefulWidget {
  @override
  State<Chat> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:const Icon(
            Icons.arrow_back,
            color: Colors.black
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
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),  ),
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon:const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: (){
              Navigate.pushPage(context, const SearchPage(type: "chat",));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(),
          MessagesSelector()
        ],
      )
    );
  }
}