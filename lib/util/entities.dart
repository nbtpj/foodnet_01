/// định nghĩa các đối tượng dữ liệu

class LazyLoadData {
  /// interface lazy load cho các đối tượng có quá nhiều dữ liệu
  /// ví dụ như: nếu đối tượng PostData chỉ cần hiển thị brief view thì không cần phải load toàn bộ các media.
  void loadMore() async {}
}

class PostData implements LazyLoadData {
  String? id;
  String title = '';
  String description = '';
  List<String> mediaUrls = [];
  String outstandingIMGURL = '';
  int price = 0;
  bool isGood = true;
  List<String> cateList = []; // chứa string ID của các post category
  PostData({
    String? id,
    String title = '',
    String description = '',
    List<String>? mediaUrls,
    String outstandingIMGURL = '',
    int price = 0,
    bool isGood = true,
    List<String>? cateList,
  }) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.mediaUrls = mediaUrls ?? [];
    this.outstandingIMGURL = outstandingIMGURL;
    this.price = price;
    this.isGood = isGood;
    this.cateList = cateList ?? [];
  }

  @override
  void loadMore() {
    // TODO: implement loadMore
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
  Filter({String? search_type, String? keyword, double? scoreThreshold}){
    this.search_type = search_type;
    this.keyword = keyword;
    this.scoreThreshold = scoreThreshold;
  }

}
