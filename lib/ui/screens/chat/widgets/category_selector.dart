import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/messages_selector.dart';
import 'package:foodnet_01/ui/screens/chat/widgets/online_selector.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;

  final screens = [
    MessagesSelector(),
    OnlineSelector()
  ];

  final List<String> categories = ["Messages", "Online"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
        height: 90.0,
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                onTap: (){
                  setState(() {
                    this.selectedIndex = index;
                  });
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 30.0) ,
                    child: Text(categories[index],
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0,
                          color: index == selectedIndex ? Colors.white : Colors.white60,
                          letterSpacing: 1.2,
                        )
                    )
                ),
              );
            })
        ),
        screens[this.selectedIndex]
      ],
    );
  }
}