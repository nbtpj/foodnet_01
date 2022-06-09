import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/food_thumb.dart';
import 'package:foodnet_01/ui/screens/post_edit/post_edit.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class PostByAuthor extends StatefulWidget {
  Filter? filter;
  PostByAuthor({Key? key, this.filter}) : super(key: key);
  bool isMe(){
    return filter==null || filter!.search_type=='my_food';
  }

  @override
  _PostByAuthorState createState() => _PostByAuthorState();
}

class _PostByAuthorState extends State<PostByAuthor> {
  Future<List<PostData>> fetchMyPost() async {
    var filter = widget.filter?? Filter(search_type: 'my_food');
    return getPosts(filter).toList();
  }


  Widget _build_add_new(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostEditForm(
                        food: PostData(
                      title: add_title,
                      description: add_description,
                    ))));
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                SizeConfig.screenWidth / 34.25,

                /// 12.0
                SizeConfig.screenHeight / 113.84,

                /// 6.0
                SizeConfig.screenWidth / 34.25,

                /// 12.0
                SizeConfig.screenHeight / 22.77

                /// 30.0
                ),
            height: SizeConfig.screenHeight / 3.105,

            /// 220.0
            width: SizeConfig.screenWidth / 2.74,

            /// 150.0
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.3),
                  )
                ]),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: SizeConfig.screenHeight / 6.83,

                      /// 100.0
                      width: SizeConfig.screenWidth / 2.74,

                      /// 150.0
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                add_a_new_post,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: SizeConfig.screenHeight / 34.15,

                                    /// 20
                                    fontWeight: FontWeight.w700),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostData>>(
      future: fetchMyPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var foodList = snapshot.data ?? [];
          return SizedBox(
            height: SizeConfig.screenHeight / 2.28,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.isMe()?foodList.length + 1:foodList.length,
              itemBuilder: (context, index) {
                if (widget.isMe()){
                  if (index == 0) {
                    return _build_add_new(context);
                  } else {
                    var food = foodList[index - 1];
                    return build_a_food_thumb(context, food);
                  }
                } else {
                  var food = foodList[index];
                  return build_a_food_thumb(context, food);
                }
              },
            ),
          );
        } else {
          return CircularProgressIndicator();
          // return const Center();
        }
      },
    );
  }
}
