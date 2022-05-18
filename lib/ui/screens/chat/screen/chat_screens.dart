import 'package:flutter/material.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';


class ChatScreens extends StatefulWidget {
  final String userId;
  const ChatScreens( {Key? key, required this.userId,  }) : super(key: key);


  @override
  _ChatScreensState createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {

  _buildMessage(Message message, bool isMe){
    final msg =  Container(
      margin: isMe ? const EdgeInsets.only(top:8.0 ,bottom:8.0, left: 80.0 )
          :const EdgeInsets.only(top:8.0 ,bottom:8.0, right: 80.0 ),
      padding:const EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color:isMe ? Colors.lightBlueAccent : Colors.black12,
        borderRadius : BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('10:00',//'$message.createdAt',
            style:const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
            ),
          ),
          const  SizedBox(height: 8.0,),
          Text(message.message,
            style:const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );

    if(isMe){
      return msg;
    }

    return msg;
  }

  _buildMessageComposer(){
    return Container(
      height: 70.0,
      color: Colors.white,
      padding:const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          IconButton(onPressed: (){},
              icon: Icon(Icons.photo,size: 29.0,
                color: Theme.of(context).primaryColor,
              )),
          const  Expanded(child:TextField(
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                hintText: "Message"
            ),
          )),
          IconButton(
              onPressed: (){

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
    Future<List<Message>> fetchMessages() async {
      return getMessages(widget.userId).toList();
    }

    return FutureBuilder<ProfileData>(
      future: getProfile(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ProfileData? user = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user!.name,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon:const Icon(
                    Icons.more_horiz,
                  ),
                  onPressed: (){},
                ),
              ],
            ),
            body: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<Message>>(
                      future: fetchMessages(),
                      builder: (contex, snapshot) {
                        if (snapshot.hasData) {
                          var messages = snapshot.data;
                          return Container(
                              decoration:const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                child: ListView.builder(
                                    reverse: true,
                                    padding:const EdgeInsets.only(top: 15.0),
                                    itemCount: messages!.length,
                                    itemBuilder: (BuildContext context, int index){
                                      final Message message = messages[index];
                                      final bool isMe = message.userId == getMyProfileId();
                                      return _buildMessage(message , isMe);
                                    }),
                              )
                          );
                        } else {
                          return const Center();
                        }
                      },
                    ),
                  ),
                  _buildMessageComposer(),
                ],
              ),
            ),
          );
        } else {
          return const Center();
        }
      }
    );
  }
}
