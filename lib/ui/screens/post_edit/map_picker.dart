import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/arrow_back.dart';
import 'package:foodnet_01/ui/screens/discovery//map_style.dart';
import 'package:foodnet_01/ui/screens/post_edit/post_edit.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  late CameraPosition init_state;
  late PostData food;
  LatLng? _location;

  LocationPicker({Key? key,
    required this.food})
      : super(key: key) {
    init_state = CameraPosition(
      target: food.positions(),
      zoom: 16,
    );
    _location = food.position;
  }


  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [

          GoogleMap(
            initialCameraPosition: widget.init_state,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              controller.setMapStyle(MapStyle().aubergine);
            },
            onCameraMove: (cam) async{
              widget._location = cam.target;
            },
            onCameraIdle: () {
              setState(() {});
            },
          ),
          Positioned(
              left: SizeConfig.screenWidth / 41.1,
              top: SizeConfig.screenHeight / 20,
              child: Row(
                children:  [const ArrowBack(),
                  SizedBox(width: SizeConfig.screenWidth / 41.1,),
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
                            widget.food.position = widget._location;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostEditForm(food: widget.food,)));
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ))),
                ],
              ),
          ),
          Positioned(
            left: SizeConfig.screenWidth / 2-25,
            top: SizeConfig.screenHeight / 2-50,
            child: const Icon(
              Icons.place,
              size: 50,
              color: Colors.deepOrange,
            ),
          ),
        ]));
  }
}
