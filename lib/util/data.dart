import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:elastic_app_search/elastic_app_search.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:algolia/algolia.dart';


import 'entities.dart';

/// define data-related API used in UI code

/// define static FireStore Collection references
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
final db = FirebaseFirestore.instance;
final service = ElasticAppSearch(
  endPoint: "https://firestore-eas.ent.asia-east1.gcp.elastic-cloud.com",
  searchKey: "private-e9smabtgeiynh3vuyhavy5f1",
);

final CollectionReference<PostData> postsRef =
FirebaseFirestore.instance.collection('posts').withConverter<PostData>(
    fromFirestore: (snapshot, _) {
      var data = snapshot.data()!;
      data["id"] = snapshot.id;
      return PostData.fromJson(data);
    },
    toFirestore: (postData, _) => postData.toJson());

final CollectionReference<PostData> categoriesRef =
FirebaseFirestore.instance.collection('categories').withConverter<PostData>(
    fromFirestore: (snapshot, _) {
      var data = snapshot.data()!;
      data["id"] = snapshot.id;
      return PostData.categoryFromJson(data);
    },
    toFirestore: (postData, _) => postData.categoryToJson());

final CollectionReference<Relationship> relationshipsRef =
FirebaseFirestore.instance.collection('relationships').withConverter<Relationship>(
    fromFirestore: (snapshot, _) {
      var data = snapshot.data()!;
      data["id"] = snapshot.id;
      return Relationship.fromJson(data);
    },
    toFirestore: (relationData, _) => relationData.toJson());

final CollectionReference<CommentData> commentsRef = FirebaseFirestore.instance
    .collection('comments')
    .withConverter<CommentData>(
    fromFirestore: (snapshot, _) {
      var data = snapshot.data()!;
      data["commentID"] = snapshot.id;
      return CommentData.fromJson(data);
    },
    toFirestore: (commentData, _) => commentData.toJson());

final CollectionReference<ProfileData> profilesRef = FirebaseFirestore.instance
    .collection('profiles')
    .withConverter<ProfileData>(
  fromFirestore: (snapshot, _) {
    var data = snapshot.data()!;
    data["id"] = snapshot.id;
    return ProfileData.fromJson(data);
  },
  toFirestore: (profileData, _) => profileData.toJson(),
);

final CollectionReference<ReactionData> flattenReactionRef =
FirebaseFirestore.instance.collection("flatten-reactions").withConverter(
    fromFirestore: ReactionData.fromJson,
    toFirestore: (reactionData, _) => reactionData.toJson());

final CollectionReference<RecentUserSearchData> recentUserRef =
FirebaseFirestore.instance.collection('reccentUserSearch').withConverter<RecentUserSearchData>(
    fromFirestore: (snapshot, _) {
      var data = snapshot.data()!;
      data["id"] = snapshot.id;
      return RecentUserSearchData.fromJson(data);
    },
    toFirestore: (recentUser, _) => recentUser.toJson());

/// define dynamic FireStore Collection references
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

/// get current user ID
String getMyProfileId() {
  return FirebaseAuth.instance.currentUser!.uid;
}
/// get file extension's type
String file_type(String url) {
  var fileName = (url.split('/').last);
  return fileName.split('.').last.toLowerCase();
}

///_______________________searching_______________________
/// define searching functions. Note: current FireStore DO NOT support fulltext search, but via a third party with payment!
/// to deal with this problem, we define a "pseudo text search" strategy, which first fetch a limited possible
/// result the sort them by weighted query-matching score (with post searching), and substring matching (with user searching).

