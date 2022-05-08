import 'package:flutter/widgets.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

final random = Random();

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
}

class PostData implements LazyLoadData {
  String id;
  late String title;
  late String description;
  late List<String> mediaUrls;
  late String outstandingIMGURL;
  int? price;
  late bool isGood;
  DateTime datetime = DateTime.now();
  LatLng? position;
  int react = random.nextInt(2) - 1;
  late List<String> cateList; // chứa string ID của các post category
  PostData({
    this.id = "new",
    required this.title,
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
    this.cateList = const [],
  });

  bool isEditable() {
    return true;
  }

  int i = 0;


  @override
  void loadMore() {
    // TODO: implement loadMore
  }

  CommentData get_a_previous_comment() {
    return CommentData(timestamp: DateTime.now());
  }

  int get_num_rate() {
    return 0;
  }

  List<List<String>> get_features() {
    return [
      ["200+", "Calories"],
      ["%10", "Fat"],
      ["%40", "Proteins"],
      ["200+", "Calories"],
      ["%10", "Fat"],
      ["%40", "Proteins"]
    ];
  }

  String get_location_name() {
    return "Hà Nội, Mai Dịch";
  }

  int get_react() {
    return react;
  }

  void change_react() {
    react += 1;
    if (react > 1) {
      react = -1;
    }
  }

  int get_upvote_rate() {
    return (random.nextDouble() * 1000).ceil();
  }

  int get_downvote_rate() {
    return (random.nextDouble() * 1000).ceil();
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
}

class ProfileData {
  String? id;
  String name;
  String userAsset;
  String wallAsset;
  int? mutualism;
  int? friendsNumber;
  String? dayOfBirth;
  String? gender;
  String? location;
  List<String>? works;
  List<String>? schools;
  List<String>? favorites;

  ProfileData({
    this.id,
    required this.name,
    required this.userAsset,
    required this.wallAsset,
    this.mutualism,
    this.friendsNumber,
    this.dayOfBirth,
    this.gender,
    this.location,
    List<String>? works,
    List<String>? schools,
    List<String>? favorites,
  }) {
    this.schools = schools ?? [];
    this.works = works ?? [];
    this.favorites = favorites ?? [];
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
