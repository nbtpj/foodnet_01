import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import  'package:string_similarity/string_similarity.dart';
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
        print("get a profile");
        print(data);
        var a = ProfileData.fromJson(data);
        print(a.toJson());
        print('_______');

        return a;
      },
      toFirestore: (profileData, _) => profileData.toJson(),
    );

CollectionReference<ReactionPostData> postReactionRef =
    FirebaseFirestore.instance.collection("reactions-posts").withConverter(
        fromFirestore: ReactionPostData.fromJson,
        toFirestore: (reactionPostData, _) => reactionPostData.toJson());

DocumentReference<ReactionData> reactionRef(String postId, String userId) {
  return postReactionRef
      .doc(postId)
      .collection("reactions")
      .doc(userId)
      .withConverter(
          fromFirestore: ReactionData.fromJson,
          toFirestore: (reactionData, _) => reactionData.toJson());
}

Future<PostData?> getPost(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  // TODO: implement get_post
  return postsRef.doc(id).get().then((snapshot) => snapshot.data()!);
}
Stream<PostData> pseudoFullTextSearchPost(String key) async*{
  /// hàm này KHÔNG xử lý tối ưu bởi tìm kiếm được xử lý trên máy client, và hàm này phục vụ cho sử dụng tính năng.
  /// các công cụ tìm kiếm fulltext bên thứ 3 là KHẢ DỤNG trên nền tảng firebase dưới dạng các extension, tuy nhiên đều yêu cầu trả phí
  var foodSnapshot = await postsRef.get();
  List<Tuple2> scores = [];
  for (var doc in foodSnapshot.docs) {
    var post = doc.data();
    String txt = post.title+post.description;
    var similarity = key.toLowerCase().similarityTo(txt.toLowerCase());
    if(similarity>0.6) scores.add(Tuple2(similarity, post));

  }
  scores.sort((Tuple2 a, Tuple2 b) {
    return a.item1.compareTo(b.item1)*-1;
  });
  for(var tuple in scores){
    yield tuple.item2 as PostData;
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
      // todo
      print('hi query');
      print('position query is' +
          filter.visibleRegion.toString());
      var begin = GeoHash.fromDecimalDegrees(filter.visibleRegion![2],filter.visibleRegion![0]),
          end = GeoHash.fromDecimalDegrees(filter.visibleRegion![3],filter.visibleRegion![1]);
      var foodSnapshot = await postsRef.orderBy("position_hash")
          .startAt([begin.geohash])
          .endAt([end.geohash])
          .limit(10)
          .get();
      print('position query rs.len: ' +
          foodSnapshot.size.toString());
      for (var doc in foodSnapshot.docs) {
        debugPrint("get a location result");
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
    default:
      var foodSnapshot = await postsRef.limit(10).get();
      for (var doc in foodSnapshot.docs) {
        yield doc.data();
      }
  }
}

Stream<CommentData> fetch_comments(String foodID, int from, int to) async* {
  var commentSnap = await commentsRef.where('postID', isEqualTo: foodID).get();
  for (var doc in commentSnap.docs) {
    yield doc.data();
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

Future<ReactionPostData> getRateByPostId(String postId) {
  DocumentReference<ReactionPostData> docRef = postReactionRef.doc(postId);
  return docRef.get().then((snapshot) {
    if (snapshot.exists) {
      return snapshot.data()!;
    } else {
      return ReactionPostData();
    }
  });
}


Future<int> getMyReaction(String postId) {
  DocumentReference<ReactionData> myReactionRef =
      reactionRef(postId, getMyProfileId());
  return myReactionRef.get().then((snapshot) {
    if (!snapshot.exists) {
      return 0;
    } else {
      ReactionData data = snapshot.data()!;
      if (data.type == "upvote") {
        return 1;
      } else {
        return -1;
      }
    }
  });
}

Future<void> addReaction(String postId, ReactionData reactionData) {
  DocumentReference<ReactionData> reactRef =
      reactionRef(postId, reactionData.userId);
  return reactRef.set(reactionData);
}

Future<void> removeReaction(String postId, String userId) {
  DocumentReference<ReactionData> reactRef = reactionRef(postId, userId);
  return reactRef.delete();
}



final db = FirebaseFirestore.instance;

Stream<QuerySnapshot> getMessages(String id) {
  /// lấy danh sách message với 1 user sắp xếp theo createdAt
  /// trả về Stream
  final String myProfileId = getMyProfileId();

  final messageDoc = db
      .collection("messages")
      .where("senderId", whereIn: [myProfileId, id])
      .orderBy("createdAt", descending: true);
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
  var refRecentChat1 = db.collection("recent-users").doc(profileId).collection("recent-chats");
  var refRecentChat2 = db.collection("recent-users").doc(userId).collection("recent-chats");

  String newMessage = message.message.length < 10 ? message.message : message.message;

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
  var refRecentChat = db.collection("recent-users").doc(profileId).collection("recent-chats");

  try {
    await refRecentChat.doc(userId).update({
      "unread": false
    });
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
