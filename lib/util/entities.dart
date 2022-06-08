import 'dart:io';
import 'dart:math';

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

final randomNumberGenerator = Random();

/// định nghĩa các đối tượng dữ liệu

class LazyLoadData {
  /// interface lazy load cho các đối tượng có quá nhiều dữ liệu
  /// ví dụ như: nếu đối tượng PostData chỉ cần hiển thị brief view thì không cần phải load toàn bộ các media.
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

  Map<String, dynamic> toJson() =>
      {
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

  PostData({this.author_id,
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
  void loadMore() {
    // TODO: implement loadMore
  }

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
    numUpvote = (await flattenReactionRef.where("postId", isEqualTo: id).where(
        'type', isEqualTo: 1).get()).size;
    numDownvote =
        (await flattenReactionRef.where("postId", isEqualTo: id).where(
            'type', isEqualTo: -1).get()).size;
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
          ? GeoHash
          .fromDecimalDegrees(position!.longitude, position!.latitude)
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
    /// todo lưu lại toàn bộ thay đổi, return false nếu fail
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

  /// todo: Khởi tạo thêm đặc tính features

  PostData clone() {
    return PostData(
      id: id,
      title: title,
      description: description,
      mediaUrls: mediaUrls,
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

class FriendData implements LazyLoadData {
  String id;
  String name;
  DateTime time;
  String userAsset;
  String type;
  int mutualism;

  FriendData({
    required this.id,
    required this.name,
    required this.time,
    required this.userAsset,
    required this.type,
    required this.mutualism,
  });

  @override
  void loadMore() {
    // TODO: implement loadMore
  }

  FriendData.fromJson(Map<String, Object?> json)
      : this(
      id: json["id"]! as String,
      name: json["name"]! as String,
      userAsset: json["userAsset"] as String,
      time: (json['time'] as Timestamp).toDate(),
      type: json['type'] as String,
      mutualism: 0);

  String get time_string {
    return timeago.format(time);
  }

  Map<String, Object?> toJson() {
    return {"id": id, "name": name, "time": time, "userAsset": userAsset, "type": type};
  }
}

class ProfileData extends Equatable {
  String? id;
  String name;
  late String userAsset;
  late String wallAsset;
  int? mutualism;
  int friendsNumber = 0;
  String? dayOfBirth;
  String? gender;
  String? location;
  List<String>? works;
  List<String>? schools;
  List<String>? favorites;
  List<String>? friendReferences;

  ProfileData({
    this.id,
    required this.name,
    this.userAsset = "https://firebasestorage.googleapis.com/v0/b/mobile-foodnet.appspot.com/o/profile%2Favatar_default.jpeg?alt=media&token=56e50943-98e5-44d8-9590-235569b96fe3",
    this.wallAsset = "gs://mobile-foodnet.appspot.com/profile/wall_default.png",
    this.mutualism,
    this.friendsNumber = 0,
    this.dayOfBirth,
    this.gender,
    this.location,
    List<String>? works,
    List<String>? schools,
    List<String>? favorites,
    List<String>? friendReferences,
  }) {
    this.schools = schools ?? [];
    this.works = works ?? [];
    this.favorites = favorites ?? [];
    this.friendReferences = friendReferences ?? [];
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
      friendReferences: json.containsKey("friends") && json["friends"] != null
          ? (json["friends"]! as List)
          .map((e) => e.path as String)
          .toList()
          : [],
      friendsNumber: (json.containsKey("friends") && json["friends"] != null
          ? (json["friends"]! as List)
          : []).length
    // friends: (json["friends"] as List).map((e) => e as FriendData).toList(),
  );

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "userAsset": userAsset,
      "wallAsset": wallAsset,
      "dob": dayOfBirth != null ? Timestamp.fromDate(
          DateTime.parse(dayOfBirth!)) : null,
      "gender": gender,
      "location": location,
      "works": works,
      "schools": schools,
      "favorites": favorites,
      "friends": friendReferences,
      "friendsNumber": friendsNumber
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
          profilesRef.doc(id).update(
              {"dob": Timestamp.fromDate(DateTime.parse(dayOfBirth!))});
        }
      }

      if (type == "userAsset") {
        if (await File(userAsset).exists()) {
          File f = await File(userAsset).create();
          String id = getMyProfileId();
          String temp = "$id-${DateTime.now().toUtc()}";
          await storage.ref('profile').child(temp).putFile(f);
          temp =
          await storage.ref('profile').child(temp).getDownloadURL();
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
          temp =
          await storage.ref('profile').child(temp).getDownloadURL();
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
  List<Object?> get props => [id];
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
  late String? search_type;
  late String? keyword;
  late double? scoreThreshold;
  List<double>? visibleRegion;

  Filter({this.search_type,
    this.keyword,
    this.scoreThreshold,
    this.visibleRegion});
}

class ReactionData implements LazyLoadData {
  String userId;
  String postId;
  int type;
  DateTime time;

  ReactionData(
      {required this.userId, required this.postId, required this.type, required this.time});

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

  Message({required this.senderId,
    required this.receiverId,
    required this.message,
    required this.unread,
    required this.createdAt});

  static Message fromJson(Map<String, dynamic> json) =>
      Message(
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        message: json["message"],
        unread: json["unread"],
        createdAt: json["createdAt"]?.toDate(),
      );

  Map<String, dynamic> toJson() =>
      {
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

  Map<String, dynamic> toJson() =>
      {
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
