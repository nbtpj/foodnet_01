import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/model/message_model.dart';
import 'package:foodnet_01/ui/screens/chat/screen/chat_screens.dart';

class FavoriteContacts extends StatefulWidget {
  const FavoriteContacts({Key? key}) : super(key: key);

  @override
  _FavoriteContactsState createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding:const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const  Text("Favorite Contacts",style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey
                    ),
                ),
                IconButton(onPressed: (){}, icon:const Icon(
                  Icons.more_horiz,
                  size: 29.0,
                  color: Colors.blueGrey,
                ))

              ],
            ),
          ),
          SizedBox(
            height: 120.0,
            child: ListView.builder(
                padding:const EdgeInsets.only(left: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: favorites.length,
                itemBuilder: (BuildContext context , int index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatScreens(user: favorites[index],)));
                    },
                    child: Padding(
                      padding:const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar( radius: 35.0,
                            backgroundImage: AssetImage(favorites[index].imgURL),
                          ),
                          Text(favorites[index].name, style:
                          const   TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600, color: Colors.blueGrey ),),
                        ],
                      ),
                    ),
                  );
                }),
          ),


        ],
      ),
    );
  }
}