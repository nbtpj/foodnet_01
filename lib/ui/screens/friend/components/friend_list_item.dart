import 'package:flutter/material.dart';
import 'package:foodnet_01/util/navigate.dart';

import '../../../../util/global.dart';

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

class _FriendListItemState extends State<FriendListItem> with TickerProviderStateMixin {
  late AnimationController lucencyController;
  late AnimationController sizeController;

  late Animation<double> lucencyAnimation;
  late Animation<double> sizeAnimation;

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
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    sizeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: sizeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    lucencyController.dispose();
    sizeController.dispose();
    super.dispose();
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
                                InkWell(
                                  child: Row(
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
                                  onTap: () {
                                    ///todo: Navigate to chat
                                  },
                                ),
                                SizedBox(height: height / 56.867), ///15
                                InkWell(
                                  child: Row(
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
                                  onTap: () {
                                    setState(() {
                                      _delete = true;
                                      sizeController.forward();
                                      Navigate.popPage(context);
                                    });
                                  },
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
            ),
            SizedBox(height: height / 85.3,) ///10
          ],
        )
    );
  }
}