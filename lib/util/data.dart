import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';
import 'package:string_similarity/string_similarity.dart';
import 'entities.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// định nghĩa các API sử dụng

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

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

CollectionReference<CommentData> commentsRef = FirebaseFirestore.instance
    .collection('comments')
    .withConverter<CommentData>(
        fromFirestore: (snapshot, _) {
          var data = snapshot.data()!;
          data["commentID"] = snapshot.id;
          print("data is");
          print(data);
          return CommentData.fromJson(data);
        },
        toFirestore: (commentData, _) => commentData.toJson());

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

CollectionReference<RecentUserSearchData> recentUsersRef(String profileId) {
  return FirebaseFirestore.instance
      .collection('reccentUserSearch')
      .doc(profileId)
      .collection("recentList")
      .withConverter(
      fromFirestore: (snapshot, _) {
        var data = snapshot.data()!;
        data["id"] = snapshot.id;
        return RecentUserSearchData.fromJson(data);
      },
      toFirestore: (recentUserData, _) => recentUserData.toJson());
}

CollectionReference<ProfileData> profilesRef = FirebaseFirestore.instance
    .collection('profiles')
    .withConverter<ProfileData>(
      fromFirestore: (snapshot, _) {
        var data = snapshot.data()!;
        data["id"] = snapshot.id;
        return ProfileData.fromJson(data);
      },
      toFirestore: (profileData, _) => profileData.toJson(),
    );

CollectionReference<ReactionData> flattenReactionRef =
FirebaseFirestore.instance.collection("flatten-reactions").withConverter(
    fromFirestore: ReactionData.fromJson,
    toFirestore: (reactionData, _) => reactionData.toJson());

CollectionReference<RecentUserSearchData> recentUserRef =
FirebaseFirestore.instance.collection('reccentUserSearch').withConverter<RecentUserSearchData>(
    fromFirestore: (snapshot, _) {
      var data = snapshot.data()!;
      data["id"] = snapshot.id;
      return RecentUserSearchData.fromJson(data);
    },
    toFirestore: (recentUser, _) => recentUser.toJson());


Future<PostData?> getPost(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  // TODO: implement get_post
  return postsRef.doc(id).get().then((snapshot) => snapshot.data()!);
}

Stream<PostData> pseudoFullTextSearchPost(String key) async* {
  /// hàm này KHÔNG xử lý tối ưu bởi tìm kiếm được xử lý trên máy client, và hàm này phục vụ cho sử dụng tính năng.
  /// các công cụ tìm kiếm fulltext bên thứ 3 là KHẢ DỤNG trên nền tảng firebase dưới dạng các extension, tuy nhiên đều yêu cầu trả phí
  var foodSnapshot = await postsRef.get();
  List<Tuple2> scores = [];
  for (var doc in foodSnapshot.docs) {
    var post = doc.data();
    String txt = post.title + post.description;
    var similarity = key.toLowerCase().similarityTo(txt.toLowerCase());
    scores.add(Tuple2(similarity, post));
  }
  scores.sort((Tuple2 a, Tuple2 b) {
    return a.item1.compareTo(b.item1) * -1;
  });
  for (var tuple in scores) {
    yield tuple.item2 as PostData;
  }
}

