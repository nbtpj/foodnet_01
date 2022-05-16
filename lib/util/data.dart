import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

CollectionReference<FriendData> friendsRef(String profileId) {
  return FirebaseFirestore.instance
      .collection('friends')
      .doc(profileId)
      .collection("profiles")
      .withConverter(
          fromFirestore: (snapshot, _) {
            var data = snapshot.data()!;
            data["id"] = snapshot.id;
            return FriendData.fromJson(data);
          },
          toFirestore: (friendData, _) => friendData.toJson());
}

CollectionReference<ProfileData> profilesRef = FirebaseFirestore.instance
    .collection('profiles')
    .withConverter<ProfileData>(
        fromFirestore: (snapshot, _) {
          var data = snapshot.data()!;
          data["id"] = snapshot.id;
          return ProfileData.fromJson(data);
        },
        toFirestore: (profileData, _) => profileData.toJson());

Future<PostData?> getPost(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  // TODO: implement get_post
  return postsRef.doc(id).get().then((snapshot) => snapshot.data()!);
}

Stream<PostData> getPosts(Filter filter) async* {
  /// lấy 1 danh sách post theo điều kiệu lọc
  /// trả về dạng stream
  // TODO: implement get_posts: có thể trả về với :
  //  Filter(search_type: 'popular_food')
  //  Filter(search_type: 'my_food')
  //  Filter(search_type: 'recommend_food')
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
Stream<CommentData> fetch_comments(String foodID, int from, int to) async*{
  /// todo: lấy các comment của postdata có foodID, từ khoảng from đến to (lưu ý là ngược lại thứ tự thời gian,
  /// có nghĩa là nếu from =0, thì comment tương ứng đó là comment cuối cùng theo thời gian)
  for (var i=from; i<to; i++){
    yield CommentData(timestamp: DateTime.now());
  }
}
String? getMyProfileId() {
  return FirebaseAuth.instance.currentUser?.uid;
}

Future<ProfileData> getProfile(String id) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  var res = profilesRef.doc(id).get().then((snapshot) {
    print(snapshot.data()!.toJson());
    return snapshot.data()!;
  });
  return res;
}

Stream<ProfileData> getProfiles(Filter filter) async* {
  /// lấy 1 danh sách user theo điều kiệu lọc
  /// trả về dạng stream
  // TODO: implement get_users
  var profileSnapshot = await profilesRef.get();
  for (var doc in profileSnapshot.docs) {
    yield doc.data();
  }
}

Stream<FriendData> getFriend(String? profileId) async* {
  if (profileId == null) throw Exception("Require login");
  final friendCollectionRef = friendsRef(profileId);
  final friendDocumentRef =
      friendCollectionRef.where("type", isEqualTo: "friends");
  final firstPage = friendDocumentRef.orderBy("time").limit(4);
  final friendDocument = await firstPage.get();
  for (var doc in friendDocument.docs) {
    yield doc.data();
  }
}

Stream<FriendData> getFriends(Filter filter, String? profileId) async* {
  if (profileId == null) throw Exception("Require login");
  final friendCollectionRef = friendsRef(profileId);
  if (filter.search_type! == "friend_invitations") {
    final invitationDocumentRef =
        friendCollectionRef
            .where("type", isEqualTo: "invitations")
            .orderBy("time");
    final invitationDocument = await invitationDocumentRef.get();
    for (var doc in invitationDocument.docs) {
      yield doc.data();
    }
  } else if (filter.search_type! == "friend_list") {
    final friendCollectionRef = friendsRef(profileId);
    final friendDocumentRef =
      friendCollectionRef
        .where("type", isEqualTo: "friends")
        .orderBy("time");
    final friendDocument = await friendDocumentRef.get();
    for (var doc in friendDocument.docs) {
      yield doc.data();
    }
  } else if (filter.search_type! == "friend_suggestions") {
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
