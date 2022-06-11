import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/global.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tuple/tuple.dart';

/// define data entity (persistent mechanism)

class LazyLoadData {
  /// interface lazy load cho các đối tượng có quá nhiều dữ liệu
  void loadMore() async {}
}

class CommentData {
  late String commentID;
  late String comment;
  late String userID;
  late String postID;
  late DateTime timestamp;
  late List<String> mediaUrls;
  late int react;
  ProfileData? profile;

  CommentData({
    required this.commentID,
    required this.postID,
    required this.userID,
    this.comment = "",
    this.mediaUrls = const [],
    required this.timestamp,
    this.react = 0,
  });

  CommentData.fromJson(Map<String, dynamic> json)
      : commentID = json['commentID'] as String,
        comment = json['comment'] as String,
        mediaUrls =
            (json['mediaUrls'] as List).map((e) => e as String).toList(),
        timestamp = (json['timestamp'] as Timestamp).toDate(),
        react = json['react'] as int,
        postID = json['postID'] as String,
        userID = json['userID'] as String;

  Map<String, dynamic> toJson() => {
        'comment': comment,
        'mediaUrls': mediaUrls,
        'timestamp': Timestamp.fromDate(timestamp),
        'react': react,
        'userID': userID,
        'postID': postID,
      };

  Future<ProfileData?> load_profile() async {
    profile = await getProfile(userID);
    return profile;
  }

  Future<bool> post() async {
    for (int i = 0; i < mediaUrls.length; i++) {
      if (await File(mediaUrls[i]).exists()) {
        try {
          File f = await File(mediaUrls[i]).create();
          mediaUrls[i] = "$userID-cmton-$postID-${DateTime.now().toUtc()}";
          await storage.ref('comments').child(mediaUrls[i]).putFile(f);
          mediaUrls[i] = await storage
              .ref('comments')
              .child(mediaUrls[i])
              .getDownloadURL();
        } catch (e) {
          debugPrint("error: can not upload: " + mediaUrls[i] + e.toString());
          return false;
        }
      }
    }

    if (getMyProfileId() != null) {
      userID = getMyProfileId();
      if (commentID == "new") {
        DocumentReference doc = await commentsRef.add(this);
        commentID = doc.id;
        return true;
      } else {
        try {
          await commentsRef.doc(commentID).set(this);
        } catch (e) {
          return false;
        }
        return true;
      }
    } else {
      return false;
    }
  }

  bool isEmpty() {
    bool a = comment.isEmpty && mediaUrls.isEmpty;
    return a;
  }

  Future<bool> delete() async {
    try {
      await commentsRef.doc(commentID).delete();
    } catch (e) {
      return false;
    }
    return true;
  }
}

class PostData implements LazyLoadData {
  String id;
  String? author_id;
  late String title;
  late String description;
  late List<String> mediaUrls;
  late String outstandingIMGURL;
  int? price;
  late List<List<String>> features;
  late bool isGood;
  LatLng? position;
  DateTime datetime = DateTime.now();
  late int react;
  late List<String> cateList; // chứa string ID của các post category
  int numUpvote;
  int numDownvote;

  PostData(
      {this.author_id,
      this.id = "new",
      this.title = "",
      this.description = "Lorem ipsum dolor sit amet, consectetur adipiscing"
          "Lorem ipsum dolor sit amet, consectetur adipiscing"
          "Lorem ipsum dolor sit amet, consectetur adipiscing"
          "Lorem ipsum dolor sit amet, consectetur adipiscing"
          "Lorem ipsum dolor sit amet, consectetur adipiscing"
          "Lorem ipsum dolor sit amet, consectetur adipiscing"
          "Lorem ipsum dolor sit amet, consectetur adipiscing"
          "Lorem ipsum dolor sit amet, consectetur adipiscing",
      this.mediaUrls = const [
        "assets/food/HeavenlyPizza.jpg",
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
      ],
      this.outstandingIMGURL = '',
      this.price,
      this.isGood = true,
      this.react = 0,
      this.cateList = const [],
      this.features = const [
        ["200+", "Calories"],
        ["%10", "Fat"],
        ["%40", "Proteins"],
        ["200+", "Calories"]
      ],
      this.position,
      this.numUpvote = 0,
      this.numDownvote = 0});

