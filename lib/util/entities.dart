import 'package:tuple/tuple.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;


final randomNumberGenerator = Random();

/// định nghĩa các đối tượng dữ liệu

class LazyLoadData {
  /// interface lazy load cho các đối tượng có quá nhiều dữ liệu
  /// ví dụ như: nếu đối tượng PostData chỉ cần hiển thị brief view thì không cần phải load toàn bộ các media.
  void loadMore() async {}
}
class CommentData{
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
  int react;
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
    this.react = 1,
  });

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
  CommentData get_a_previous_comment() {
    return CommentData(timestamp:DateTime.now());
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

  String getLocationName() {return "Hà Nội, Mai Dịch, Phạm Văn Đồng, Hà Nội, Mai Dịch, Phạm Văn Đồng";}

  int getReact() { return react;}

  void changeReact() {
    react += 1;
    if(react>1){
      react = -1;
    }
  }
  int getUpvoteRate() {return (randomNumberGenerator.nextDouble()*1000).ceil();}

  int getDownvoteRate() {return (randomNumberGenerator.nextDouble()*1000).ceil();}

  PostData.fromJson(Map<String, Object?> json) : this(
    id: json['id']! as String,
    description: json['description']! as String,
    cateList: (json['cateList'] as List).map((e) => e as String).toList(),
    price: json['price']! as int,
    isGood: json['isGood']! as bool,
    react: json['react']! as int,
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

class Filter {
  /// lớp đại diện cho các điều kiện lọc cho tìm kiếm
  late String? search_type;
  late String? keyword;
  late double? scoreThreshold;

  Filter({this.search_type, this.keyword, this.scoreThreshold});
}
