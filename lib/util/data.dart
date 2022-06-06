import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tuple/tuple.dart';

import 'entities.dart';

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

Future<PostData?> getPost(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  return postsRef.doc(id).get().then((snapshot) => snapshot.data()!);
}

Stream<PostData> pseudoFullTextSearchPost(String key, int? limit) async* {
  /// hàm này KHÔNG xử lý tối ưu bởi tìm kiếm được xử lý trên máy client, và hàm này phục vụ cho sử dụng tính năng.
  /// các công cụ tìm kiếm fulltext bên thứ 3 là KHẢ DỤNG trên nền tảng firebase dưới dạng các extension, tuy nhiên đều yêu cầu trả phí
  var foodSnapshot = await postsRef.limit(limit??100).get();
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

Stream<PostData> getPosts(Filter filter) async* {
  /// lấy 1 danh sách post theo điều kiệu lọc
  /// trả về dạng stream
  Query<PostData> querySnap;
  switch (filter.search_type) {
    case null:
    case "category":
      querySnap = categoriesRef.orderBy("title");
      break;

    case "my_food":
      querySnap = postsRef.where('author_uid', isEqualTo: getMyProfileId());
      break;
    case "base_on_locations":
      var begin = GeoHash.fromDecimalDegrees(
              filter.visibleRegion![2], filter.visibleRegion![0]),
          end = GeoHash.fromDecimalDegrees(
              filter.visibleRegion![3], filter.visibleRegion![1]);
      querySnap = postsRef
          .orderBy("position_hash")
          .startAt([begin.geohash]).endAt([end.geohash]);
      break;
    case 'popular_food':
      querySnap = postsRef.orderBy('react', descending: true);
      break;
    default:
      querySnap = postsRef;
  }
  if (filter.search_type == 'favorite'){
    var reactionSnap = await flattenReactionRef
        .where('userId', isEqualTo: getMyProfileId())
        .where('type', isEqualTo: 1)
        .get();
    for (var react in reactionSnap.docs) {
      var post = await getPost(react.data().postId);
      if (post != null) {
        yield post;
      }
    }
  } else {
    for (var doc in (await querySnap.limit(filter.limit ?? 100).get()).docs) {
      if (filter.search_type != 'recommend'||(filter.search_type == 'recommend'&& await doc.data().getReact() == 0)) {
        yield doc.data();
      }
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
  var a = (await profilesRef.doc(id).get()).data();
  return a;
}

Stream<ProfileData> getProfiles(Filter filter) async* {
  /// lấy 1 danh sách user theo điều kiệu lọc
  /// trả về dạng stream
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
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 8);
    yield FriendData(
        id: '2',
        time: DateTime.now(),
        name: "Minh Quang",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 8);
    yield FriendData(
        id: '3',
        time: DateTime.now(),
        name: "Dao Tuan",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '4',
        time: DateTime.now(),
        name: "Pham Trong",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '5',
        time: DateTime.now(),
        name: "Luong Dat",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '6',
        time: DateTime.now(),
        name: "Minh Quang",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '7',
        time: DateTime.now(),
        name: "Dao Tuan",
        userAsset: "assets/friend/tarek.jpg",
        mutualism: 10);
    yield FriendData(
        id: '8',
        time: DateTime.now(),
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

Stream<QuerySnapshot<ReactionData>> get_my_reaction_list() {
  return flattenReactionRef
      .where('userId', isEqualTo: getMyProfileId())
      .where('type', isEqualTo: 1)
      .snapshots();
}

Stream<PostData> detail_list_fetcher(String name) async* {
  switch (name) {
    case my_post_string:
      var foodSnapshot =
          await postsRef.where('author_uid', isEqualTo: getMyProfileId()).get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
      break;
    case my_favorite_string:
      var reactionSnap = await flattenReactionRef
          .where('userId', isEqualTo: getMyProfileId())
          .where('type', isEqualTo: 1)
          .get();
      for (var react in reactionSnap.docs) {
        var post = await getPost(react.data().postId);
        if (post != null) {
          yield post;
        }
      }
      break;

    case popular_string:
      var foodSnapshot =
          await postsRef.orderBy('react', descending: true).limit(10).get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
      break;
    default:
      var foodSnapshot = await postsRef.get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
  }
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