  int i = 0;

  Future<int> get numcite async {
    // todo: Kì vọng đẩy lên cloud function
    return (await postsRef.where('cateList', arrayContains: title).get()).size;
  }

  LatLng positions() {
    return position ?? LatLng(0, 0);
  }

  bool isEditable() {
    return author_id == getMyProfileId();
  }

  @override
  void loadMore() {}

  List<List<String>> getFeatures() {
    return features;
  }

  Future<String?> getLocationName() async {
    if (position == null) {
      return None;
    }
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark place = placemarks[0];
    List<String?> add_names = [
      place.name,
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
      place.postalCode,
      place.country
    ];
    add_names.removeWhere((item) => ["", null, false, 0].contains(item));
    String final_add = add_names.join(", ");
    return final_add;
  }

  Future<int> getReact() async {
    var snap = await flattenReactionRef.doc('$id-${getMyProfileId()}').get();
    if (snap.exists) {
      react = snap.data()!.type;
    } else {
      react = 0;
    }
    return react;
  }

  void changeReact() {
    react += 1;
    if (react > 1) {
      react = -1;
    }

    switch (react) {
      case 0:
        numDownvote -= 1;
        break;
      case 1:
        numUpvote += 1;
        break;
      case -1:
        numUpvote -= 1;
        numDownvote += 1;
        break;
      default:
        return;
    }
  }

  Future<void> commitReaction() {
    switch (react) {
      case 0:
        return flattenReactionRef.doc('$id-${getMyProfileId()}').delete();

      default:
        return flattenReactionRef.doc('$id-${getMyProfileId()}').set(
            ReactionData(
                userId: getMyProfileId(),
                postId: id,
                type: react,
                time: DateTime.now()));
    }
  }

  Future<dynamic> getRate() async {
    // todo: Kì vọng đẩy lên cloud function
    numUpvote = (await flattenReactionRef
            .where("postId", isEqualTo: id)
            .where('type', isEqualTo: 1)
            .get())
        .size;
    numDownvote = (await flattenReactionRef
            .where("postId", isEqualTo: id)
            .where('type', isEqualTo: -1)
            .get())
        .size;
    return {
      "numUpvote": numUpvote,
      "numDownvote": numDownvote,
    };
  }

  PostData.fromJson(Map<String, Object?> json)
      : this(
            author_id: json['author_uid']! as String,
            id: json['id']! as String,
            description: json['description']! as String,
            mediaUrls:
                (json['mediaUrls'] as List).map((e) => e as String).toList(),
            cateList:
                (json['cateList'] as List).map((e) => e as String).toList(),
            price: json['price']! as int,
            isGood: json['isGood']! as bool,
            react: json['react']! as int,
            outstandingIMGURL: json['outstandingIMGURL']! as String,
            title: json['title']! as String,
            position: json['position'] != null
                ? LatLng((json['position']! as GeoPoint).latitude,
                    (json['position']! as GeoPoint).longitude)
                : null);

  PostData.categoryFromJson(Map<String, Object?> json)
      : this(
            id: json['id']! as String,
            title: json['title']! as String,
            outstandingIMGURL: json['outstandingIMGURL']! as String);

  Map<String, Object?> toJson() {
    return {
      "description": description,
      "cateList": cateList,
      "price": price,
      "isGood": isGood,
      "react": react,
      "author_uid": author_id,
      "title": title,
      "mediaUrls": mediaUrls,
      "position": position != null
          ? GeoPoint(position!.latitude, position!.longitude)
          : null,
      "outstandingIMGURL": outstandingIMGURL,
      "position_hash": position != null
          ? GeoHash.fromDecimalDegrees(position!.longitude, position!.latitude)
              .geohash
          : null,
    };
  }