String standard(String s) {
  for (int i = 0; i < s.length; i++) {
    if (s[i] == 'á' || s[i] == 'à' || s[i] == 'ả' || s[i] == 'ạ') {
      s = s.replaceRange(i, i+1, 'a');
    }
    if (s[i] == 'ă' || s[i] == 'ằ' || s[i] == 'ẳ' || s[i] == 'ặ' || s[i] == 'ắ') {
      s = s.replaceRange(i, i+1, 'a');
    }
    if (s[i] == 'â' || s[i] == 'ầ' || s[i] == 'ẩ' || s[i] == 'ậ' || s[i] == 'ấ') {
      s = s.replaceRange(i, i+1, 'a');
    }
    if (s[i] == 'đ') {
      s = s.replaceRange(i, i+1, 'd');
    }
    if (s[i] == 'ê' || s[i] == 'ề' || s[i] == 'ể' || s[i] == 'ệ' || s[i] == 'ế') {
      s = s.replaceRange(i, i+1, 'e');
    }
    if (s[i] == 'í' || s[i] == 'ì' || s[i] == 'ỉ' || s[i] == 'ị') {
      s = s.replaceRange(i, i+1, 'i');
    }
    if (s[i] == 'ó' || s[i] == 'ò' || s[i] == 'ỏ' || s[i] == 'ọ') {
      s = s.replaceRange(i, i+1, 'o');
    }
    if (s[i] == 'ô' || s[i] == 'ồ' || s[i] == 'ổ' || s[i] == 'ộ' || s[i] == 'ố') {
      s = s.replaceRange(i, i+1, 'o');
    }
    if (s[i] == 'ơ' || s[i] == 'ờ' || s[i] == 'ở' || s[i] == 'ợ' || s[i] == 'ớ') {
      s = s.replaceRange(i, i+1, 'o');
    }
    if (s[i] == 'ú' || s[i] == 'ù' || s[i] == 'ủ' || s[i] == 'ụ') {
      s = s.replaceRange(i, i+1, 'u');
    }
    if (s[i] == 'ứ' || s[i] == 'ừ' || s[i] == 'ử' || s[i] == 'ự' || s[i] == 'ư') {
      s = s.replaceRange(i, i+1, 'u');
    }
  }
  return s;
}

Stream<ProfileData> pseudoSearchUser(String key) async* {
  /// hàm này KHÔNG xử lý tối ưu bởi tìm kiếm được xử lý trên máy client, và hàm này phục vụ cho sử dụng tính năng.
  /// các công cụ tìm kiếm fulltext bên thứ 3 là KHẢ DỤNG trên nền tảng firebase dưới dạng các extension, tuy nhiên đều yêu cầu trả phí
  print(standard("lương"));
  var profileSnapshot = await profilesRef.get();
  List<ProfileData> profiles = [];
  for (var doc in profileSnapshot.docs) {
    var profile = doc.data();
    String txt = standard(profile.name.toLowerCase());
    if (txt.contains(standard(key.toLowerCase()))) {
      profiles.add(profile);
    }
  }

  for (var profile in profiles) {
    yield profile;
  }
}

Stream<PostData> getPosts(Filter filter) async* {
  /// lấy 1 danh sách post theo điều kiệu lọc
  /// trả về dạng stream
  switch (filter.search_type) {
    case null:
    case "category":
      var categorySnapshot = await categoriesRef.orderBy("title").get();
      for (var doc in categorySnapshot.docs) {
        yield doc.data();
      }
      break;
    case "my_food":
      var foodSnapshot = await postsRef
          .where('author_uid', isEqualTo: getMyProfileId())
          .limit(10)
          .get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
      break;
    case "base_on_locations":
      var begin = GeoHash.fromDecimalDegrees(
              filter.visibleRegion![2], filter.visibleRegion![0]),
          end = GeoHash.fromDecimalDegrees(
              filter.visibleRegion![3], filter.visibleRegion![1]);
      var foodSnapshot = await postsRef
          .orderBy("position_hash")
          .startAt([begin.geohash])
          .endAt([end.geohash])
          .limit(10)
          .get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
      break;
    case 'popular_food':
      var foodSnapshot =
          await postsRef.orderBy('react', descending: true).limit(10).get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
      break;
    case 'recommend':
      //  get all not seen post
      var foodSnapshot =  await postsRef.get();
      for (var doc in foodSnapshot.docs) {
        var d = doc.data();
        if (await d.getReact()==0){
          yield d;
        }
      }
      break;
    case 'favorite':
    //  get all loved post
      var foodSnapshot =  await postsRef.get();
      for (var doc in foodSnapshot.docs) {
        var d = doc.data();
        if (await d.getReact()==1){
          yield d;
        }
      }
      break;
    case 'others':
      var foodSnapshot = await postsRef
          .where('author_uid', isEqualTo: filter.keyword)
          .limit(10)
          .get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
      break;
    default:
      var foodSnapshot = await postsRef.limit(10).get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
  }
}

Stream<CommentData> fetch_comments(String foodID) async* {
  var commentSnap = await commentsRef.where('postID', isEqualTo: foodID).get();
  List<CommentData> ls = commentSnap.docs.map((e) => e.data()).toList();
  ls.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  for (var doc in ls) {
    yield doc;
  }
}

String getMyProfileId() {
  return FirebaseAuth.instance.currentUser!.uid;
}

