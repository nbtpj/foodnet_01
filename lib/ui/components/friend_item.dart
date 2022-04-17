import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendItem extends StatelessWidget {
  final String userAsset;
  final String name;
  final String time;
  const FriendItem({
    Key? key,
    required this.userAsset,
    required this.name,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      isThreeLine: false,
      trailing: Text(time),
      leading: CircleAvatar(
        radius: 30,
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(userAsset),
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(4),
            width: 100,
            height: 30,
            alignment: Alignment.center,
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(4),
            width: 100,
            height: 30,
            alignment: Alignment.center,
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}