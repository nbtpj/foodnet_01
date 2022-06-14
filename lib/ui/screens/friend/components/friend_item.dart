import 'package:flutter/material.dart';
import 'package:foodnet_01/util/constants/colors.dart';

import '../../../../util/constants/strings.dart';
import '../../../../util/data.dart';
import '../../../../util/global.dart';
import '../../../../util/navigate.dart';
import '../../profile/profile.dart';

class FriendItem extends StatefulWidget {
  final String id;
  final String userAsset;
  final String name;
  final String time;
  final int index;
  final Future<int> mutualism;
  final String type;

  const FriendItem({
    Key? key,
    required this.id,
    required this.userAsset,
    required this.name,
    required this.time,
    required this.index,
    required this.mutualism,
    required this.type,
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
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 150));
    lucencyAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: lucencyController, curve: Curves.easeOut));

    sizeController =
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300));
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
      sizeController.forward();
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
        child: Column(
          children: [
            InkWell(
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
                  radius: height / 28.43,

                  ///30
                  backgroundImage: NetworkImage(widget.userAsset),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<int>(
                      future: widget.mutualism,
                      builder: (context, snap) {
                      if (snap.hasData) {
                        return Text
                          (
                            snap.data.toString() + ' ' +
                                mutualismFriendString,
                            style: TextStyle(fontSize: height / 56.867)
                        );
                      }
                      return Center();
                    },),

                    FittedBox(
                      fit: BoxFit.contain,
                      child: (_confirm
                          ? Confirmed(type: widget.type,)
                          : UnConfirm(
                        id: widget.id,
                        updateConfirm: _updateConfirm,
                        updateDelete: _updateDelete,
                        index: widget.index,
                        type: widget.type,)),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigate.pushPage(context, ProfilePage(id: widget.id));
              },
            ),
            SizedBox(height: height / 85.3,)

            ///10
          ],
        )
    );
  }
}

class UnConfirm extends StatelessWidget {
  final String id;
  final void Function() updateConfirm;
  final void Function() updateDelete;
  final int index;
  final String type;

  const UnConfirm({
    Key? key,
    required this.id,
    required this.updateConfirm,
    required this.updateDelete,
    required this.index,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Row(
      children: [
        InkWell(
          onTap: () async {
            bool success = false;
            if (type == "invitation") {
              success = await acceptFriendRequest(id);
            } else {
              success = await addFriendRequest(id);
            }
            if (success) {
                updateConfirm();
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(height / 85.3)),

            ///10
            margin: EdgeInsets.all(height / 213.25),

            ///4
            width: width / 4.11,

            ///100
            height: height / 28.43,

            ///30
            alignment: Alignment.center,
            child: Text(
              type == "invitation" ? confirmString : addFriendString,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            bool success = await cancelFriend(id);
            if (success) {
              updateDelete();
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(height / 85.3)),

            ///10
            margin: EdgeInsets.all(height / 213.25),

            ///4
            width: width / 4.11,

            ///100
            height: height / 28.43,

            ///30
            alignment: Alignment.center,
            child: const Text(
              deleteString,
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
  final String type;

  const Confirmed({
    Key? key,
    required this.type,
  }) : super(key: key);

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
                borderRadius: BorderRadius.circular(height / 85.3)),

            ///10
            margin: EdgeInsets.all(height / 213.25),

            ///4
            width: width / 2.74,

            ///150
            height: height / 28.43,

            ///30
            alignment: Alignment.center,
            child: type == "invitation" ?
            Row(
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
                  sayHiString,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ) : const Text(
              requestSentString,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

          ),
        ],
      ),
      onTap: () {
        ///todo: Navìgate to chat
      },
    );
  }
}