Future<ProfileData?> getProfile(String id) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  var a = (await profilesRef.doc(id).get()).data();
  print('get!' + id.toString());
  print(a);
  print('_______________');
  return a;
}

/*Future<RecentUserSearchData?> getRecentUser(String id) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  var a = (await recentUserRef.doc(id).get()).data();
  print('get!' + id.toString());
  print(a);
  print('_______________');
  return a;
}*/

Stream<RecentUserSearchData> getRecentUsers(String id) async* {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  var a = await recentUsersRef(id).orderBy("createAt", descending: true,).get();
  print('get!' + id.toString());
  print(a);
  print('_______________');
  for (var doc in a.docs) {
    yield doc.data();
  }
}

Future<bool> checkEqualRecentUsers(String id, RecentUserSearchData temp) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  try {
    var a = await recentUsersRef(id).get();
    print('get!' + id.toString());
    print(a);
    print('_______________');
    for (var doc in a.docs) {
      if (temp.profileId == doc.data().profileId) {
        bool success = await deleteRecentUsers(id, doc.data().id);
        if (!success) {
          return false;
        }
      }
    }
    return true;
  } catch (e) {
    print(e);
    return false;
  }

}

Future<bool> addRecentUsers(String id, RecentUserSearchData data) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  try {
    print(data);
    await recentUsersRef(id).add(data).then((documentSnapshot) =>
      recentUsersRef(id).doc(documentSnapshot.id).update({"id": documentSnapshot.id}));
    return true;
  } catch (e) {
    print("Cannot add doc");
    return false;
  }
}

Future<bool> deleteRecentUsers(String id, String deleteId) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  try {
    await recentUsersRef(id).doc(deleteId).delete();
    return true;
  } catch (e) {
    print("Cannot delete doc");
    return false;
  }
}

Future<bool> deleteAllRecentUsers(String id) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  try {
    var a = await recentUsersRef(id).get();
    for (var doc in a.docs) {
      recentUsersRef(id).doc(doc.id).delete();
    }
    return true;
  } catch (e) {
    print("Cannot delete doc");
    return false;
  }
}

Stream<ProfileData> getProfiles() async* {
  /// lấy 1 danh sách user theo điều kiệu lọc
  /// trả về dạng stream
  // TODO: implement get_users
  var profileSnapshot = await profilesRef.get();
  for (var doc in profileSnapshot.docs) {
    yield doc.data();
  }
}

