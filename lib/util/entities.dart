/// định nghĩa các đối tượng dữ liệu

class LazyLoadData {
  /// interface lazy load cho các đối tượng có quá nhiều dữ liệu
  /// ví dụ như: nếu đối tượng PostData chỉ cần hiển thị brief view thì không cần phải load toàn bộ các media.
  void loadMore() async {}
}

class PostData implements LazyLoadData {
  late String title, description;
  late List<String> mediaUrls;

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

class GoodData implements PostData {
  late String title, description;
  late List<String> mediaUrls;
  late int price;
  @override
  void loadMore() {
    // TODO: implement loadMore
  }

}

class Filter {
  /// lớp đại diện cho các điều kiện lọc cho tìm kiếm
}
