import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';

class FriendItem extends StatefulWidget {
  final String userAsset;
  final String name;
  final String time;
  final void Function(int) eraseFriendsList;
  final int index;
  const FriendItem({
    Key? key,
    required this.userAsset,
    required this.name,
    required this.time,
    required this.eraseFriendsList,
    required this.index,
  }) : super(key: key);

  @override
  _FriendItemState createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  bool _confirm = false;

  void _updateConfirm() {
    setState(() {
      _confirm = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(
          widget.name,
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
        isThreeLine: false,
        trailing: Text(widget.time),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(widget.userAsset),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("10 bạn chung"),
            (_confirm
                ? Confirmed()
                : UnConfirm(updateConfirm: _updateConfirm,
                eraseFriendsList: widget.eraseFriendsList, index: widget.index
            )
            )
          ],
        ),
      ),
      onTap: () {
        // todo Navigate.pushPage(context, ProfilePage(id: "2"));
      },
    );
  }
}

class UnConfirm extends StatelessWidget {
  final void Function() updateConfirm;
  final void Function(int) eraseFriendsList;
  final int index;
  const UnConfirm ({
    Key? key,
    required this.updateConfirm,
    required this.eraseFriendsList,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            updateConfirm();
          },
          child: Container(
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(4),
              width: 88,
              height: 30,
              alignment: Alignment.center,
              child: const Text(
                "Xác nhận",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ),
        GestureDetector(
          onTap: () {
            eraseFriendsList(index);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(4),
            width: 88,
            height: 30,
            alignment: Alignment.center,
            child: const Text(
                "Xoá",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
            ),
          ),
        )
      ],
    );
  }
}

class Confirmed extends StatelessWidget {
  const Confirmed ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(4),
          width: 150,
          height: 30,
          alignment: Alignment.center,
          child: Row(
            children: [
              SizedBox(
                height: 0,
                width: 16,
              ),
              Icon(
                IconData(0xf05a3, fontFamily: 'MaterialIcons'),
                color: Colors.yellow,
              ),
              Text(
                "  Vẫy tay chào",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ),
      ],
    );
  }
}

class FriendListItem extends StatefulWidget {
  final String userAsset;
  final String name;
  final int mutual_friends;

  const FriendListItem({
    Key? key,
    required this.userAsset,
    required this.name,
    required this.mutual_friends,
  }) : super(key: key);

  @override
  _FriendListItemState createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(
          widget.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        isThreeLine: false,
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: (){
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return Container(
                    height: 230,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        ListTile(
                          title: Text(widget.name),
                          isThreeLine: false,
                          leading: CircleAvatar(
                            radius: 30,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(widget.userAsset),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.4,
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 15),
                            CircleAvatar(
                              backgroundColor: Colors.grey[350],
                              child: Icon(IconData(0xe153, fontFamily: 'MaterialIcons'), color: Colors.black,),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Nhắn tin cho " + widget.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(width: 15),
                            CircleAvatar(
                              backgroundColor: Colors.grey[350],
                              child: Icon(IconData(0xe49a, fontFamily: 'MaterialIcons'), color: Colors.black,),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Huỷ kết bạn với " + widget.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            );
          },
        ),
        leading: CircleAvatar(
          radius: 30,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(widget.userAsset),
          ),
        ),
        subtitle: Text(widget.mutual_friends.toString() + " bạn chung"),
      ),
      onTap: () {
        // todo: Navigate.pushPage(context, ProfilePage(id: "2"));
      },
    );
  }
}

class FriendSuggestionItem extends StatefulWidget {
  final String userAsset;
  final String name;
  final int mutualism;
  final String index;
  //final void Function(int) eraseFriendsList;
  const FriendSuggestionItem({
    Key? key,
    required this.userAsset,
    required this.name,
    required this.mutualism,
    required this.index,
    //required this.eraseFriendsList,
  }) : super(key: key);

  @override
  _FriendSuggestionItemState createState() => _FriendSuggestionItemState();
}

class _FriendSuggestionItemState extends State<FriendSuggestionItem> {
  bool _confirm = false;

  void _updateConfirm() {
    setState(() {
      _confirm = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(
          widget.name,
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
        isThreeLine: false,
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(widget.userAsset),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.mutualism.toString() + " bạn chung"),
            (_confirm
                ? Confirmed1()
                : UnConfirm1(updateConfirm: _updateConfirm,
                /*eraseFriendsList: widget.eraseFriendsList,*/ index: widget.index
            )
            )
          ],
        ),
      ),
      onTap: () {
        // todo: Navigate.pushPage(context, ProfilePage(id: "2"));
      },
    );
  }
}

class UnConfirm1 extends StatelessWidget {
  final void Function() updateConfirm;
  //final void Function(int) eraseFriendsList;
  final String index;
  const UnConfirm1 ({
    Key? key,
    required this.updateConfirm,
    //required this.eraseFriendsList,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            updateConfirm();
          },
          child: Container(
            decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(4),
            width: 120,
            height: 30,
            alignment: Alignment.center,
            child: const Text(
              "Thêm bạn bè",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            //eraseFriendsList(index);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(4),
            width: 100,
            height: 30,
            alignment: Alignment.center,
            child: const Text(
              "Xoá",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Confirmed1 extends StatelessWidget {
  const Confirmed1 ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(4),
            width: 150,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              "Đã gửi yêu cầu",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ),
      ],
    );
  }
}
