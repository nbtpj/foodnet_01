import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/utils.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

class ChatScreens extends StatefulWidget {
  final String userId;
  const ChatScreens({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _ChatScreensState createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  TextEditingController messageController = TextEditingController();
  bool isLoading = false;

  _buildMessage(Message message, bool isMe) {
    final msg = Container(
      margin: isMe
          ? const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Colors.lightBlueAccent : Colors.black12,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTimeAgo(message.createdAt),
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            message.message,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );

    return msg;
  }

  _buildMessageComposer() {
    return Container(
      height: 70.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.photo,
                size: 29.0,
                color: Theme.of(context).primaryColor,
              )),
          Expanded(
            child: TextField(
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: "Message"),
            )
          ),
          IconButton(
              onPressed: () {
                var senderId = getMyProfileId();
                var receiverId = widget.userId;
                var message = messageController.text;

                send(senderId!, receiverId, message);
              },
              icon: Icon(
                Icons.send,
                size: 29.0,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ),
    );
  }

  send(String senderId, String receiverId, String message) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var res = await sendMessage(senderId, receiverId, message);

    setState(() {
      isLoading = false;
    });
    if (res["status"] == true) {
      messageController.clear();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                ),
              elevation: 0,
              backgroundColor: dialogColor,
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Message", style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                  SizedBox(height: 15,),
                  Text(res["message"], style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                  SizedBox(height: 22,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok", style: TextStyle(fontSize: 18, color: Color(0xFF99a4f3)),)
                        ),
                  ),
                ],
              ),
              );
          }
      );
    }
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
                    icon: const Icon(
                      Icons.more_horiz,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<Message>>(
                        future: fetchMessages(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var messages = snapshot.data;
                            return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  child: ListView.builder(
                                      reverse: true,
                                      padding: const EdgeInsets.only(top: 15.0),
                                      itemCount: messages!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final Message message = messages[index];
                                        final bool isMe = message.senderId ==
                                            getMyProfileId();
                                        return _buildMessage(message, isMe);
                                      }),
                                ));
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
        });
  }
}
