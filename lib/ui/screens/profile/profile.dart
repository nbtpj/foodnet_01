import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/screens/friend/friend_list.dart';
import 'package:foodnet_01/ui/screens/profile/components/user_picture.dart';
import 'package:foodnet_01/ui/screens/profile/components/wall_picture.dart';
import 'package:foodnet_01/ui/screens/profile/detail_profile.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';

import '../../../util/constants/strings.dart';
import '../../../util/global.dart';
import '../../../util/navigate.dart';
import '../detailed_list/full_list.dart';
import '../home/components/food_part.dart';
import '../home/widgets/my_posts.dart';
import '../search/search.dart';
import 'components/friend.dart';

//ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  late String type;
  final String id;
  final String? arriveType;

  ProfilePage({
    Key? key,
    required this.id,
    this.arriveType,
  }) : super(key: key) {
    type = id == getMyProfileId() ? "me" : "other";

  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double width = SizeConfig.screenWidth;
  double height = SizeConfig.screenHeight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<ProfileData?>(
      future: getProfile(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ProfileData? profile = snapshot.data;

          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: height / 21.325, bottom: height / 85.3),

                ///(40, 10)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (widget.arriveType == null) {
                          Navigate.popPage(context);
                        }
                      },
                      icon: widget.arriveType == null
                          ? const Icon(
                              IconData(0xe094, fontFamily: 'MaterialIcons'))
                          : const SizedBox(
                              width: 10,
                            ),
                      color: Colors.black,
                      iconSize: height / 34.12,

                      ///25
                    ),
                    Text(
                      profile!.name,
                      style: TextStyle(
                          fontSize: height / 34.12,
                          fontWeight: FontWeight.bold),

                      ///25
                    ),
                    IconButton(
                      onPressed: () {
                        Navigate.pushPage(
                            context,
                            const SearchPage(
                              type: "user",
                            ));
                      },
                      icon: const Icon(Icons.search),
                      color: Colors.black,
                      iconSize: height / 34.12,

                      ///25
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
                      height: height / 3.412,

                      ///250
                      child: Stack(alignment: Alignment.centerLeft, children: <
                          Widget>[
                        WallPicture(profile: profile, type: widget.type,),
                        UserPicture(profile: profile, type: widget.type,)
                      ]),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        profile.name,
                        style: TextStyle(
                            fontSize: height / 37.09,

                            ///23
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: height / 42.65,

                      ///20
                    ),
                    widget.type == "me"
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.circular(height / 47.39),

                                  ///18
                                ),
                                width: width / 1.42,

                                ///290
                                height: height / 22.45,

                                ///38

                                child: GestureDetector(onTap: (){
                                  /// todo: checkpoint
                                  Navigate.pushPage(
                                      context,
                                      DetailProfile(
                                        profile: profile,
                                        type: widget.type,
                                      ));
                                },
                                    child:Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.create_sharp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: width / 137,

                                      ///3
                                    ),
                                    const Text(
                                      "Chỉnh sửa trang cá nhân",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                width: width / 51.375,

                                ///8
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(
                                          height / 42.65)),

                                  ///20
                                  width: width / 7.34,

                                  ///56
                                  height: height / 22.45,

                                  ///38
                                  child: const Icon(Icons.more_horiz)),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.type == "other"
                                        ? buttonColor
                                        : Colors.grey.shade300,
                                    borderRadius:
                                        BorderRadius.circular(height / 47.39),

                                    ///18
                                  ),
                                  width: width / 2.834,

                                  ///145
                                  height: height / 22.45,

                                  ///38
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        widget.type == "other"
                                            ? Icons.person_add_rounded
                                            : Icons.person,
                                        color: widget.type == "other"
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      SizedBox(
                                        width: width / 137,

                                        ///3
                                      ),
                                      Text(
                                        widget.type == "other"
                                            ? "Thêm bạn bè"
                                            : "Bạn bè",
                                        style: TextStyle(
                                            color: widget.type == "other"
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width / 51.375,

                                  ///8
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.type == "other"
                                        ? Colors.grey.shade300
                                        : buttonColor,
                                    borderRadius:
                                        BorderRadius.circular(height / 47.39),

                                    ///18
                                  ),
                                  width: width / 2.834,

                                  ///145
                                  height: height / 22.45,

                                  ///38
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.message,
                                        color: widget.type == "other"
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      SizedBox(
                                        width: width / 137,

                                        ///3
                                      ),
                                      Text(
                                        "Nhắn tin",
                                        style: TextStyle(
                                            color: widget.type == "other"
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width / 51.375,

                                  ///8
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(
                                            height / 42.65)),

                                    ///20
                                    width: width / 7.34,

                                    ///56
                                    height: height / 22.45,

                                    ///38
                                    child: const Icon(Icons.more_horiz)),
                              ]),
                    SizedBox(
                      height: height / 56.87,

                      ///15
                    ),
                    const Divider(color: Colors.grey),
                    profile.works!.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(left: width / 51.375),

                            ///8
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: profile.works!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.only(
                                    top: height / 121.86,
                                    bottom: height / 121.86),

                                ///(7, 7)
                                child: Row(
                                  children: [
                                    Icon(
                                      const IconData(0xe6f2,
                                          fontFamily: 'MaterialIcons'),
                                      size: height / 34.12,

                                      ///25
                                      color: const Color(0xff80889b),
                                    ),
                                    SizedBox(
                                      width: width / 41.1,

                                      ///10
                                    ),
                                    Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "Làm việc tại ",
                                            style: TextStyle(
                                                fontSize: height / 47.398,

                                                ///18
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: profile.works![index],
                                            style: TextStyle(
                                              fontSize: height / 47.398,

                                              ///18
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                    profile.schools!.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(left: width / 51.375),

                            ///8
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: profile.schools!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: height / 121.86,
                                    bottom: height / 121.86),

                                ///(7, 7)
                                child: Row(
                                  children: [
                                    Icon(
                                      const IconData(0xe559,
                                          fontFamily: 'MaterialIcons'),
                                      size: height / 34.12,

                                      ///25
                                      color: const Color(0xff80889b),
                                    ),
                                    SizedBox(
                                      width: width / 41.1,

                                      ///10
                                    ),
                                    Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "Học tại ",
                                            style: TextStyle(
                                                fontSize: height / 47.398,

                                                ///18
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: profile.schools![index],
                                            style: TextStyle(
                                              fontSize: height / 47.398,

                                              ///18
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    profile.favorites!.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(left: width / 51.375),

                            ///8
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: profile.favorites!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: height / 121.86,
                                    bottom: height / 121.86),

                                ///(7, 7)
                                child: Row(
                                  children: [
                                    Icon(
                                      const IconData(0xe25b,
                                          fontFamily: 'MaterialIcons'),
                                      size: height / 34.12,

                                      ///25
                                      color: const Color(0xff80889b),
                                    ),
                                    SizedBox(
                                      width: width / 41.1,

                                      ///10
                                    ),
                                    Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "Sở thích ",
                                            style: TextStyle(
                                                fontSize: height / 47.398,

                                                ///18
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: profile.favorites![index],
                                            style: TextStyle(
                                              fontSize: height / 47.398,

                                              ///18
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    profile.location != null
                        ? Container(
                            padding: EdgeInsets.only(
                                left: width / 51.375,
                                top: height / 121.86,
                                bottom: height / 121.86),

                            ///(8, 7, 7)
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: height / 34.12,
                                ),

                                ///25
                                SizedBox(
                                  width: width / 41.1,

                                  ///10
                                ),
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: "Đến từ ",
                                        style: TextStyle(
                                            fontSize: height / 47.398,

                                            ///18
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: profile.location,
                                        style: TextStyle(
                                          fontSize: height / 47.398,

                                          ///18
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: width / 58.714,
                            top: height / 121.86,
                            bottom: height / 121.86),

                        ///(7, 7, 7)
                        child: Row(
                          children: [
                            Icon(
                              Icons.more_horiz,
                              size: height / 34.12,
                            ),

                            ///25
                            SizedBox(
                              width: width / 41.1,

                              ///10
                            ),
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Xem thông tin giới thiệu của ",
                                    style: TextStyle(
                                        fontSize: height / 47.398,

                                        ///18
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: profile.name,
                                    style: TextStyle(
                                      fontSize: height / 47.398,

                                      ///18
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigate.pushPage(
                            context,
                            DetailProfile(
                              profile: profile,
                              type: widget.type,
                            ));
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(
                            width / 27.4, height / 85.3, width / 27.4, 0),

                        ///(15, 10, 15, 0)
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bạn bè",
                                  style: TextStyle(
                                      fontSize: height / 32.81,

                                      ///26
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ///todo: So ban va so ban chung
                                  "864 (3 bạn chung)",
                                  style: TextStyle(
                                    color: const Color(0xffacacae),
                                    fontSize: height / 53.3125,

                                    ///16
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffeff0f1),
                                    borderRadius:
                                        BorderRadius.circular(height / 47.398),

                                    ///18
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffeff0f1)
                                            .withOpacity(.4),
                                        blurRadius: height / 170.6,

                                        ///5.0
                                        offset: Offset(0, height / 85.3),

                                        ///10
                                        // shadow direction: bottom right
                                      )
                                    ]),
                                width: (MediaQuery.of(context).size.width / 2) -
                                    width / 8.22,

                                ///50
                                height: height / 22.45,

                                ///38
                                child: const Center(
                                  child: Text(
                                    "Xem tất cả bạn bè",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigate.pushPage(context, const FriendList());
                              },
                            ),
                          ],
                        )),
                    FutureBuilder<List<FriendData>>(
                        future: getFriend(profile.id!).toList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<FriendData> friendShortList = snapshot.data!;
                            return Container(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                child: friendShortList.isNotEmpty
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        //physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Friend(
                                              id: friendShortList[index].id,
                                              userAsset: friendShortList[index]
                                                  .userAsset,
                                              name:
                                                  friendShortList[index].name);
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(width: 5);
                                        },
                                        itemCount:
                                            min(4, friendShortList.length))
                                    : const SizedBox(width: 0, height: 0));
                          } else {
                            return const Center();
                          }
                        }),
                    SizedBox(height: height / 75,),
                    GestureDetector(
                        onTap: () async {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DetailList(
                              name: my_post_string,
                            );
                          }));
                        },
                        child: FoodPart(partName: my_post_string)),
                    const MyFoods(),
                  ],
                ),
              )),
            ],
          );
        } else {
          return const Center();
        }
      },
    ));
  }
}
