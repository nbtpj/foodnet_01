import 'package:tuple/tuple.dart';
import 'entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<PostData?> get_post(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  // TODO: implement get_post
  return null;
}

Stream<CommentData> fetch_comments(String post_id, int limit) async* {
  for (var i = 0; i < limit+1; i++) {
    yield CommentData(timestamp: DateTime.now());
  }
}

Future<FriendData?> get_friend(String id) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  return null;
}

Future<UserData?> get_user(String id) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  return null;
}

Iterable<UserData> get_users(Filter filter) sync* {
  /// lấy 1 danh sách user theo điều kiệu lọc
  /// trả về dạng stream
  // TODO: implement get_users
  yield UserData();
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

Stream<SearchData> getSearchData(Filter filter) async* {
  if (filter.search_type == "recentUser") {
    yield SearchData(
        id: "1", name: "Luong Dat", asset: "assets/friend/tarek.jpg");
    yield SearchData(
      id: "2",
      name: "Minh Quang",
      //asset: "assets/friend/tarek.jpg"
    );
    yield SearchData(
        id: "3", name: "Pham Trong", asset: "assets/friend/tarek.jpg");
    yield SearchData(
        id: "4", name: "Dao Tuan", asset: "assets/friend/tarek.jpg");
    yield SearchData(
        id: "5", name: "Luong Dat", asset: "assets/friend/tarek.jpg");
    yield SearchData(
        id: "6", name: "Minh Quang", asset: "assets/friend/tarek.jpg");
    yield SearchData(
        id: "7", name: "Pham Trong", asset: "assets/friend/tarek.jpg");
    yield SearchData(
        id: "8", name: "Dao Tuan", asset: "assets/friend/tarek.jpg");
  }
  if (filter.search_type == "user" && filter.keyword == "a") {
    yield SearchData(
        id: "1", name: "Luong Dat", asset: "assets/friend/tarek.jpg");
    yield SearchData(
        id: "2", name: "Minh Quang", asset: "assets/friend/tarek.jpg");
    yield SearchData(
        id: "3", name: "Pham Trong", asset: "assets/friend/tarek.jpg");
    yield SearchData(
        id: "4", name: "Dao Tuan", asset: "assets/friend/tarek.jpg");
  }
}

Future<ProfileData>? getProfile(String id) async {
  /// hàm lấy một đối tượng Profile Data dựa trên id
  if (id == "1") {
    return ProfileData(
        id: "1",
        name: "Lương Đạt",
        userAsset: "assets/profile/dhia.jpg",
        wallAsset: "assets/profile/first.png",
        friendsNumber: 777,
        works: [
          "Người Việt Trẻ 06/01 - CLB Sinh viên vận động hiến máu Trường ĐH Công nghệ"
        ],
        schools: [
          "Trường ĐH Công Nghệ - ĐHQGHN",
          "THPT Chuyên Đại học Sư Phạm"
        ],
        dayOfBirth: "11/10/2001",
        gender: "Nam",
        location: "Hà Nội",
        favorites: ["Bóng đá", "Tình nguyện"],
        friends: [
          FriendData(
            name: "Tarek Loukil",
            userAsset: "assets/profile/tarek.jpg",
          ),
          FriendData(
            name: "Ghassen Boughzala",
            userAsset: "assets/profile/ghassen.jpg",
          ),
          FriendData(
            name: "Hassen Chouaddah",
            userAsset: "assets/profile/hassen.jpg",
          ),
          FriendData(
            name: "Aziz Ammar",
            userAsset: "assets/profile/aziz.jpg",
          ),
        ]);
  } else {
    return ProfileData(
        id: "2",
        name: "Minh Quang",
        userAsset: "assets/profile/dhia.jpg",
        wallAsset: "assets/profile/first.png",
        mutualism: 25,
        location: "Hải Dương",
        gender: "Nam",
        schools: [
          "Khoa Công nghệ Thông tin - Trường ĐH Công Nghệ - VNU",
          "THPT Thanh Hà, Thanh Hà, Hải Dương"
        ]);
  }
}

Stream<Tuple2<double, Object>?> search(Filter filter) async* {
  /// hàm tìm kiếm một tập các Object theo filter và trả về 1 stream các object tìm kiếm được
  /// cùng với một số double thể hiện độ 'matching' với filter
  // TODO: implement search
  yield null;
}

String file_type(String url) {
  var fileName = (url.split('/').last);
  return fileName.split('.').last.toLowerCase();
}
