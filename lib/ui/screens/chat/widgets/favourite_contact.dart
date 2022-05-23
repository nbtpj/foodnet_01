import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/chat/screen/chat_screens.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

class FavoriteContacts extends StatefulWidget {
  const FavoriteContacts({Key? key}) : super(key: key);

  @override
  _FavoriteContactsState createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  @override
  Widget build(BuildContext context) {
    Future<List<FriendData>> fetchRootFriend() async {
      //todo: implement get root post (categorical post)
      return getFriends(Filter(search_type: "friend_list"), getMyProfileId())
          .toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Favorite Contacts",
                  style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 29.0,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
          SizedBox(
              height: 120.0,
              child: FutureBuilder<List<FriendData>>(
                future: fetchRootFriend(),
                builder: (context, snapshot) {
                  var favourites = snapshot.data ?? [];

                  return ListView.builder(
                      padding: const EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: favourites.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            // TODO: set unread is false
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreens(
                                      userId: favourites[index].id,
                                    )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage:
                                      AssetImage(favourites[index].userAsset),
                                ),
                                Text(
                                  favourites[index].name,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              )),
        ],
      ),
    );
  }
}
