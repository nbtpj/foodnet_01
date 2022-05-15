import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

List<LatLng> position_list = [
  const LatLng(37.42796133580664, -122.085749655962),
  const LatLng(37.42484642575639, -122.08309359848501),
  const LatLng(37.42381625902441, -122.0928531512618),
  const LatLng(37.41994095849639, -122.08159055560827),
  const LatLng(37.413175077529935, -122.10101041942836),
  const LatLng(37.419013242401576, -122.11134664714336),
  const LatLng(37.40260962243491, -122.0976958796382),
];

final randomNumberGenerator = Random();

/// định nghĩa các đối tượng dữ liệu

class LazyLoadData {
  /// interface lazy load cho các đối tượng có quá nhiều dữ liệu
  /// ví dụ như: nếu đối tượng PostData chỉ cần hiển thị brief view thì không cần phải load toàn bộ các media.
  void loadMore() async {}
}

class CommentData {
  late String username;
  late String avatarUrl;
  late String comment;
  late DateTime timestamp;
  late List<String> mediaUrls;

  CommentData({
    this.username = "Tuan",
    this.avatarUrl = "assets/friend/tarek.jpg",
    this.comment = "nice",
    this.mediaUrls = const [
      "assets/food/HeavenlyPizza.jpg",
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
    ],
    required this.timestamp,
  });

  Future<bool> post() async {
    return true;
  }

  bool isEmpty() {
    return comment.isEmpty && mediaUrls.isEmpty;
  }

  String get userID {
    return "1";
  }
}

class PostData implements LazyLoadData {
  String id;
  late String title;
  late String description;
  late List<String> mediaUrls;
  late String outstandingIMGURL;
  int? price;
  late bool isGood;
  LatLng? position;
  DateTime datetime = DateTime.now();
  int react = randomNumberGenerator.nextInt(2) - 1;
  late List<String> cateList; // chứa string ID của các post category
  PostData({
    this.id = "new",
    this.title = "",
    this.description = "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing",
    this.mediaUrls = const [
      "assets/food/HeavenlyPizza.jpg",
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
    ],
    this.outstandingIMGURL = '',
    this.price,
    this.isGood = true,
    this.react = 1,
    this.cateList = const [],
  });

  int i = 0;

  int get numcite => 9999;

  LatLng positions() {
    i = ((i + 1) % position_list.length);
    return position_list[i];
  }

  bool isEditable() {
    return true;
  }

  @override
  void loadMore() {
    // TODO: implement loadMore
  }

  CommentData getPreviousComment() {
    return CommentData(timestamp: DateTime.now());
  }

  int getNumRate() {
    return 0;
  }

  List<List<String>> getFeatures() {
    return [
      ["200+", "Calories"],
      ["%10", "Fat"],
      ["%40", "Proteins"],
      ["200+", "Calories"],
      ["%10", "Fat"],
      ["%40", "Proteins"]
    ];
  }

  String getLocationName() {
    return "Hà Nội, Mai Dịch, Phạm Văn Đồng, Hà Nội, Mai Dịch, Phạm Văn Đồng";
  }

  int getReact() {
    return react;
  }

  void changeReact() {
    react += 1;
    if (react > 1) {
      react = -1;
    }
  }

  int getUpvoteRate() {
    return (randomNumberGenerator.nextDouble() * 1000).ceil();
  }

  int getDownvoteRate() {
    return (randomNumberGenerator.nextDouble() * 1000).ceil();
  }

  PostData.fromJson(Map<String, Object?> json)
      : this(
            id: json['id']! as String,
            description: json['description']! as String,
            cateList:
                (json['cateList'] as List).map((e) => e as String).toList(),
            price: json['price']! as int,
            isGood: json['isGood']! as bool,
            react: json['react']! as int,
            outstandingIMGURL: json['outstandingIMGURL']! as String,
            title: json['title']! as String);

  PostData.categoryFromJson(Map<String, Object?> json)
      : this(
            id: json['id']! as String,
            title: json['title']! as String,
            outstandingIMGURL: json['outstandingIMGURL']! as String);

