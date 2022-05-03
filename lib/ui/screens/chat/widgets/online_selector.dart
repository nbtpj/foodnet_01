import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/screen/chat_screens.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/category_selector.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/favourite_contact.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/recent_chat.dart';
import 'package:foodnet_01/ui/screens/nav_bar.dart';
import 'package:foodnet_01/ui/screens/profile/profile.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

import '../model/user_model.dart';

class OnlineSelector extends StatefulWidget {
  const OnlineSelector({Key? key}) : super(key: key);

  @override
  _OnlineSelectorState createState() => _OnlineSelectorState();
}

class _OnlineSelectorState extends State<OnlineSelector> {
  @override
  Widget build(BuildContext context) {
    Future<List<User>> fetchOnlineUsers() async {
      //todo: implement get root post (categorical post)
      return getOnlineUsers().toList();
    }
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
          children: [
            FavoriteContacts(),
            Expanded(child: SingleChildScrollView(
                child: Column(
                  children: [
                    // FavoriteContacts(),
                    FutureBuilder<List<User>>(
                        future: fetchOnlineUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var onlines = snapshot.data ?? [];
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: onlines.length,
                                itemBuilder: (BuildContext context, int index){
                                  final User user = onlines[index];
                                  return GestureDetector(
                                      onTap: (){
                                        // final User user;
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                            ChatScreens(user: user,)));
                                      },
                                      child: Container(
                                          margin:const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                                          padding:const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 10.0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    // const   SizedBox(width: 40.0,),
                                                    CircleAvatar(radius: 35.0,
                                                      backgroundImage: AssetImage(user.imgURL),
                                                    ),
                                                    const   SizedBox(width: 20.0,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          user.name,
                                                          style:const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 25.0,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        const   SizedBox(height: 5.0,)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ]
                                          )
                                      )
                                  );
                                }
                            );
                          } else {
                            return const Center();
                          }
                        }
                    ),

                  ],
                )
            ))
          ],
        )
      )
    );
  }
}