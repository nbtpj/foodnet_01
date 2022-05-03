import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;

import '../ui/screens/chat/model/message_model.dart';
import '../ui/screens/chat/model/user_model.dart';

List<LatLng> position_list = [const LatLng(37.42796133580664, -122.085749655962),
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

  CommentData({
    this.username = "Tuan",
    this.avatarUrl = "assets/friend/tarek.jpg",
    this.comment = "nice",
    required this.timestamp,
  });
}


class PostData implements LazyLoadData {
  String? id;
  late String title;
  late String description;
  late List<String> mediaUrls;
  late String outstandingIMGURL;
  int? price;
  late bool isGood;
  int react = randomNumberGenerator.nextInt(2) - 1;
  late List<String> cateList; // chứa string ID của các post category
  PostData({
    this.id,
    this.title = "",
    this.description =
    "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
        "Lorem ipsum dolor sit amet, consectetur adipiscing"
    ,
    this.mediaUrls = const [],
    this.outstandingIMGURL = '',
    this.price,
    this.isGood = true,
    this.cateList = const [],
  });

  int i = 0;

  LatLng positions() {
    i = ((i + 1) % position_list.length);
    return position_list[i];
  }
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
    return "Hà Nội, Mai Dịch, Phạm Văn Đồng, Hà Nội, Mai Dịch, Phạm Văn Đồng";
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
    return (randomNumberGenerator.nextDouble() * 1000).ceil();
  }

  int get_downvote_rate() {
    return (randomNumberGenerator.nextDouble() * 1000).ceil();
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

  Filter({this.search_type, this.keyword, this.scoreThreshold});
}

class Chat implements LazyLoadData{
  late User sender;
  late List<Message>? chats;

  Chat({
    required this.sender,
    this.chats
  });

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}