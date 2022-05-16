import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/image_provider.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/screens/home/home.dart';
// import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';

class FoodImage extends StatefulWidget {
  PostData food;
  FoodImage({required this.food});

  @override
  _FoodImageState createState() => _FoodImageState();
}

class _FoodImageState extends State<FoodImage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FutureBuilder<ImageProvider>(
      future: any_image(widget.food.outstandingIMGURL, null),
        builder: (context, snapshot) => Container(
      height: SizeConfig.screenHeight * 0.45,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        image: DecorationImage(
            image: snapshot.data!,
            fit: BoxFit.contain
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth/13.7, vertical: SizeConfig.screenHeight/34.15),     /// 30.0 - 20.0
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ArrowBack(),
              Container(
                  height: SizeConfig.screenHeight / 19.51,
                  width: SizeConfig.screenWidth / 10.28,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () async {
                        await widget.food.commit_changes()?
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => const Home()
                            )): Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.check,
                        // size: SizeConfig.screenWidth / 10.28,
                        color: Colors.white,
                      ))),
            ],
          ),
        ),
      ),
    ));
  }
}