  Map<String, Object?> toJson() {
    return {
      "description": description,
      "cateList": cateList,
      "price": price,
      "isGood": isGood,
      "react": react
    };
  }

  Map<String, Object?> categoryToJson() {
    return {"title": title, "outstandingIMGURL": outstandingIMGURL};
  }

  String getOwner() {
    return "quang";
  }

  Future<bool> commit_changes() async {
    /// todo
    return true;
  }

  PostData clone() {
    return PostData(
      id: id,
      title: title,
      description: description,
      mediaUrls: mediaUrls,
      outstandingIMGURL: outstandingIMGURL,
      price: price,
      isGood: isGood,
      react: react,
      cateList: cateList,
    );
  }
}

class BoxChatData implements LazyLoadData {
  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class UserData implements LazyLoadData {
  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class FriendData implements LazyLoadData {
  String? id;
  String name;
  String? time;
  String userAsset;
  int? mutualism;

  FriendData({
    this.id,
    required this.name,
    this.time,
    required this.userAsset,
    this.mutualism,
  });

  @override
  void loadMore() {
    // TODO: implement loadMore
  }

  FriendData.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"]! as String,
            name: json["name"]! as String,
            userAsset: json["userAsset"] as String,
            mutualism: 0);

  Map<String, Object?> toJson() {
    return {
      if (id != null) "id": id,
      "name": name,
      if (time != null) "time": time,
      "userAsset": userAsset
    };
  }
}

class ProfileData {
  String? id;
  String name;
  String userAsset;
  String wallAsset;
  int? mutualism;
  int friendsNumber = 0;
  String? dayOfBirth;
  String? gender;
  String? location;
  List<String>? works;
  List<String>? schools;
  List<String>? favorites;
  List<String>? friendReferences;

  ProfileData({
    this.id,
    required this.name,
    required this.userAsset,
    required this.wallAsset,
    this.mutualism,
    this.friendsNumber = 0,
    this.dayOfBirth,
    this.gender,
    this.location,
    List<String>? works,
    List<String>? schools,
    List<String>? favorites,
    List<String>? friendReferences,
  }) {
    this.schools = schools ?? [];
    this.works = works ?? [];
    this.favorites = favorites ?? [];
    this.friendReferences = friendReferences ?? [];
  }

  ProfileData.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"]! as String,
            name: json["name"]! as String,
            userAsset: json["userAsset"]! as String,
            wallAsset: json["wallAsset"]! as String,
            dayOfBirth: (json["dob"]! as Timestamp).toDate().toString(),
            gender: json["gender"]! as String,
            location: json["location"] as String,
            works: (json["works"] as List).map((e) => e as String).toList(),
            schools: (json["schools"] as List).map((e) => e as String).toList(),
            favorites:
                (json["favorites"] as List).map((e) => e as String).toList(),
            friendReferences: (json["friends"]! as List)
                .map((e) => e.path as String)
                .toList(),
            friendsNumber: (json["friends"] as List).length
            // friends: (json["friends"] as List).map((e) => e as FriendData).toList(),
            );

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "name": name,
      "userAsset": userAsset,
      "wallAsset": wallAsset,
      "dob": dayOfBirth,
      "gender": gender,
      "location": location,
      "works": works,
      "schools": schools,
      "favorites": favorites,
      "friends": friendReferences,
      "friendsNumber": friendsNumber
    };
  }
}

class SearchData implements LazyLoadData {
  String? id;
  String? asset;
  String name;

  SearchData({
    this.id,
    this.asset,
    required this.name,
  });

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class Filter {
  /// lớp đại diện cho các điều kiện lọc cho tìm kiếm
  late String? search_type;
  late String? keyword;
  late double? scoreThreshold;
  LatLngBounds? vision_bounds;

  Filter(
      {this.search_type,
      this.keyword,
      this.scoreThreshold,
      LatLngBounds? this.vision_bounds});
}
