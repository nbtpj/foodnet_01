import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/media_viewer.dart';
import 'package:foodnet_01/util/global.dart';

class MediaList extends StatefulWidget {
  List<MediaWidget> children;
  MediaList({Key? key, required this.children}) : super(key: key);

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: SizeConfig.screenHeight / 34.15,
          bottom: SizeConfig.screenHeight / 68.3),

      /// 20.0 - 10.0
      child: Builder(
        builder: (context) {
          return SizedBox(
            height: SizeConfig.screenHeight / 3.415,

            /// 200.0
            width: SizeConfig.screenWidth,

            /// 411.0
            child: CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
              items: widget.children
                  .map((e) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [e],
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