  Map<String, Object?> categoryToJson() {
    return {"title": title, "outstandingIMGURL": outstandingIMGURL};
  }

  Future<ProfileData?> getOwner() async {
    var ref = await profilesRef.doc(author_id!).get();
    return ref.data();
  }

  Future<bool> commit_changes() async {
    /// lưu ý rằng, sẽ có một số url vẫn còn là local, nên bước này sẽ bao gồm cả việc
    /// upload các media này lên
    ///
    if (title.isEmpty) {
      debugPrint("error: title can not be empty!");

      return false;
    }
    if (await File(outstandingIMGURL).exists()) {
      try {
        File f = await File(outstandingIMGURL).create();
        outstandingIMGURL = "$author_id-${DateTime.now().toUtc()}";
        await storage.ref('food').child(outstandingIMGURL).putFile(f);
        outstandingIMGURL =
            await storage.ref('food').child(outstandingIMGURL).getDownloadURL();
      } catch (e) {
        debugPrint(
            "error: can not upload: " + outstandingIMGURL + e.toString());
        return false;
      }
    }
    for (int i = 0; i < mediaUrls.length; i++) {
      if (await File(mediaUrls[i]).exists()) {
        try {
          File f = await File(mediaUrls[i]).create();
          mediaUrls[i] = "$author_id-${DateTime.now().toUtc()}";
          await storage.ref('food').child(mediaUrls[i]).putFile(f);
          mediaUrls[i] =
              await storage.ref('food').child(mediaUrls[i]).getDownloadURL();
        } catch (e) {
          debugPrint("error: can not upload: " + mediaUrls[i] + e.toString());
          return false;
        }
      }
    }
    author_id = getMyProfileId();
    if (author_id != null) {
      if (id == "new") {
        DocumentReference doc = await postsRef.add(this);
        id = doc.id;
        return true;
      } else {
        try {
          await postsRef.doc(id).set(this);
        } catch (e) {
          debugPrint('error upload ' + e.toString());
          return false;
        }
        return true;
      }
    } else {
      return false;
    }
  }

  PostData clone() {
    return PostData(
      id: id,
      title: title,
      description: description,
      mediaUrls: mediaUrls,
      features: features,
      outstandingIMGURL: outstandingIMGURL,
      price: price,
      isGood: isGood,
      react: react,
      cateList: cateList,
      author_id: author_id,
      position: position,
    );
  }

