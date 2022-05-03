import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/model/message_model.dart';
import 'package:foodnet_01/ui/screens/chat/model/user_model.dart';
import 'package:foodnet_01/util/entities.dart';


class ChatScreens extends StatefulWidget {
  final User user;
  const ChatScreens( {Key? key, required this.user,  }) : super(key: key);


  @override
  _ChatScreensState createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {

  _buildMessage(Message message ,bool isMe){
    final msg =  Container(
      margin: isMe ? const EdgeInsets.only(top:8.0 ,bottom:8.0, left: 80.0 )
          :const EdgeInsets.only(top:8.0 ,bottom:8.0,  ),
      padding:const EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color:isMe ?const Color(0xFFFDF8E9) : Colors.blue.shade50,
        borderRadius:isMe ?const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0)
        ) : const BorderRadius.only(
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.time,
            style:const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          const  SizedBox(height: 8.0,),
          Text(message.text,
            style:const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );

    if(isMe){
      return msg;
    }

    return Row(
      children: [
        msg,
        IconButton(onPressed: (){}, icon:message.isLiked ?const Icon(
          Icons.favorite_border,
          size: 29.0,
          color: Colors.blueGrey,
        ) : Icon(
          Icons.favorite,
          size: 29.0,
          color: message.isLiked ? Colors.blueGrey : Colors.red,
        ) ) ,
      ],
    );
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
                hintText: "Xabar jo'natish..."
            ),
          )),
          IconButton(onPressed: (){},
              icon: Icon(Icons.send,size: 29.0,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    final User user;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.user.name),
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
              child: Container(
                  decoration:const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: ClipRRect(
                    borderRadius:const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    child: ListView.builder(
                        reverse: true,
                        padding:const EdgeInsets.only(top: 15.0),
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index){
                          final Message message = messages[index];
                          final bool isMe = message.sender.id == currentUser.id;
                          return _buildMessage(message , isMe);
                        }),
                  )
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
