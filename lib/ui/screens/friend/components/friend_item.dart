import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';

import '../../../../util/global.dart';

class FriendItem extends StatefulWidget {
  final String userAsset;
  final String name;
  final String time;
  final int index;
  final int mutualism;
  const FriendItem({
    Key? key,
    required this.userAsset,
    required this.name,
    required this.time,
    required this.index,
    required this.mutualism,
  }) : super(key: key);

  @override
  _FriendItemState createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> with TickerProviderStateMixin {
  late AnimationController lucencyController;
  late AnimationController sizeController;

  late Animation<double> lucencyAnimation;
  late Animation<double> sizeAnimation;

  bool _confirm = false;
  bool _delete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lucencyController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    lucencyAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: lucencyController, curve: Curves.easeOut));

    sizeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    sizeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: sizeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    lucencyController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  void _updateConfirm() {
    setState(() {
      _confirm = true;
    });
  }

  void _updateDelete() {
    setState(() {
      _delete = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return _delete
        ? SizeTransition(
          axis: Axis.vertical,
          sizeFactor: sizeAnimation,
          child: SizedBox(
            height: 82.2,
            width: width,
          ),
        ) : FadeTransition(
          opacity: lucencyAnimation,
          child: InkWell(
            child: ListTile(
              title: Text(
                widget.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600
                ),
              ),
              isThreeLine: false,
              trailing: Text(widget.time),
              leading: CircleAvatar(
                radius: height / 28.43, ///30
                backgroundImage: AssetImage(widget.userAsset),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.mutualism.toString() + " bạn chung",
                      style: TextStyle(fontSize: height / 56.867) ///15,
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: (_confirm
                        ? const Confirmed()
                        : UnConfirm(updateConfirm: _updateConfirm, updateDelete: _updateDelete,
                        index: widget.index)),
                  ),
                ],
              ),
            ),
            onTap: () {
              // todo Navigate.pushPage(context, ProfilePage(id: "2"));
            },
          ),);
  }
}

class UnConfirm extends StatelessWidget {
  final void Function() updateConfirm;
  final void Function() updateDelete;
  final int index;
  const UnConfirm ({
    Key? key,
    required this.updateConfirm,
    required this.updateDelete,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            updateConfirm();
          },
          child: Container(
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(height / 85.3)), ///10
              margin: EdgeInsets.all(height / 213.25), ///4
              width: width / 4.11, ///100
              height: height / 28.43, ///30
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
            //eraseFriendsList(index);
            updateDelete();
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(height / 85.3)), ///10
            margin: EdgeInsets.all(height / 213.25), ///4
            width: width / 4.11, ///100
            height: height / 28.43, ///30
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
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return InkWell(
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(height / 85.3)), ///10
              margin: EdgeInsets.all(height / 213.25), ///4
              width: width / 2.74, ///150
              height: height / 28.43, ///30
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    height: 0,
                    width: width / 25.6875,
                  ),
                  const Icon(
                    IconData(0xf05a3, fontFamily: 'MaterialIcons'),
                    color: Colors.yellow,
                  ),
                  const Text(
                    "  Gửi lời chào",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
          ),
        ],
      ),
      onTap: () {
        ///todo: Navìgate to chat
      },
    );
  }
}

class FriendListItem extends StatefulWidget {
  final String userAsset;
  final String name;
  final int mutualFriends;

  const FriendListItem({
    Key? key,
    required this.userAsset,
    required this.name,
    required this.mutualFriends,
  }) : super(key: key);

  @override
  _FriendListItemState createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendListItem> {
  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return InkWell(
      child: ListTile(
        title: Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        isThreeLine: false,
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: (){
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return SizedBox(
                    height: height / 3.7087, ///230
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 56.87, ///15
                        ),
                        ListTile(
                          title: Text(widget.name),
                          isThreeLine: false,
                          leading: CircleAvatar(
                            radius: height / 28.43, ///30
                            child: CircleAvatar(
                              radius: height / 28.43, ///30
                              backgroundImage: AssetImage(widget.userAsset),
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 0.4,
                        ),
                        SizedBox(height: height / 56.87,), ///15
                        Row(
                          children: [
                            SizedBox(width: width / 27.5), ///15
                            CircleAvatar(
                              backgroundColor: Colors.grey[350],
                              child: const Icon(IconData(0xe153, fontFamily: 'MaterialIcons'), color: Colors.black,),
                            ),
                            SizedBox(width: width / 41.1), ///10
                            Text(
                              "Nhắn tin cho " + widget.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 56.867, ///15
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height / 56.867), ///15
                        Row(
                          children: [
                            SizedBox(width: width / 27.5), ///15
                            CircleAvatar(
                              backgroundColor: Colors.grey[350],
                              child: const Icon(IconData(0xe49a, fontFamily: 'MaterialIcons'), color: Colors.black,),
                            ),
                            SizedBox(width: width / 41.1), ///10
                            Text(
                              "Huỷ kết bạn với " + widget.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 56.867, ///15
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
          radius: height / 28.43, ///30
          child: CircleAvatar(
            radius: height / 28.43, ///30
            backgroundImage: AssetImage(widget.userAsset),
          ),
        ),
        subtitle: Text(widget.mutualFriends.toString() + " bạn chung"),
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
    double height = SizeConfig.screenHeight;
    return InkWell(
      child: ListTile(
        title: Text(
          widget.name,
          style: const TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
        isThreeLine: false,
        leading: CircleAvatar(
          radius: height / 28.43, ///30
          backgroundImage: AssetImage(widget.userAsset),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.mutualism.toString() + " bạn chung"),
            (_confirm
                ? const Confirmed1()
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
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            updateConfirm();
          },
          child: Container(
            decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(height / 85.3)), ///10
            margin: EdgeInsets.all(height / 213.25), ///4
            width: width / 3.425, ///120
            height: height / 28.43, ///30
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
                borderRadius: BorderRadius.circular(height / 85.3)), ///10
            margin: EdgeInsets.all(height / 213.25), ///4
            width: width / 4.11, ///100
            height: height / 28.43, ///30
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
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Row(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(height / 85.3)), ///10
            margin: EdgeInsets.all(height / 213.25), ///4
            width: width / 2.74, ///150
            height: height / 28.43, ///30
            alignment: Alignment.center,
            child: const Text(
              "Đã gửi yêu cầu",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ),
      ],
    );
  }
}
