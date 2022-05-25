import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

Stream<PostData> getPosts(Filter filter) async* {
  /// lấy 1 danh sách post theo điều kiệu lọc
  /// trả về dạng stream
  // TODO: implement get_posts: có thể trả về với :
  //  Filter(search_type: 'popular_food')
  //  Filter(search_type: 'my_food')
  //  Filter(search_type: 'recommend_food')
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

void addReaction(String postId, ReactionData reactionData) {
  DocumentReference<ReactionData> reactRef =
      reactionRef(postId, reactionData.userId);
  reactRef.set(reactionData);
}

void removeReaction(String postId, String userId) {
  DocumentReference<ReactionData> reactRef = reactionRef(postId, userId);
  reactRef.delete();
}

final db = FirebaseFirestore.instance;

Stream<Message> getMessages(String id) async* {
  /// lấy danh sách message với 1 user sắp xếp theo createdAt
  /// trả về Stream
  final String? myProfileId = getMyProfileId();

  try {
    final messageDoc = await db
        .collection("messages")
        // .where("senderId", whereIn: [myProfileId, id])
        // .where("receiverId", whereIn: [myProfileId, id])
        .orderBy("createdAt", descending: true)
        .get();
    for (var doc in messageDoc.docs) {
      yield Message.fromJson(doc.data());
    }
  } on Exception catch (e) {
    print(e.toString());
    return;
  }
}

Stream<Message> getRecentChat() async* {
  /// lấy danh sách chat gần đây
  yield Message(
      senderId: "5LbuzmwRYkbp6DvhFGC2KXyg8h33",
      receiverId: "jAvU41YlRGQoVwygSGMdrubKC5m2",
      message: "Hello my friend",
      unread: true,
      createdAt: DateTime.now());

  final String? myProfileId = getMyProfileId();

  try {
    final messageDoc = await db
        .collection("messages")
        // .where("senderId", whereIn: [myProfileId, id])
        // .where("receiverId", whereIn: [myProfileId, id])
        .orderBy("createdAt", descending: true)
        .get();
    for (var doc in messageDoc.docs) {
      yield Message.fromJson(doc.data());
    }
  } on Exception catch (e) {
    print(e.toString());
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
    print(res);
    return {"status": true, "message": "success"};
  } on FirebaseAuthException catch (e) {
    return {"status": false, "message": e.message.toString()};
  }
}
