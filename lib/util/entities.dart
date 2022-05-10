import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';


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
  late String userID;
  late String comment;
  late DateTime timestamp;
  late List<String> mediaUrls;

  CommentData({
    this.userID = "current_user",
    this.comment = "nice",
    this.mediaUrls = const [
      "assets/food/HeavenlyPizza.jpg",
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
    ],
    required this.timestamp,
  });
  String get username {
    return "tuan";
  }
  String get avatarUrl {
    return "assets/friend/tarek.jpg";
  }

  Future<bool> post() async {
    /// todo: hàm này cần gán thêm các username người comment vào, userID
    return true;
  }

  bool isEmpty() {
    return comment.isEmpty && mediaUrls.isEmpty;
  }
}


class PostData implements LazyLoadData {
  // static const DateTime adate = const DateTime(2021);
  String id;
  late String title;
  late String description;
  late List<String> mediaUrls;
  late String outstandingIMGURL;
  int? price;
  late bool isGood;
  late int n_upvote, n_downvote, n_rate, react;
  String? add_name;
  LatLng? position;
  DateTime? datetime = DateTime(2021);
  late List<String> cateList; // chứa string ID của các post category
  PostData({
    this.id = "new",
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
    this.mediaUrls = const [
      "assets/food/HeavenlyPizza.jpg",
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
    ],
    this.outstandingIMGURL = '',
    this.price,
    this.isGood = true,
    this.react = 1,
    this.cateList = const [],
    this.add_name,
    this.n_downvote = 0,
    this.n_upvote = 0,
    this.n_rate = 0,
    this.datetime,
    this.position,

  });

  int i = 0;

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

  String? get_location_name() {
    return add_name;
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
  int getUpvoteRate() {return (randomNumberGenerator.nextDouble()*1000).ceil();}

  int getDownvoteRate() {return (randomNumberGenerator.nextDouble()*1000).ceil();}

  PostData.fromJson(Map<String, Object?> json) : this(
      id: json['id']! as String,
      title: json['title'] as String,
      description: json['description']! as String,
      cateList: (json['cateList'] as List).map((e) => e as String).toList(),
      price: json['price']! as int,
      isGood: json['isGood']! as bool,
      react: json['react']! as int,
      // n_downvote: json['n_downvote']! as int,
      // n_rate: json['n_rate']! as int,
      // n_upvote: json['n_upvote']! as int,
      // datetime: json['datetime']! as DateTime,
      outstandingIMGURL: json['outstandingIMGURL']! as String
  );

  PostData.categoryFromJson(Map<String, Object?> json) : this(
      id: json['id']! as String,
      title: json['title']! as String,
      outstandingIMGURL: json['outstandingIMGURL']! as String
  );

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
    return {
      "title" : title,
      "outstandingIMGURL": outstandingIMGURL
    };
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
  List<FriendData>? friends;

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
    List<FriendData> ? friends,
  }) {
    this.schools = schools ?? [];
    this.works = works ?? [];
    this.favorites = favorites ?? [];
    this.friends = friends ?? [];
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
  }}

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
