import 'package:tuple/tuple.dart';
import 'dart:math';

final randomNumberGenerator = Random();

/// định nghĩa các đối tượng dữ liệu

class LazyLoadData {
  /// interface lazy load cho các đối tượng có quá nhiều dữ liệu
  /// ví dụ như: nếu đối tượng PostData chỉ cần hiển thị brief view thì không cần phải load toàn bộ các media.
  void loadMore() async {}
}

class PostData implements LazyLoadData {
  String? id;
  String title = '';
  String description = "Lorem ipsum dolor sit amet, consectetur adipiscing"
      " elit, sed do eiusmod tempor incididunt ut labore et dolore magna "
      "aliqua. Ut enim ad minim veniam, quis nostrud eslednjn";
  List<String> mediaUrls = [];
  String outstandingIMGURL = '';
  int price = 0;
  bool isGood = true;
  int react = randomNumberGenerator.nextInt(2)-1;
  List<String> cateList = []; // chứa string ID của các post category
  PostData({
    this.id,
    this.title = "",
    this.description = "Lorem ipsum dolor sit amet, consectetur adipiscing"
        " elit, sed do eiusmod tempor incididunt ut labore et dolore magna "
        "aliqua. Ut enim ad minim veniam, quis nostrud eslednjn",
    this.mediaUrls = const [],
    this.outstandingIMGURL = '',
    this.price = 0,
    this.isGood = true,
    this.cateList = const [],
  });

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

  double get_rate() { return (randomNumberGenerator.nextDouble()*1000).ceil().toDouble();}

  String get_location_name() {return "Hà Nội, Mai Dịch, Phạm Văn Đồng, Hà Nội, Mai Dịch, Phạm Văn Đồng";}

  int get_react() { return react;}

  void change_react() {
    react += 1;
    if(react>1){
      react = -1;
    }
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

class Filter {
  /// lớp đại diện cho các điều kiện lọc cho tìm kiếm
  late String? search_type;
  late String? keyword;
  late double? scoreThreshold;

  Filter({this.search_type, this.keyword, this.scoreThreshold});
}
