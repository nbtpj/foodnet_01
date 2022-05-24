import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    print('current post is empty?' + a.toString());
    print('____________');
    return a;
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

  int get numcite => 9999;

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

  // CommentData getPreviousComment() {
  //   return CommentData(timestamp: DateTime.now());
  // }

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
    String address = "${place.name}, ${place.street}, "
        "${place.subLocality},"
        " ${place.locality}, ${place.administrativeArea} "
        "${place.postalCode}, ${place.country}";
    debugPrint("current place is " + address);
    return address;
  }

  Future<int> getReact() async {
    react = await getMyReaction(id);
    return react;
  }

  void changeReact() {
    /// todo: thay đổi theo id người dùng hiện tại
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
      default: return;
    }
  }

  void commitReaction() {
    switch (react) {
      case 0:
        removeReaction(id, getMyProfileId());
        break;
      case 1:
        addReaction(id, ReactionData(
            userId: getMyProfileId(),
            type: "upvote",
            time: DateTime.now())
        );
        break;
      case -1:
        addReaction(id, ReactionData(
            userId: getMyProfileId(),
            type: "downvote",
            time: DateTime.now())
        );
        break;
      default: return;
    }
  }

  Future<ReactionPostData> getRate() async{
    ReactionPostData data = await getRateByPostId(id);
    numUpvote = data.numUpvote;
    numDownvote = data.numDownvote;
    return data;
  }

  PostData.fromJson(Map<String, Object?> json)

  /// todo: cài đặt có thể khởi tạo các position có kiểu Latng
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
      "outstandingIMGURL": outstandingIMGURL
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
  int mutualism;

  FriendData({
    required this.id,
    required this.name,
    required this.time,
    required this.userAsset,
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
      mutualism: 0);

  String get time_string {
    return timeago.format(time);
  }

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "name": name,
      "time": time,
      "userAsset": userAsset
    };
  }
}

class ProfileData {
  String? id;
  String name;
  String userAsset;
  String wallAsset;
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
    required this.userAsset,
    required this.wallAsset,
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
      dayOfBirth: (json["dob"]! as Timestamp).toDate().toString(),
      gender: json["gender"]! as String,
      location: json["location"] as String,
      works: (json["works"] as List).map((e) => e as String).toList(),
      schools: (json["schools"] as List).map((e) => e as String).toList(),
      favorites:
      (json["favorites"] as List).map((e) => e as String).toList(),
      friendReferences: (json["friends"]! as List)
          .map((e) => e.path as String)
          .toList(),
      friendsNumber: (json["friends"] as List).length
    // friends: (json["friends"] as List).map((e) => e as FriendData).toList(),
  );

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "name": name,
      "userAsset": userAsset,
      "wallAsset": wallAsset,
      "dob": dayOfBirth,
      "gender": gender,
      "location": location,
      "works": works,
      "schools": schools,
      "favorites": favorites,
      "friends": friendReferences,
      "friendsNumber": friendsNumber
    };
  }
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
  LatLngBounds? vision_bounds;

  Filter(
      {this.search_type,
        this.keyword,
        this.scoreThreshold,
        LatLngBounds? this.vision_bounds});
}

class ReactionData implements LazyLoadData {
  String userId;
  String type;
  DateTime time;

  ReactionData({
    required this.userId,
    required this.type,
    required this.time
  });

  factory ReactionData.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) {
      return ReactionData(userId: "", type: "", time: DateTime.now());
    }
    return ReactionData(
        userId: snapshot.id,
        type: data["type"],
        time: DateTime.parse((data["time"] as Timestamp).toDate().toString())
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "time": Timestamp.fromDate(time)
    };
  }

  @override
  void loadMore() {
    // TODO: implement loadMore
  }
}

class ReactionPostData {
  int numUpvote;
  int numDownvote;

  ReactionPostData({
    this.numUpvote = 0,
    this.numDownvote = 0,
  });

  factory ReactionPostData.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) {
      return ReactionPostData();
    } else {
      return ReactionPostData(
        numUpvote: data["upvote"],
        numDownvote: data["downvote"],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "upvote": numUpvote,
      "downvote": numDownvote
    };
  }
}


class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final bool unread;
  final DateTime createdAt;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.unread,
    required this.createdAt
  });

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