Future<void> createNewProfile(ProfileData profile) {
  return profilesRef.doc(profile.id).set(profile);
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

Future<String> checkFriend(String myId, String otherId) async {
  final friendCollectionRef = friendsRef(myId);
  final friendDocumentRef = await
  friendCollectionRef.where("id", isEqualTo: otherId).get();
  for (var doc in friendDocumentRef.docs) {
    return doc.data().type;
  }
  return "none";
}

Future<bool> addFriendRequest(ProfileData profile) async{
  try {
    final friendCollectionRef = friendsRef(getMyProfileId());
    FriendData friendData = FriendData(id: profile.id!, name: profile.name, time: DateTime.now(),
        userAsset: profile.userAsset, type: "requests", mutualism: 0);
    ProfileData? myProfile = await getProfile(getMyProfileId());
    FriendData friendData1 = FriendData(id: myProfile!.id!, name: myProfile.name, time: DateTime.now(),
        userAsset: myProfile.userAsset, type: "invitations", mutualism: 0);
    await friendCollectionRef.doc(profile.id!).set(friendData);
    await friendsRef(profile.id!).doc(getMyProfileId()).set(friendData1);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> acceptFriendRequest(String profileId) async{
  try {
    final friendCollectionRef1 = friendsRef(profileId);
    final friendCollectionRef2 = friendsRef(getMyProfileId());
    await friendCollectionRef1.doc(getMyProfileId()).update({"type": "friends"});
    await friendCollectionRef2.doc(profileId).update({"type": "friends"});
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> cancelFriend(String profileId) async{
  try {
    final friendCollectionRef1 = friendsRef(profileId);
    final friendCollectionRef2 = friendsRef(getMyProfileId());
    await friendCollectionRef1.doc(getMyProfileId()).delete();
    await friendCollectionRef2.doc(profileId).delete();
    return true;
  } catch (e) {
    return false;
  }
}

Stream<FriendData> getFriends(Filter filter, String? profileId) async* {
  if (profileId == null) throw Exception("Require login");
  final friendCollectionRef = friendsRef(profileId);
  if (filter.search_type! == "friend_invitations") {
    final invitationDocumentRef = friendCollectionRef
        .where("type", isEqualTo: "invitations")
        .orderBy("time");
    final invitationDocument = await invitationDocumentRef.get();
    for (var doc in invitationDocument.docs) {
      yield doc.data();
    }
  } else if (filter.search_type! == "friend_list") {
    final friendCollectionRef = friendsRef(profileId);
    final friendDocumentRef =
        friendCollectionRef.where("type", isEqualTo: "friends").orderBy("time");
    final friendDocument = await friendDocumentRef.get();
    for (var doc in friendDocument.docs) {
      yield doc.data();
    }
  } else if (filter.search_type! == "friend_suggestions") {
    yield FriendData(
        id: '1',
        time: DateTime.now(),
        name: "Luong Dat",
        type: "friends",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 8);
    yield FriendData(
        id: '2',
        time: DateTime.now(),
        name: "Minh Quang",
        type: "friends",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 8);
    yield FriendData(
        id: '3',
        time: DateTime.now(),
        name: "Dao Tuan",
        type: "friends",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '4',
        time: DateTime.now(),
        name: "Pham Trong",
        type: "friends",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '5',
        time: DateTime.now(),
        name: "Luong Dat",
        type: "friends",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '6',
        time: DateTime.now(),
        name: "Minh Quang",
        type: "friends",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '7',
        time: DateTime.now(),
        name: "Dao Tuan",
        type: "friends",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '8',
        time: DateTime.now(),
        name: "Pham Trong",
        type: "friends",
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

final db = FirebaseFirestore.instance;

Stream<QuerySnapshot> getMessages(String id) {
  /// lấy danh sách message với 1 user sắp xếp theo createdAt
  /// trả về Stream
  final String myProfileId = getMyProfileId();

  final messageDoc = db.collection("messages").where("senderId",
      whereIn: [myProfileId, id]).orderBy("createdAt", descending: true);
  return messageDoc.snapshots();
}

Stream<QuerySnapshot> getRecentChat() {
  /// lấy danh sách chat gần đây
  final String myProfileId = getMyProfileId();
  return db
      .collection("recent-users")
      .doc(myProfileId)
      .collection("recent-chats")
      .orderBy("createdAt", descending: true)
      .snapshots();
}

Future editRecentChat(String profileId, String userId, Message message) async {
  var refRecentChat1 =
      db.collection("recent-users").doc(profileId).collection("recent-chats");
  var refRecentChat2 =
      db.collection("recent-users").doc(userId).collection("recent-chats");

  String newMessage =
      message.message.length < 10 ? message.message : message.message;

  try {
    await refRecentChat1.doc(userId).set({
      "senderId": userId,
      "receiverId": profileId,
      "message": newMessage,
      "unread": false,
      "createdAt": message.createdAt
    });
    await refRecentChat2.doc(profileId).set({
      "senderId": profileId,
      "receiverId": userId,
      "message": newMessage,
      "unread": true,
      "createdAt": message.createdAt
    });
    print("edited recent chat");
  } on FirebaseAuthException catch (e) {
    print(e.message.toString());
    return;
  }
}

Future seenChat(String profileId, String userId) async {
  var refRecentChat =
      db.collection("recent-users").doc(profileId).collection("recent-chats");

  try {
    await refRecentChat.doc(userId).update({"unread": false});
    print("Seen chat");
  } on FirebaseAuthException catch (e) {
    print(e.message.toString());
    return;
  }
}

Future sendMessage(String senderId, String receiverId, String message) async {
  final newMessage = Message(
      senderId: senderId,
      receiverId: receiverId,
      message: message.trim(),
      unread: true,
      createdAt: DateTime.now());

  try {
    late CollectionReference refMessage = db.collection("messages");
    var res = await refMessage.add(newMessage.toJson());

    await editRecentChat(senderId, receiverId, newMessage);
    print(res);
    return {"status": true, "message": "success"};
  } on FirebaseAuthException catch (e) {
    return {"status": false, "message": e.message.toString()};
  }
}
