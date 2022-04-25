
import 'package:flutter/material.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

import '../../../util/navigate.dart';
import 'components/friend.dart';

class ProfilePage extends StatefulWidget {
  final String type;
  final String id;
  const ProfilePage({
    Key? key,
    required this.type,
    required this.id,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProfileData>(
        future: getProfile(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ProfileData? profile = snapshot.data;
            /*if (profile?.schools != null) {
              print(profile?.schools?.length);
            }*/
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 40, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigate.popPage(context);
                        },
                        icon: const Icon(IconData(0xe094, fontFamily: 'MaterialIcons')),
                        color: Colors.black,
                        iconSize: 25,
                      ),
                      Text(
                          profile!.name,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                        color: Colors.black,
                        iconSize: 25,
                        padding: const EdgeInsets.only(right: 0),
                      ),
                    ],
                  ),
                ),

                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                            child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        color: Colors.blue,
                                        height: 180,
                                        child: Image.asset(
                                          profile.wallAsset,
                                          height: 180,
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Positioned(
                                      left: (MediaQuery.of(context).size.width / 2) - 60,
                                      top: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Image.asset(
                                          profile.userAsset,
                                          height: 120,
                                          width: 120,
                                        ),
                                      ))
                                ]
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              profile.name,
                              style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          widget.type == "me" ?
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff2177ee),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    width: 290,
                                    height: 38,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.create_sharp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "Chỉnh sửa trang cá nhân",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      width: 56,
                                      height: 38,
                                      child: const Icon(Icons.more_horiz)),
                                ],
                              ) :
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.type == "other" ? const Color(0xff2177ee) : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  width: 145,
                                  height: 38,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Icon(
                                        widget.type == "other" ? Icons.person_add_rounded : Icons.person,
                                        color: widget.type == "other" ? Colors.white : Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        widget.type == "other" ? "Thêm bạn bè" : "Bạn bè",
                                        style: TextStyle(color: widget.type == "other" ?  Colors.white : Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.type == "other" ? Colors.grey.shade300 : const Color(0xff2177ee),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  width: 145,
                                  height: 38,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Icon(
                                        Icons.message,
                                        color: widget.type == "other" ? Colors.black : Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "Nhắn tin",
                                        style: TextStyle(color: widget.type == "other" ? Colors.black : Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    width: 56,
                                    height: 38,
                                    child: const Icon(Icons.more_horiz)),
                              ]
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          const Divider(color: Colors.grey),

                          profile.works!.isNotEmpty ?
                          ListView.builder(
                              padding: const EdgeInsets.only(left: 8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: profile.works!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.only(top: 7, bottom: 7),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        IconData(0xe6f2, fontFamily: 'MaterialIcons'),
                                        size: 25,
                                        color: Color(0xff80889b),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text:  "Làm việc tại ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: profile.works![index],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              }
                          ) : const SizedBox(width: 0, height: 0,),

                          profile.schools!.isNotEmpty ?
                          ListView.builder(
                              padding: const EdgeInsets.only(left: 8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: profile.schools!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin : const EdgeInsets.only(top: 7, bottom: 7),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        IconData(0xe559, fontFamily: 'MaterialIcons'),
                                        size: 25,
                                        color: Color(0xff80889b),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text:  "Học tại ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: profile.schools![index],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              }
                          ) : const SizedBox(height: 0, width: 0,),

                          profile.favorites!.isNotEmpty ?
                          ListView.builder(
                              padding: const EdgeInsets.only(left: 8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: profile.favorites!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin : const EdgeInsets.only(top: 7, bottom: 7),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        IconData(0xe25b, fontFamily: 'MaterialIcons'),
                                        size: 25,
                                        color: Color(0xff80889b),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text:  "Sở thích ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: profile.favorites![index],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              }
                          ) : const SizedBox(height: 0, width: 0,),

                          profile.location != null ?
                          Container(
                            padding: const EdgeInsets.only(left: 8, top: 7, bottom: 7),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, size: 25,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text:  "Đến từ ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                            text: profile.location,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : const SizedBox(width: 0, height: 0,),

                          Container(
                            padding: const EdgeInsets.only(left: 7, top: 7, bottom: 7),
                            child: Row(
                              children: [
                                const Icon(Icons.more_horiz, size: 25,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text:  "Xem thông tin giới thiệu của ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                            text: profile.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Divider(color: Colors.grey,),

                          Container(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Bạn bè",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "864 (3 bạn chung)",
                                        style: TextStyle(
                                          color: Color(0xffacacae),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xffeff0f1),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xffeff0f1)
                                                .withOpacity(.4),
                                            blurRadius: 5.0,
                                            offset: const Offset(0, 10),
                                            // shadow direction: bottom right
                                          )
                                        ]),
                                    width: (MediaQuery.of(context).size.width /
                                        2) -
                                        50,
                                    height: 38,
                                    child: const Center(
                                      child: Text(
                                        "Xem tất cả bạn bè",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Friend(
                                    firstName: "Tarek",
                                    lastName: "Loukil",
                                    userAsset: "assets/profile/tarek.jpg",
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Friend(
                                    firstName: "Ghassen",
                                    lastName: "Boughzala",
                                    userAsset: "assets/profile/ghassen.jpg",
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Friend(
                                    firstName: "Hassen",
                                    lastName: "Chouaddah",
                                    userAsset: "assets/profile/hassen.jpg",
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Friend(
                                    firstName: "Aziz",
                                    lastName: "Ammar",
                                    userAsset: "assets/profile/aziz.jpg",
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                ),


              ],
            );

          } else {
            return const Center();
          }
        },
      )

    );
  }
}