import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

import 'entities.dart';

/// định nghĩa các API sử dụng
/// các hàm này nên hỗ trợ cache dữ liệu

CollectionReference<PostData> postsRef =
    FirebaseFirestore.instance.collection('posts').withConverter<PostData>(
        fromFirestore: (snapshot, _) {
          var data = snapshot.data()!;
          data["id"] = snapshot.id;
          return PostData.fromJson(data);
        },
        toFirestore: (postData, _) => postData.toJson());

CollectionReference<PostData> categoriesRef =
    FirebaseFirestore.instance.collection('categories').withConverter<PostData>(
        fromFirestore: (snapshot, _) {
          var data = snapshot.data()!;
          data["id"] = snapshot.id;
          return PostData.categoryFromJson(data);
        },
        toFirestore: (postData, _) => postData.categoryToJson());

Future<PostData?> getPost(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  // TODO: implement get_post
  return postsRef.doc(id).get().then((snapshot) => snapshot.data()!);
}

Stream<PostData> getPosts(Filter filter) async* {
  /// lấy 1 danh sách post theo điều kiệu lọc
  /// trả về dạng stream
  // TODO: implement get_posts
  if (filter.search_type! == "food") {
    var foodSnapshot = await postsRef.get();
    for (var doc in foodSnapshot.docs) {
      yield doc.data();
    }
  }
  if (filter.search_type! == "category") {
    var categorySnapshot = await categoriesRef.orderBy("title").get();
    for (var doc in categorySnapshot.docs) {
      yield doc.data();
    }
  }
}

Future<FriendData?> get_friend(String id) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  return null;
}

Stream<FriendData> get_friends(Filter filter) async* {
  /// lấy 1 danh sách user theo điều kiệu lọc
  /// trả về dạng stream
  // TODO: implement get_users
  if (filter.search_type! == "friend_invitations") {
    yield FriendData(
        id: '1',
        name: "Luong Dat",
        userAsset: "assets/friend/tarek.jpg",
        time: "31W");
    yield FriendData(
        id: '2',
        name: "Minh Quang",
        userAsset: "assets/friend/tarek.jpg",
        time: "31W");
    yield FriendData(
        id: '3',
        name: "Dao Tuan",
        userAsset: "assets/friend/tarek.jpg",
        time: "31W");
    yield FriendData(
        id: '4',
        name: "Pham Trong",
        userAsset: "assets/friend/tarek.jpg",
        time: "31W");
    yield FriendData(
        id: '5',
        name: "Luong Dat",
        userAsset: "assets/friend/tarek.jpg",
        time: "3M");
    yield FriendData(
        id: '6',
        name: "Minh Quang",
        userAsset: "assets/friend/tarek.jpg",
        time: "3M");
    yield FriendData(
        id: '7',
        name: "Dao Tuan",
        userAsset: "assets/friend/tarek.jpg",
        time: "3M");
    yield FriendData(
        id: '8',
        name: "Pham Trong",
        userAsset: "assets/friend/tarek.jpg",
        time: "3M");
    yield FriendData(
        id: '9',
        name: "Pham Trong",
        userAsset: "assets/friend/tarek.jpg",
        time: "3M");
  }

  if (filter.search_type! == "friend_list") {
    yield FriendData(
        id: '1',
        name: "Luong Dat",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '2',
        name: "Minh Quang",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '3',
        name: "Dao Tuan",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '4',
        name: "Pham Trong",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '5',
        name: "Luong Dat",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '6',
        name: "Minh Quang",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '7',
        name: "Dao Tuan",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '8',
        name: "Pham Trong",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
  }

  if (filter.search_type! == "friend_suggestions") {
    yield FriendData(
        id: '1',
        name: "Luong Dat",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 8);
    yield FriendData(
        id: '2',
        name: "Minh Quang",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 8);
    yield FriendData(
        id: '3',
        name: "Dao Tuan",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '4',
        name: "Pham Trong",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '5',
        name: "Luong Dat",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '6',
        name: "Minh Quang",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '7',
        name: "Dao Tuan",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '8',
        name: "Pham Trong",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
  }
}

Iterable<Tuple2<double, Object>?> search(Filter filter) sync* {
  /// hàm tìm kiếm một tập các Object theo filter và trả về 1 stream các object tìm kiếm được
  /// cùng với một số double thể hiện độ 'matching' với filter
  // TODO: implement search
  yield null;
}
