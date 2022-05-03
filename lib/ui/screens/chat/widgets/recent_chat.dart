import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/model/message_model.dart';
import 'package:foodnet_01/ui/screens/chat/screen/chat_screens.dart';
import 'package:foodnet_01/util/entities.dart';

class RecentChats extends StatelessWidget {

  const RecentChats({Key? key, }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Container(
        decoration:const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0)
          ),
        ),
        child: ClipRRect(
          borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0)
          ),
          child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index){
                final Message  chat = chats[index];
                return GestureDetector(
                  onTap: (){
                    // final User user;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                        ChatScreens(user: chat.sender,)));
                  },
                  child: Container(
                    margin:const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                    padding:const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 10.0),
                    decoration: BoxDecoration(
                      color: chat.unread ? Colors.blue.shade50 : Colors.white,
                      borderRadius:const BorderRadius.only(
                        topRight:Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: <Widget>[
                            CircleAvatar(radius: 35.0,
                              backgroundImage: AssetImage(chat.sender.imgURL),),
                            const   SizedBox(width: 10.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat.sender.name,
                                  style:const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const   SizedBox(height: 5.0,),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  child: Text(chat.text,
                                    style:const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(chat.time,
                              style:const TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const  SizedBox(height: 5.0,),
                            chat.unread ?  Container(
                              width: 40.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child:const Text("NEW",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              alignment: Alignment.center,
                            ) : Text(""),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}