  Future<bool> delete() async {
    try {
      await postsRef.doc(id).delete();
    } catch (e) {
      return false;
    }
    return true;
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

class Relationship {
  late String id, type, sender_id;

  /// type: friend, invitation, suggestion
  late DateTime time;
  late List<String> member_ids;

  Relationship(
      {this.id = "new",
      required this.sender_id,
      required this.type,
      required this.time,
      required this.member_ids});

  String get time_string {
    return timeago.format(time);
  }
  String get get_other_id_but_me {
    for (var a in member_ids){
      if (a!=getMyProfileId()){
        return a;
      }
    }
    return "none";
  }

  static Stream<ProfileData> friendRecommend(String of_id, int?limit) async*{
    var profiles = await profilesRef.limit(limit??100).get();
    List<Tuple2<int, ProfileData>> scores = [];
    for (var doc in profiles.docs) {
      var profile = doc.data();
      var mul = await profile.mutualism;
      scores.add(Tuple2(mul, profile));
    }
    scores.sort((Tuple2 a, Tuple2 b) {
      return a.item1.compareTo(b.item1) * -1;
    });
    for (var tuple in scores) {
      if (tuple.item2.id != getMyProfileId()) {
        yield tuple.item2;
      }
    }
  }

  // Stream<ProfileData> get members async* {
  //   for (var mid in member_ids) {
  //     var snap = await profilesRef.doc(mid).get();
  //     if (snap.data() != null) {
  //       yield snap.data()!;
  //     }
  //   }
  // }
  static Future<List<String>> mutualismIds(String id_a, String id_b) async {
    List<String> list_rel = (await relationshipsRef
            .where('member_ids', arrayContains: id_a)
            .where('type', isEqualTo: 'friend')
            .get())
        .docs
        .map((e) {
      var x = e.data().member_ids;
      x.remove(id_a);
      return x[0];
    }).toList();
    List<String> list_rel_ = (await relationshipsRef
            .where('member_ids', arrayContains: id_b)
            .where('type', isEqualTo: 'friend')
            .get())
        .docs
        .map((e) {
      var x = e.data().member_ids;
      x.remove(id_b);
      return x[0];
    }).toList();
    Set<String> ids = {};
    for (var i in list_rel) {
      if (list_rel_.contains(i)) {
        ids.add(i);
      }
    }
    return ids.toList();
  }

  static Future<List<String>> invitationIds(String of_id) async {
    var list_rel = await relationshipsRef
        .where('member_ids', arrayContains: of_id)
        .where('sender_id', isNotEqualTo: of_id)
        .where('type', isEqualTo: 'invitation')
        .get();
    Set<String> ids = {};
    for (var doc in list_rel.docs) {
      ids.addAll(doc.data().member_ids);
    }
    return ids.toList();
  }
  static Stream<Relationship>invitationRel(String of_id) async* {
    var list_rel = await relationshipsRef
        .where('member_ids', arrayContains: of_id)
        .where('type', isEqualTo: 'invitation')
        .get();
    for (var doc in list_rel.docs) {
      if (doc.data().sender_id!=of_id) {
        yield doc.data();
      }
    }
  }

  static Stream<ProfileData> invitationProfile(String of_id) async* {
    var ids = await invitationIds(of_id);
    for (var id in ids) {
      var profile = await profilesRef.doc(id).get();
      if (profile.data() != null) {
        yield profile.data()!;
      }
    }
  }

  static Stream<Relationship> friendRelationship(String of_id) async* {
    var list_rel = await relationshipsRef
        .where('member_ids', arrayContains: of_id)
        .where('type', isEqualTo: 'friend')
        .get();
    for (var doc in list_rel.docs) {
      yield doc.data();
    }
  }

  static Future<List<String>> friendIds(String of_id) async {
    var list_rel = await relationshipsRef
        .where('member_ids', arrayContains: of_id)
        .where('type', isEqualTo: 'friend')
        .get();
    Set<String> ids = {};
    for (var doc in list_rel.docs) {
      ids.addAll(doc.data().member_ids);
    }
    ids.remove(of_id);
    return ids.toList();
  }

  static Stream<ProfileData> friendProfile(String of_id) async* {
    var ids = await friendIds(of_id);
    for (var id in ids) {
      var profile = await profilesRef.doc(id).get();
      if (profile.data() != null) {
        yield profile.data()!;
      }
    }
  }

  static createId(List<String> ids) {
    ids.sort((a, b) => a.compareTo(b));
    String relation_id = ids.join('_');
    return relation_id;
  }

  static Future<bool> sendInvitation(String other_id) async {
    String relation_id = createId([getMyProfileId(), other_id]);
    var doc = await relationshipsRef.doc(relation_id).get();
    if (doc.exists && doc.data()!.type == "friend") {
      return false;
    }
    try {
      await relationshipsRef.doc(relation_id).set(Relationship(
          sender_id: getMyProfileId(),
          type: "invitation",
          time: DateTime.now(),
          member_ids: [getMyProfileId(), other_id]));
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> acceptInvitation(String other_id) async {
    String relation_id = createId([getMyProfileId(), other_id]);
    var doc = await relationshipsRef.doc(relation_id).get();

    if (!doc.exists || doc.exists && doc.data()!.type != "invitation") {
      return false;
    }
    var invitation = doc.data()!;
    invitation.type = "friend";
    try {
      await relationshipsRef.doc(relation_id).set(invitation);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> rejectInvitation(String other_id) async {
    String relation_id = createId([getMyProfileId(), other_id]);
    var doc = await relationshipsRef.doc(relation_id).get();

    if (!doc.exists || doc.exists && doc.data()!.type != "invitation") {
      return false;
    }
    var invitation = doc.data()!;

    try {
      await relationshipsRef.doc(invitation.id).delete();
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> removeFriend(String other_id) async {
    String relation_id = createId([getMyProfileId(), other_id]);
    var doc = await relationshipsRef.doc(relation_id).get();

    if (!doc.exists || doc.exists && doc.data()!.type != "friend") {
      return false;
    }
    var friend = doc.data()!;
    try {
      await relationshipsRef.doc(friend.id).delete();
    } catch (e) {
      return false;
    }
    return true;
  }

  static Relationship fromJson(Map<String, dynamic> data) {
    return Relationship(
        sender_id: data['sender_id'],
        type: data['type'],
        time: (data['time'] as Timestamp).toDate(),
        member_ids:
            (data['member_ids'] as List).map((e) => e as String).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'type': type,
      'member_ids': member_ids,
      'sender_id': sender_id
    };
  }
}

class ProfileData extends Equatable {
  String id;
  String name;
  late String userAsset;
  late String wallAsset;
  String? dayOfBirth;
  String? gender;
  String? location;
  List<String>? works;
  List<String>? schools;
  List<String>? favorites;

  ProfileData({
    this.id = "new",
    required this.name,
    this.userAsset =
        "https://firebasestorage.googleapis.com/v0/b/mobile-foodnet.appspot.com/o/profile%2Favatar_default.jpeg?alt=media&token=56e50943-98e5-44d8-9590-235569b96fe3",
    this.wallAsset = "gs://mobile-foodnet.appspot.com/profile/wall_default.png",
    this.dayOfBirth,
    this.gender,
    this.location,
    List<String>? works,
    List<String>? schools,
    List<String>? favorites,
  }) {
    this.schools = schools ?? [];
    this.works = works ?? [];
    this.favorites = favorites ?? [];
  }
  Future<int> get mutualism async{
    return (await Relationship.mutualismIds(getMyProfileId(), id)).length;
  }

  ProfileData.fromJson(Map<String, Object?> json)
      : this(
          id: json["id"]! as String,
          name: json["name"]! as String,
          userAsset: json["userAsset"]! as String,
          wallAsset: json["wallAsset"]! as String,
          dayOfBirth: json["dob"] != null
              ? (json["dob"]! as Timestamp).toDate().toString()
              : null,
          gender: json["gender"] != null ? json["gender"]! as String : null,
          location:
              json["location"] != null ? json["location"] as String : null,
          works: (json["works"] as List).map((e) => e as String).toList(),
          schools: (json["schools"] as List).map((e) => e as String).toList(),
          favorites:
              (json["favorites"] as List).map((e) => e as String).toList(),
        );

  Future<int> get friendsNumber async {
    return (await Relationship.friendIds(id)).length;
  }

  get time_string => "";

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "userAsset": userAsset,
      "wallAsset": wallAsset,
      "dob": dayOfBirth != null
          ? Timestamp.fromDate(DateTime.parse(dayOfBirth!))
          : null,
      "gender": gender,
      "location": location,
      "works": works,
      "schools": schools,
      "favorites": favorites,
    };
  }

  Future<bool> update(String type) async {
    try {
      if (type == "schools") {
        profilesRef.doc(id).update({type: schools});
      }
      if (type == "works") {
        profilesRef.doc(id).update({type: works});
      }
      if (type == "favorites") {
        profilesRef.doc(id).update({type: favorites});
      }
      if (type == "location") {
        if (location == null) {
          final update = <String, dynamic>{
            "location": FieldValue.delete(),
          };
          profilesRef.doc(id).update(update);
        } else {
          profilesRef.doc(id).update({type: location});
        }
      }
      if (type == "gender") {
        if (gender == null) {
          final update = <String, dynamic>{
            "gender": FieldValue.delete(),
          };

          profilesRef.doc(id).update(update);
        } else {
          profilesRef.doc(id).update({type: gender});
        }
      }
      if (type == "dayOfBirth") {
        if (dayOfBirth == null) {
          final update = <String, dynamic>{
            "dob": FieldValue.delete(),
          };

          profilesRef.doc(id).update(update);
        } else {
          profilesRef
              .doc(id)
              .update({"dob": Timestamp.fromDate(DateTime.parse(dayOfBirth!))});
        }
      }

      if (type == "userAsset") {
        if (await File(userAsset).exists()) {
          File f = await File(userAsset).create();
          String id = getMyProfileId();
          String temp = "$id-${DateTime.now().toUtc()}";
          await storage.ref('profile').child(temp).putFile(f);
          temp = await storage.ref('profile').child(temp).getDownloadURL();
          print(temp);
          userAsset = temp;
          profilesRef.doc(id).update({type: userAsset});
        }
      }

      if (type == "wallAsset") {
        if (await File(wallAsset).exists()) {
          File f = await File(wallAsset).create();
          String id = getMyProfileId();
          String temp = "$id-${DateTime.now().toUtc()}";
          await storage.ref('profile').child(temp).putFile(f);
          temp = await storage.ref('profile').child(temp).getDownloadURL();
          print(temp);
          wallAsset = temp;
          profilesRef.doc(id).update({type: wallAsset});
        }
      }
    } catch (e) {
      debugPrint("Error updating document $e");
      return false;
    }
    return true;
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class SearchData implements LazyLoadData {
  String? id;
  String? asset;
  String name;

  SearchData({
    this.id,
    this.asset,
    required this.name,
  });

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class Filter {
  /// lớp đại diện cho các điều kiện lọc cho tìm kiếm
  String? search_type;
  String? keyword;
  double? scoreThreshold;
  int? limit;
  List<double>? visibleRegion;
  String? author_id;

  Filter(
      {this.search_type,
      this.keyword,
      this.scoreThreshold,
      this.visibleRegion,
      this.limit,
      this.author_id});
}

class ReactionData implements LazyLoadData {
  // todo: thêm trigger để mỗi lần cập nhật sẽ update biến react trong post tương ứng
  String userId;
  String postId;
  int type;
  DateTime time;

  ReactionData(
      {required this.userId,
      required this.postId,
      required this.type,
      required this.time});

  factory ReactionData.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return ReactionData(
        userId: data!['userId'],
        postId: data['postId'],
        type: data["type"],
        time: DateTime.parse((data["time"] as Timestamp).toDate().toString()));
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "time": Timestamp.fromDate(time),
      'userId': userId,
      'postId': postId
    };
  }

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final bool unread;
  final DateTime createdAt;

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.unread,
      required this.createdAt});

  static Message fromJson(Map<String, dynamic> json) => Message(
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        message: json["message"],
        unread: json["unread"],
        createdAt: json["createdAt"]?.toDate(),
      );

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "unread": unread,
        "createdAt": createdAt.toUtc(),
      };
}

class RecentUserSearchData implements LazyLoadData {
  late String id;
  final String userAsset;
  final String? profileId;
  final String name;
  late DateTime createAt;

  RecentUserSearchData({
    required this.userAsset,
    required this.id,
    required this.name,
    this.profileId,
    required this.createAt,
  });

  static RecentUserSearchData fromJson(Map<String, dynamic> json) =>
      RecentUserSearchData(
        userAsset: json["userAsset"],
        id: json["id"],
        name: json["name"],
        profileId: json["profileId"],
        createAt: json["createAt"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "userAsset": userAsset,
        "id": id,
        "name": name,
        "profileId": profileId,
        "createAt": createAt.toUtc(),
      };

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}
