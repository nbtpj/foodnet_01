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
  int react = randomNumberGenerator.nextInt(2)-1;
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

  String get_location_name() {return "Hà Nội, Mai Dịch, Phạm Văn Đồng, Hà Nội, Mai Dịch, Phạm Văn Đồng";}

  int get_react() { return react;}

  void change_react() {
    react += 1;
    if(react>1){
      react = -1;
    }
  }
  int get_upvote_rate() {return (randomNumberGenerator.nextDouble()*1000).ceil();}

  int get_downvote_rate() {return (randomNumberGenerator.nextDouble()*1000).ceil();}
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

class Filter {
  /// lớp đại diện cho các điều kiện lọc cho tìm kiếm
  late String? search_type;
  late String? keyword;
  late double? scoreThreshold;

  Filter({this.search_type, this.keyword, this.scoreThreshold});
}
