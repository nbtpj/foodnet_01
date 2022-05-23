import 'package:flutter/material.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class CategoriesFood extends StatefulWidget {
  const CategoriesFood({Key? key}) : super(key: key);

  @override
  _CategoriesFoodState createState() => _CategoriesFoodState();
}

class _CategoriesFoodState extends State<CategoriesFood> {
  Future<List<PostData>> fetchRootPost() async {
    //todo: implement get root post (categorical post)
    return getPosts(Filter(search_type: 'category')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostData>>(
      future: fetchRootPost(),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var categoryList = snapshot.data!;
          return SizedBox(
            height: SizeConfig.screenHeight / 8.04,

            /// 85.0
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                var category = categoryList[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          SizeConfig.screenWidth / 34.25,

                          /// 12.0
                          SizeConfig.screenHeight / 170.75,

                          /// 4.0
                          SizeConfig.screenWidth / 20.55,

                          /// 20.0
                          SizeConfig.screenHeight / 170.75,

                          /// 4.0
                        ),
                        height: SizeConfig.screenHeight / 15.18,

                        /// 45.0
                        width: SizeConfig.screenWidth / 9.14,

                        /// 45.0
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(category.outstandingIMGURL),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Row(children: [
                      Text(
                        category.title,
                        style: TextStyle(
                            fontSize: SizeConfig.screenHeight / 52.54,
                            color: Colors.black45),
                      )

                      /// 13
                    ]),
                  ],
                );
              },
            ),
          );
        } else {
          return CircularProgressIndicator();
          // return const Center();
        }
      }
    );
  }
}
