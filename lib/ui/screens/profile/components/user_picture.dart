import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/AuthWrapperHome.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../util/constants/strings.dart';
import '../../../../util/entities.dart';
import '../../../../util/global.dart';
import '../../../../util/navigate.dart';
import '../../../components/media_viewer.dart';
import '../view_photo.dart';

//ignore: must_be_immutable
class UserPicture extends StatefulWidget {
  late ProfileData profile;
  final String type;
  final ImagePicker _picker = ImagePicker();

  UserPicture({Key? key,
    required this.profile,
    required this.type,
  }) : super(key: key);

  @override
  _UserPictureState createState() => _UserPictureState();
}

class _UserPictureState extends State<UserPicture> {
  double width = SizeConfig.screenWidth;
  double height = SizeConfig.screenHeight;

  @override
  Widget build(BuildContext context) {
    String picture = widget.profile.userAsset;
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
            child: SizedBox(
              height: height / 7.11,
              width: width / 3.425,
              child: MediaWidget(
                url: picture,
                isNet: true,
              ),
            ),
          ),
          onTap: () {
            widget.type == "me" ?
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
                              Navigate.pushPageReplacement(context, PhotoPage(picture: picture));
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
                              final XFile? image =
                              await widget._picker.pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                String temp = widget.profile.userAsset;
                                widget.profile.userAsset = image.path;
                                bool success = await widget.profile.update("userAsset");
                                if (!success) {
                                  widget.profile.userAsset = temp;
                                }
                                setState(() {
                                  widget.profile.userAsset = widget.profile.userAsset;
                                });
                              }
                              Navigator.pop(context);
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
                            GestureDetector(onTap: ()async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return const AuthWrapperHome();
                              }));
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
                }) : Navigate.pushPage(context, PhotoPage(picture: picture))
            ;
          },
        ));
  }

}