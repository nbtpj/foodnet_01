import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:foodnet_01/ui/components/loading_view.dart';
import 'package:foodnet_01/ui/components/media_list_scroll_view.dart';
import 'package:foodnet_01/ui/components/media_viewer.dart';
import 'package:foodnet_01/ui/screens/nav_bar.dart';
import 'package:foodnet_01/ui/screens/post_edit//widgets/food_image.dart';
import 'package:foodnet_01/ui/screens/post_edit/map_picker.dart';
import 'package:foodnet_01/ui/screens/post_edit/widgets/detail_widget.dart';
import 'package:foodnet_01/util/constants/animations.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:image_picker/image_picker.dart';

import '../../../util/navigate.dart';

class PostEditPreView extends StatefulWidget {
  PostData food;

  PostEditPreView({required this.food});

  @override
  _PostEditView createState() => _PostEditView();
}

class _PostEditView extends State<PostEditPreView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            FoodImage(food: widget.food),
            DetailWidget(food: widget.food),
          ],
        ),
      ),
    );
  }
}

class PostEditForm extends StatefulWidget {
  PostData food;
  late PostData begin;
  final ImagePicker _picker = ImagePicker();

  PostEditForm({required this.food}) {
    begin = food.clone();
  }

  @override
  _PostEditForm createState() => _PostEditForm();
}