String normalize(String s) {
  /// normalize a string for text-matching
  s = s.toLowerCase();
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

Future<List<SearchPostData>> searchPost(String key) async{
  ElasticResponse response = await service
      .engine("firestore-post")
      .query(key)
      .get();
  if (response.results.isNotEmpty) {
    return List<SearchPostData>.from(
        response.results.map((result) => SearchPostData.fromData(result.data))
    );
  } else {
    return [];
  }
}

Future<List<SearchProfileData>> searchUser(String key) async{
  ElasticResponse response = await service
      .engine("firestore-profile")
      .query(key)
      .get();
  if (response.results.isNotEmpty) {
    return List<SearchProfileData>.from(
        response.results.map((result) => SearchProfileData.fromData(result.data))
    );
  } else {
    return [];
  }
}

Stream<ProfileData> pseudoSearchFriend(String id, String key) async* {
  /// todo: đấy lên cloud
  final friendDocument = await (Relationship.friendProfile(getMyProfileId()).toList());
  for (var doc in friendDocument) {
    String txt = normalize(doc.name.toLowerCase());
    if (txt.contains(normalize(key.toLowerCase()))) {
      yield doc;
    }
  }
}

///_______________________data operation_______________________
/// define data operation functions

Future<String> checkFriend(String myId, String otherId) async {
  var id = Relationship.createId([myId, otherId]);
  var doc = await relationshipsRef.doc(id).get();
  if (doc.exists){
    var rel = doc.data()!;
    if (rel.type =='invitation'){
      if (rel.sender_id == getMyProfileId()){
        return 'request';
      } else {
        return 'invitation';
      }
    }
    return doc.data()!.type;
  }
  return "none";
}

Future<bool> addFriendRequest(String profileId) async{
  return await Relationship.sendInvitation(profileId);
}

Future<bool> acceptFriendRequest(String profileId) async{
  return await Relationship.acceptInvitation(profileId);
}

Future<bool> cancelFriend(String profileId) async{
  try {
    var ids = [getMyProfileId(), profileId];
    ids.sort((a,b)=>a.compareTo(b));
    var id = ids.join('_');
    await relationshipsRef.doc(id).delete();
  } catch (e) {
    return false;
  }

  return true;
}


Stream<RecentUserSearchData> getRecentUsers(String id) async* {
  /// hàm lấy một đối tượng UserData dựa trên id
  var a = await recentUsersRef(id).orderBy("createAt", descending: true,).get();
  for (var doc in a.docs) {
    yield doc.data();
  }
}

Future<bool> checkEqualRecentUsers(String id, RecentUserSearchData temp) async {
  try {
    var a = await recentUsersRef(id).get();
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
  try {
    await recentUsersRef(id).doc(deleteId).delete();
    return true;
  } catch (e) {
    print("Cannot delete doc");
    return false;
  }
}

Future<bool> deleteAllRecentUsers(String id) async {
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
    return {"status": true, "message": "success"};
  } on FirebaseAuthException catch (e) {
    return {"status": false, "message": e.message.toString()};
  }
}

Future<PostData> getPost(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  return postsRef.doc(id).get().then((snapshot) => snapshot.data()!);
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
      if (filter.author_id!=null){
        querySnap = postsRef.where('author_uid', isEqualTo: filter.author_id!);
      }
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

Future<int> getNumCite(String title) {
  return FirebaseFunctions
      .instanceFor(region: "asia-east1")
      .httpsCallable("numCite")
      .call({"title" : title})
      .then((res) => res.data["total"] as int);
}

Future<int> getUpvote(String postId) {
  return FirebaseFunctions
      .instanceFor(region: "asia-east1")
      .httpsCallable("getUpvote")
      .call({"postId": postId})
      .then((res) => res.data["total"] as int);
}

Future<int> getDownvote(String postId) {
  return FirebaseFunctions
      .instanceFor(region: "asia-east1")
      .httpsCallable("getDownvote")
      .call({"postId": postId})
      .then((res) => res.data["total"] as int);
}

Future<Map<String, dynamic>> calculateMutualism(List<String> profileIdList) {
  return FirebaseFunctions
      .instanceFor(region: "asia-east1")
      .httpsCallable("calcMutualism")
      .call({"idList": profileIdList})
      .then((res) {
        print(res.data.toString());
        return res.data as Map<String, dynamic>;
      });
}