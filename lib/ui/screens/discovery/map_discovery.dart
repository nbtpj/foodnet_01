import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodnet_01/ui/screens/discovery/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class Discovery extends StatefulWidget {
  const Discovery({Key? key}) : super(key: key);

  @override
  _DiscoveryState createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng( 20.8861024, 106.4049451),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};
  late GoogleMapController _controller;
  bool following = true;
  List<PostData> current_lists = [];

  Future<List<PostData>> fetchFoodOnThisLocation() async {
    var vision_bounds = await _controller.getVisibleRegion();
    return getPosts(Filter(search_type: 'food', vision_bounds: vision_bounds))
        .toList();
  }

  Widget _buildFoodList(BuildContext context) {
    return FutureBuilder<List<PostData>>(
      future: fetchFoodOnThisLocation(),
      builder: (context, snapshot) {
        // debugPrint("this is a log " +snapshot.toString());
        if (snapshot.hasData) {
          var foodList = snapshot.data ?? [];
          // debugPrint("this is a log " + foodList.toString());
          for (var element in foodList) {
            createMarker(context, element);
          }
          return SizedBox(
            height: SizeConfig.screenHeight / 2.28,

            /// 300.0
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                var food = foodList[index];
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      following = false;
                    });
                    _controller.moveCamera(CameraUpdate.newLatLng(
                        food.position ?? const LatLng(0.347596, 32.582520)));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PostDetailView(food: food)));
                  },
                  onDoubleTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostDetailView(food: food)));
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
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "${food.outstandingIMGURL}"),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: const Radius.circular(30.0)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${food.title}",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize:
                                                SizeConfig.screenHeight / 34.15,

                                            /// 20
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "${food.cateList.join(',')}",
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize:
                                                SizeConfig.screenHeight / 42.69,

                                            /// 16
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.screenHeight /
                                                136.6),

                                        /// 5.0
                                        child: food.isGood
                                            ? Text(
                                                "\$${food.price}",
                                                style: TextStyle(
                                                    color: buttonColor,
                                                    fontSize: SizeConfig
                                                            .screenHeight /
                                                        37.95,

                                                    /// 18
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            food.isGood
                                ? Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: SizeConfig.screenHeight / 13.66,

                                      /// 50.0
                                      width: SizeConfig.screenWidth / 8.22,

                                      /// 50.0
                                      decoration: BoxDecoration(
                                          color: buttonColor,
                                          borderRadius: const BorderRadius.only(
                                            bottomRight:
                                                const Radius.circular(30.0),
                                            topLeft:
                                                const Radius.circular(30.0),
                                          )),
                                      child: const Icon(
                                        Icons.shopping_cart_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // createMarkers(context);

    location.onLocationChanged.listen((LocationData loc) {
      following
          ? _controller.moveCamera(CameraUpdate.newLatLng(
              LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)))
          : 1;
      debugPrint("this is a log :current position is " +loc.toString());
    });


    return Scaffold(
        body: Stack(children: [
      GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: _markers,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          controller.setMapStyle(MapStyle().aubergine);
        },
        onCameraIdle: () {
          setState(() {});
        },
      ),
      Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: _buildFoodList(context),
      ),
      // Positioned(
      //   bottom: 50,
      //   left: 20,
      //   right: 20,
      //   child: Container(
      //       width: MediaQuery.of(context).size.width,
      //       height: 120,
      //       decoration: BoxDecoration(
      //           color: Colors.white, borderRadius: BorderRadius.circular(20)),
      //       child: ListView.builder(
      //         scrollDirection: Axis.horizontal,
      //         itemCount: _contacts.length,
      //         itemBuilder: (context, index) {
      //           return GestureDetector(
      //             onTap: () {
      //               _controller.moveCamera(
      //                   CameraUpdate.newLatLng(_contacts[index]["position"]));
      //             },
      //             child: Container(
      //               width: 100,
      //               height: 100,
      //               margin: const EdgeInsets.only(right: 10),
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Image.asset(
      //                     _contacts[index]['image'],
      //                     width: 60,
      //                   ),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),
      //                   Text(
      //                     _contacts[index]["name"],
      //                     style: const TextStyle(
      //                         color: Colors.black, fontWeight: FontWeight.w600),
      //                   )
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       )),
      // ),

      FloatingActionButton(
        child: Icon(
          following ? Icons.share_location : Icons.not_listed_location,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            following ? following = false : following = true;
          });
        },
      )
    ]));
  }

  createMarker(BuildContext context, PostData food) async {
    // if (food.position != null) {
      Marker marker = Marker(
        markerId: MarkerId(food.id),
        position: food.position ?? const LatLng(0.347596, 32.582520),
        icon: await _getAssetIcon(context, food.outstandingIMGURL)
            .then((value) => value),
        infoWindow: InfoWindow(
          title: food.title,
          snippet: timeago.format(food.datetime),
        ),
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailView(food: food)));
        }
      );
      setState(() {
        _markers.add(marker);
      });
    // }
  }

  Future<BitmapDescriptor> _getAssetIcon(
      BuildContext context, String icon) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: const Size(5, 5));

    ImageProvider img;

    try {
      img = AssetImage(icon);
    } catch (e) {
      try {
        img = FileImage(File(icon));
      } catch (e) {
        img = NetworkImage(icon);
      }
    }
    int icon_size = min(SizeConfig.screenWidth~/10,SizeConfig.screenHeight~/10);

    ResizeImage(img, width: icon_size, height: icon_size, allowUpscaling: true).resolve(config).addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }
}
