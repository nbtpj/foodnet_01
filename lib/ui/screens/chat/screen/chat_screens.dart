import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/utils.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
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

  _buildMessage(Message message, bool isMe, String userAsset) {
    final msg;
    if (isMe) {
      msg = Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 100.0, right: 10.0),
        // padding: const EdgeInsets.all(value),
        // width: MediaQuery.of(context).size.width * 0.75,
        child: Align(
          alignment: Alignment.centerRight,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    getTimeAgo(message.createdAt),
                    style: const TextStyle(
                      fontSize: 13.0,
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
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      );
    } else {
      msg = Row(
        children: [
          const SizedBox(
            width: 10.0,
          ),
          CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(userAsset)),
          const SizedBox(
            width: 10.0,
          ),
          Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
              // padding: const EdgeInsets.all(value),
              width: MediaQuery.of(context).size.width * 0.65,
              child: Align(
                alignment: Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTimeAgo(message.createdAt),
                          style: const TextStyle(
                            fontSize: 13.0,
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
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          )
        ],
      );
    }


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
                color: buttonColor,
              )),
          Expanded(
            child: TextField(
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: message_string),
            )
          ),
          IconButton(
              onPressed: () {
                var senderId = getMyProfileId();
                var receiverId = widget.userId;
                var message = messageController.text;

                send(senderId, receiverId, message);
              },
              icon: Icon(
                Icons.send,
                size: 29.0,
                color: buttonColor,
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
                  const Text("Message", style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                  const SizedBox(height: 15,),
                  Text(res["message"], style: const TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                  const SizedBox(height: 22,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok", style: TextStyle(fontSize: 18, color: Color(0xFF99a4f3)),)
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

    return FutureBuilder<ProfileData?>(
        future: getProfile(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ProfileData? user = snapshot.data;

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(
                  color: Colors.black, //change your color here
                ),
                leading: IconButton (
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(user!.userAsset)),
                    const SizedBox(width: 10.0,),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                elevation: 0.0,
                actions: <Widget>[
                  // todo: IconButton(
                  //   icon: const Icon(
                  //     Icons.more_horiz,
                  //   ),
                  //   onPressed: () {},
                  // ),
                ],
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        // future: fetchMessages(),
                        stream: getMessages(widget.userId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var messages = snapshot.data?.docs;
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
                                        final Message message = Message.fromJson(messages[index].data() as Map<String, dynamic>);
                                        final bool isMe = message.senderId ==
                                            getMyProfileId();
                                        if ((isMe || message.senderId == widget.userId) && (message.receiverId == getMyProfileId() || message.receiverId == widget.userId)) {
                                          return _buildMessage(message, isMe, user.userAsset);
                                        } else {
                                          return const Center();
                                        }
                                      }),
                                ));
                          } else {
                            // return CircularProgressIndicator();
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
