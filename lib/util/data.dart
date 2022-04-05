import 'package:flutter/foundation.dart';

/////////////// define entities
class LazyLoadData {
  void loadMore() async {}
}

class PostData implements LazyLoadData {
  PostData(Object? any) {}

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class UserData implements LazyLoadData {
  UserData(Object? any) {}

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class GoodData implements PostData {
  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class Filter {}

////////////// define api
Future<List<Object>?> search(Filter filter) async {
  // TODO: implement search
  return null;
}
