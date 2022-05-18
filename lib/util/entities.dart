import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  late List<List<String>> features;
  late bool isGood;
  LatLng? position;
  DateTime datetime = DateTime.now();
  int react = randomNumberGenerator.nextInt(2) - 1;
  late List<String> cateList; // chứa string ID của các post category
  PostData(
      {this.id = "new",
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
      this.features = const [
        ["200+", "Calories"],
        ["%10", "Fat"],
        ["%40", "Proteins"],
        ["200+", "Calories"]
      ]});

  int i = 0;

  int get numcite => 9999;

  LatLng positions() {
    return position ?? LatLng(0, 0);
    // i = ((i + 1) % position_list.length);
    // return position_list[i];
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
    return features;
  }

  Future<String?> getLocationName() async {
    if (position == null) {
      return None;
    }
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark place = placemarks[0];
    String address = "${place.name}, ${place.street}, "
        "${place.subLocality},"
        " ${place.locality}, ${place.administrativeArea} "
        "${place.postalCode}, ${place.country}";
    debugPrint("current place is " + address);
    return address;
  }

  int getReact() {
    /// todo: cài đặt sử dụng truy vấn bảng reaction
    return react;
  }

  void changeReact() {
    /// todo: thay đổi theo id người dùng hiện tại
    react += 1;
    if (react > 1) {
      react = -1;
    }
  }

  Future<Tuple2<int, int>> getRate() async {
    return await getRateByPostId(id);
  }

  PostData.fromJson(Map<String, Object?> json)

      /// todo: cài đặt có thể khởi tạo các position có kiểu Latng
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
    /// todo trả về tên người đăng bằng truy vấn cơ sở dữ liệu
    return "quang";
  }

  Future<bool> commit_changes() async {
    /// todo lưu lại toàn bộ thay đổi, return false nếu fail
    /// lưu ý rằng, sẽ có một số url vẫn còn là local, nên bước này sẽ bao gồm cả việc
    /// upload các media này lên
    return true;
  }

  /// todo: Khởi tạo thêm đặc tính features

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
  String id;
  String name;
  DateTime time;
  String userAsset;
  int? mutualism;

  FriendData({
    required this.id,
    required this.name,
    required this.time,
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
            time: (json['time'] as Timestamp).toDate(),
            mutualism: 0);

  String get time_string {
    return timeago.format(time);
  }

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

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final bool unread;
  final DateTime createdAt;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.unread,
    required this.createdAt
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    message: json["message"],
    unread: json["unread"],
    createdAt: json["createdAt"]?.toDate(),
  );

  Map<String, dynamic> toJson() => {
    "senderId": senderId,
    "receiverId": receiverId,
    "message": message,
    "unread": unread,
    "createdAt": createdAt.toUtc(),
  };
}