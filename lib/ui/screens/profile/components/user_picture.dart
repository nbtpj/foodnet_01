import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../util/constants/strings.dart';
import '../../../../util/global.dart';
import '../../../../util/navigate.dart';
import '../view_photo.dart';

//ignore: must_be_immutable
class UserPicture extends StatefulWidget {
  late String picture;
  final ImagePicker _picker = ImagePicker();

  UserPicture({Key? key,
    required this.picture,
  }) : super(key: key);

  @override
  _UserPictureState createState() => _UserPictureState();
}

class _UserPictureState extends State<UserPicture> {
  double width = SizeConfig.screenWidth;
  double height = SizeConfig.screenHeight;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: (MediaQuery.of(context).size.width / 2) -
            width / 6.85,

        ///60
        top: height / 7.11,

        ///120
        child: InkWell(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(height / 14.22),

            ///60
            child: Image.asset(
              widget.picture,
              height: height / 7.11,

              ///120
              width: width / 3.425,

              ///120
            ),
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return SizedBox(
                      height: height / 6.09,

                      ///140
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height / 42.65,

                              ///20
                            ),
                            InkWell(onTap: (){
                              Navigate.pushPageReplacement(context, PhotoPage(picture: widget.picture));
                            },
                                child:Row(
                                  children: [
                                    SizedBox(width: width / 27.4),

                                    ///15
                                    CircleAvatar(
                                      backgroundColor:
                                      Colors.grey[350],
                                      child: const Icon(
                                        IconData(0xe498,
                                            fontFamily:
                                            'MaterialIcons'),
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: width / 41.1),

                                    ///10
                                    Text(
                                      "Xem ảnh đại diện",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: height / 56.87,

                                        ///15
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(height: height / 56.87),

                            ///15
                            InkWell(onTap: () async {
                              Navigator.pop(context);
                              final XFile? image =
                              await widget._picker.pickImage(source: ImageSource.gallery);
                              setState(() {
                                widget.picture = "assets/images/avatar-1.png";
                              });
                            },
                                child:Row(
                                  children: [
                                    SizedBox(width: width / 27.4),

                                    ///15
                                    CircleAvatar(
                                      backgroundColor:
                                      Colors.grey[350],
                                      child: const Icon(
                                        IconData(0xf120,
                                            fontFamily:
                                            'MaterialIcons'),
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: width / 41.1),

                                    ///10
                                    Text(
                                      "Chọn ảnh đại diện",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: height / 56.87,

                                        ///15
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(height: height / 56.87),

                            ///15
                            GestureDetector(onTap: (){
                              /// todo: đăng xuất
                            },
                              child:
                              Row(
                                children: [
                                  SizedBox(width: width / 27.4),

                                  ///15
                                  CircleAvatar(
                                    backgroundColor:
                                    Colors.grey[350],
                                    child: const Icon(
                                      IconData(0xf88b,
                                          fontFamily:
                                          'MaterialIcons'),
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: width / 41.1),

                                  ///10
                                  Text(
                                    logout_string,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 56.87,

                                      ///15
                                    ),
                                  ),
                                ],
                              ),),
                          ],
                        ),
                      ));
                });
          },
        ));
  }

}