import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../util/constants/colors.dart';
import '../../../../util/entities.dart';
import '../../../../util/global.dart';
import '../../../../util/navigate.dart';
import '../../../components/media_viewer.dart';
import '../view_photo.dart';

//ignore: must_be_immutable
class WallPicture extends StatefulWidget {
  late ProfileData profile;
  final String type;
  final ImagePicker _picker = ImagePicker();

  WallPicture({Key? key,
    required this.profile,
    required this.type,
  }) : super(key: key);

  @override
  _WallPictureState createState() => _WallPictureState();
}

class _WallPictureState extends State<WallPicture> {
  double width = SizeConfig.screenWidth;
  double height = SizeConfig.screenHeight;
  @override
  Widget build(BuildContext context) {
    String picture = widget.profile.wallAsset;
    return Positioned(
      left: 0,
      top: 0,
      child: InkWell(
        child: Container(
          color: lightColor,
          height: height / 4.74,
          width: MediaQuery.of(context).size.width,
          ///180
          child: MediaWidget(
            url: picture,
            isNet: true,
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: height / 42.65,

                        ///20
                      ),

                      InkWell(
                        child: Row(
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
                              "Xem ảnh bìa",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 56.87,

                                ///15
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigate.pushPageReplacement(context, PhotoPage(picture: picture));
                        },
                      ),
                      SizedBox(height: height / 56.87),

                      ///15

                      InkWell(
                        child: Row(
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
                              "Chọn ảnh bìa",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height / 56.87,

                                ///15
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          final XFile? image =
                          await widget._picker.pickImage(source: ImageSource.gallery);
                          Navigator.pop(context);
                          if (image != null) {
                            String temp = widget.profile.wallAsset;
                            widget.profile.wallAsset = image.path;
                            bool success = await widget.profile.update("wallAsset");
                            if (!success) {
                              widget.profile.wallAsset = temp;
                            }
                            setState(() {
                              widget.profile.wallAsset = widget.profile.wallAsset;
                            });
                          }

                        },
                      )

                    ],
                  ),
                );
              }) : Navigate.pushPage(context, PhotoPage(picture: picture));
        },
      ),
    );
  }

}