import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/screens/discovery/map_style.dart';
import 'package:foodnet_01/ui/screens/post_detail/post_detail.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/images.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:timeago/timeago.dart' as timeago;

class Discovery extends StatefulWidget {
  late CameraPosition init_state;

  Discovery(
      {Key? key,
      this.init_state = const CameraPosition(
        target: LatLng(20.8861024, 106.4049451),
        zoom: 14.4746,
      )})
      : super(key: key);

  @override
  _DiscoveryState createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  final Set<Marker> _markers = {};
  late GoogleMapController _controller;
  List<PostData> _ls = [];
  bool following = false;

  Future<List<PostData>> fetchFoodOnThisLocation(BuildContext context) async {
    var a = await _controller.getLatLng(ScreenCoordinate(
            x: 0,
            y: MediaQuery.of(context).size.height *
                MediaQuery.of(context).devicePixelRatio ~/
                1)),
        b = await _controller.getLatLng(ScreenCoordinate(
            x: MediaQuery.of(context).size.width *
                MediaQuery.of(context).devicePixelRatio ~/
                1,
            y: 0)),
        c = await _controller.getLatLng(const ScreenCoordinate(x: 0, y: 0)),
        d = await _controller.getLatLng(ScreenCoordinate(
            x: MediaQuery.of(context).size.width *
                MediaQuery.of(context).devicePixelRatio ~/
                1,
            y: MediaQuery.of(context).size.height *
                MediaQuery.of(context).devicePixelRatio ~/
                1));
    List<double> visibleRegion = [
      [a.latitude, b.latitude, c.latitude, d.latitude].reduce(min),
      [a.latitude, b.latitude, c.latitude, d.latitude].reduce(max),
      [a.longitude, b.longitude, c.longitude, d.longitude].reduce(min),
      [a.longitude, b.longitude, c.longitude, d.longitude].reduce(max)
    ];
    return getPosts(Filter(
            search_type: 'base_on_locations', visibleRegion: visibleRegion))
        .toList();
  }

  Widget _buildFoodList(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight / 2.28,

      /// 300.0
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _ls.length,
        itemBuilder: (context, index) {
          var food = _ls[index];
          return GestureDetector(
            onTap: () {
              if (food.position != null) {
                setState(() {
                  following = false;
                });
                _controller.moveCamera(CameraUpdate.newLatLng(
                    food.position ?? const LatLng(0.3, 32.0)));
                // _controller.moveCamera(CameraUpdate.zoomBy(16));
              }
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
                                image: NetworkImage(food.outstandingIMGURL),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      food.title,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize:
                                              SizeConfig.screenHeight / 34.15,

                                          /// 20
                                          fontWeight: FontWeight.w700),
                                    )),
                                FutureBuilder<ProfileData?>(
                                    future: food.getOwner(),
                                    builder: (context, snap) => snap.hasData
                                        ? FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(snap.data?.name ?? None,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: SizeConfig
                                                            .screenHeight /
                                                        40,
                                                    fontFamily: "Roboto")))
                                        : const SizedBox.shrink()),
                                food.cateList.isNotEmpty
                                    ? FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          food.cateList.join(','),
                                          style: TextStyle(
                                              color: Colors.black38,
                                              fontSize:
                                                  SizeConfig.screenHeight /
                                                      42.69,

                                              /// 16
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.screenHeight / 136.6),

                                  /// 5.0
                                  child: food.isGood
                                      ? Text(
                                          "\$${food.price}",
                                          style: TextStyle(
                                              color: buttonColor,
                                              fontSize:
                                                  SizeConfig.screenHeight /
                                                      37.95,

                                              /// 18
                                              fontWeight: FontWeight.bold),
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
                                      bottomRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(30.0),
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
      // debugPrint("this is a log :current position is " + loc.toString());
    });

    return Scaffold(
        body: Stack(children: [
      GoogleMap(
        // polygons: myPolygon(),
        initialCameraPosition: widget.init_state,
        markers: _markers,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) async {
          _controller = controller;
          _ls = await fetchFoodOnThisLocation(context);
          controller.setMapStyle(MapStyle().aubergine);
        },
        onCameraIdle: () async {
          var a = await fetchFoodOnThisLocation(context);
          for (var element in a) {
            createMarker(context, element);
          }
          setState(()  {
            _ls = a;
          });
        },
      ),
      Row(
        children: [
          const ArrowBack(),
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
        ],
      ),
      Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: _buildFoodList(context),
      )
    ]));
  }

  createMarker(BuildContext context, PostData food) async {
    if (food.position != null) {
      Marker marker = Marker(
          markerId: MarkerId(food.id),
          position: food.position!,
          icon:
              await _getAssetIcon(context, markerAsset).then((value) => value),
          infoWindow: InfoWindow(
            title: food.title,
            snippet: food.datetime != null
                ? timeago.format(food.datetime)
                : "unknown",
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetailView(food: food)));
          });
      setState(() {
        _markers.add(marker);
      });
    }
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
    int icon_size =
        min(SizeConfig.screenWidth ~/ 7, SizeConfig.screenHeight ~/ 7);

    ResizeImage(img, width: icon_size, height: icon_size, allowUpscaling: true)
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }
}