class _PostEditForm extends State<PostEditForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  StatefulWidget _select_tags(PostData food, int i) {
    return FutureBuilder<List<PostData>>(
        future: getPosts(Filter(search_type: 'category')).toList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PostData> tags = snapshot.data ?? [];
            List<DropdownMenuItem<String>> builds = [
              DropdownMenuItem<String>(
                child: SizedBox(
                  height: SizeConfig.screenHeight / 16,
                  width: SizeConfig.screenWidth / 1.5,
                  child: Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.screenWidth / 10,
                      ),
                      const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(None,
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 18)))
                    ],
                  ),
                ),
                value: None,
              )
            ];
            builds.addAll([
              for (PostData tag in tags)
                DropdownMenuItem<String>(
                  child: SizedBox(
                    height: SizeConfig.screenHeight / 16,
                    width: SizeConfig.screenWidth / 1.5,
                    child: Row(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight / 16,
                          width: SizeConfig.screenWidth / 12,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: MediaWidget(url: tag.outstandingIMGURL)),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 16,
                          width: SizeConfig.screenWidth / 10,
                        ),
                        SizedBox(
                            width: SizeConfig.screenWidth / 4,
                            height: SizeConfig.screenHeight / 16,
                            child: Align(
                                alignment: FractionalOffset.center,
                                child: Text(tag.title,
                                    style: const TextStyle(
                                        color: Colors.orange, fontSize: 18)))
                            ),
                        SizedBox(
                          height: SizeConfig.screenHeight / 16,
                          width: SizeConfig.screenWidth / 10,
                        ),
                        SizedBox(
                            child: FutureBuilder<int>(
                          future: tag.numcite,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text("${snap.data!}",
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 18)));
                            } else {
                              return loading;
                            }
                          },
                        )),
                      ],
                    ),
                  ),
                  value: tag.title,
                )
            ]);
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: DropdownButton<String>(
                items: builds,
                value: food.cateList.length > i ? food.cateList[i] : None,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: const SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    if (food.cateList.contains(newValue!)) {
                      notify(already_chosen);
                      return;
                    }
                    if (newValue == None) {
                      if (food.cateList.length > i) {
                        food.cateList.removeAt(i);
                      }
                    } else {
                      if (food.cateList.isEmpty) {
                        food.cateList = [newValue];
                        return;
                      }
                      if (food.cateList.length <= i) {
                        food.cateList.addAll([newValue]);
                      } else {
                        food.cateList[i] = newValue;
                      }
                    }
                  });
                },
              ),
            );
          } else {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: SizeConfig.screenHeight / 16,
                  width: SizeConfig.screenWidth / 1.2,
                  child: loading,
                ));
          }
        });
  }

  Widget _select_cover_post() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: SizeConfig.screenHeight / 5,
        child: GestureDetector(
          child: MediaWidget(
            url: widget.food.outstandingIMGURL,
            isNet: null,
          ),
          onTap: () async {
            final XFile? image =
                await widget._picker.pickImage(source: ImageSource.gallery);
            setState(() {
              widget.food.outstandingIMGURL =
                  image == null ? widget.food.outstandingIMGURL : image.path;
            });
          },
        ),
      ),
    );
  }

  StatefulWidget _select_medias() {
    return widget.food.mediaUrls.isNotEmpty
        ? MediaList(
            children: [
              for (String element in widget.food.mediaUrls)
                GestureDetector(
                  child: MediaWidget(
                    url: element,
                    isNet: null,
                  ),
                  onLongPress: () {
                    setState(() {
                      List<String> temp = [];
                      temp.addAll(widget.food.mediaUrls);
                      temp.remove(element);
                      widget.food.mediaUrls = temp;
                      notify(delete_success);
                    });
                  },
                ),
              IconButton(
                  onPressed: () async {
                    final List<XFile>? images =
                        await widget._picker.pickMultiImage();
                    setState(() {
                      if (images != null)
                        widget.food.mediaUrls
                            .addAll([for (var img in images) img.path]);
                    });
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    size: SizeConfig.screenWidth / 5.0,
                    color: buttonColor,
                  )),
            ],
            autoPlay: false,
            nableInfiniteScroll: false,
          )
        : MediaList(
            children: [
              IconButton(
                  onPressed: () async {
                    final List<XFile>? images =
                        await widget._picker.pickMultiImage();
                    setState(() {
                      widget.food.mediaUrls
                          .addAll([for (var img in images!) img.path]);
                    });
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    size: SizeConfig.screenWidth / 5.0,
                    color: buttonColor,
                  )),
            ],
            autoPlay: false,
            nableInfiniteScroll: false,
          );
  }

  Widget _build_form() {
    return FormBuilder(
      key: _formKey,
      child: Expanded(
          child: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ListView(children: [
          _select_cover_post(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilderTextField(
              textAlign: TextAlign.center,
              name: "title",
              decoration: const InputDecoration(
                  labelText: name_string, border: OutlineInputBorder()),
              initialValue: widget.food.title,
              onChanged: (value) {
                widget.food.title = value ?? widget.food.title;
              },
            ),
          ),
          // _build_feat_selector(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilderTextField(
                name: "features",
                decoration: const InputDecoration(
                    labelText: features_string, border: OutlineInputBorder()),
                initialValue: [
                  for (var i_feat in widget.food.getFeatures())
                    "${i_feat[1]}: ${i_feat[0]}"
                ].join("; "),
                onChanged: (value) {
                  List<String> feats =
                      value != null ? value.replaceAll(" ", '').split(";") : [];
                  widget.food.features = [];
                  for (var feat in feats) {
                    try {
                      String a = feat.split(":")[0], b = feat.split(":")[1];

                      widget.food.features.add([b, a]);
                    } catch (e) {}
                    ;
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilderTextField(
                name: "description",
                initialValue: widget.food.description,
                decoration: const InputDecoration(
                    labelText: description_string,
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  widget.food.description = value ?? widget.food.description;
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilderTextField(
                name: "price",
                decoration: const InputDecoration(
                    hintText: price_string,
                    labelText: lang == "en" ? "Price" : "Gi??",
                    border: OutlineInputBorder()),
                autofillHints: const ["000 vnd", "500 vnd", ".99 \$"],
                validator: (value) {
                  if (value == null) return null;
                  value = value.replaceAll("[^\\d.]", "");
                  return value;
                },
                initialValue: widget.food.price?.toString() ?? None,
                onChanged: (value) {
                  try {
                    if (value != None) {
                      widget.food.price = int.parse(value!);
                    } else {
                      widget.food.price = null;
                    }
                  } catch (e) {
                    notify(notValidString);
                  }
                }),
          ),
          FormBuilderSwitch(
              name: "isGood",
              decoration: const InputDecoration(border: InputBorder.none),
              initialValue: widget.food.isGood,
              title: const Text(sale_this_thing),
              onChanged: (value) {
                widget.food.isGood = value!;
              }),
          for (int i = 0; i < 3; i++) _select_tags(widget.food, i),
          _select_medias(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationPicker(
                                food: widget.food,
                              )));
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.screenWidth / 51.38),
                      child: Icon(
                        Icons.location_pin,
                        color: freeDelivery,
                        size: SizeConfig.screenHeight / 22.77,
                      ),
                    ),
                    FutureBuilder<String?>(
                        future: widget.food.getLocationName(),
                        builder: (context, snapshot) => Text(
                              snapshot.hasData ? snapshot.data ?? None : None,
                              style: TextStyle(
                                  color: freeDelivery,
                                  fontWeight: FontWeight.bold,
                                  // overflow: TextOverflow.fade,
                                  fontSize: SizeConfig.screenHeight / 44.69),
                            ))
                  ],
                )),
          )
        ]),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigate.popPage(context);
            },
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            iconSize: height / 28.43,
            padding: const EdgeInsets.only(right: 10),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: buttonColor,
          toolbarHeight: height / 12.186, ///70
          title: Padding(
            padding: EdgeInsets.only(left: width / 23),
            child: Text(
              editPostString,
              style: TextStyle(
                fontSize: height / 30.464, ///28
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Column(children: [
          SizedBox(height: height / 85.3,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: SizeConfig.screenHeight / 19.51,
                  width: SizeConfig.screenWidth / 10.28,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostEditPreView(
                                      food: widget.food,
                                    )));
                      },
                      icon: const Icon(
                        Icons.preview,
                        color: Colors.amberAccent,
                      ))),
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
                        _formKey.currentState?.save();
                        bool t = await widget.food.commit_changes();
                        if (t) {
                          notify(upload_success);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()));
                        } else {
                          notify(upload_fail);
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        color: freeDelivery,
                      ))),
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
                        bool t = await widget.food.delete();
                        if (t) {
                          notify(upload_success);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()));
                        } else {
                          notify(upload_fail);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))),
            ],
          ),
          _build_form(),
        ]));
  }
}
