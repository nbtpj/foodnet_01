import 'package:tuple/tuple.dart';
import '../ui/screens/chat/model/user_model.dart';
import 'entities.dart';

/// định nghĩa các API sử dụng
/// các hàm này nên hỗ trợ cache dữ liệu

Future<PostData?> get_post(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  // TODO: implement get_post
  return null;
}

Stream<PostData> get_posts(Filter filter) async* {
  /// lấy 1 danh sách post theo điều kiệu lọc
  /// trả về dạng stream
  // TODO: implement get_posts
  if(filter.search_type! =="food") {
    yield PostData(
        id: "1",
        title: "Chicken Curry Pasta",
        outstandingIMGURL: "assets/food/ChickenCurryPasta.jpg",
        cateList: ["Chicken"],
        price: 22);
    yield PostData(
        id: '2',
        title: "Explosion Burger",
        outstandingIMGURL: "assets/food/ExplosionBurger.jpg",
        cateList: ["Fast Food"],
        price: 15);
    yield PostData(
        id: '3',
        title: "Grilled Chicken",
        outstandingIMGURL: "assets/food/GrilledChicken.jpg",
        cateList: ["Chicken"],
        price: 30);
    yield PostData(
        id: '4',
        title: "Grilled Fish",
        outstandingIMGURL: "assets/food/GrilledFish.jpg",
        cateList: ["Fish"],
        price: 27);
    yield PostData(
        id: "5",
        title: "Heavenly Pizza",
        outstandingIMGURL: "assets/food/HeavenlyPizza.jpg",
        cateList: ["Fast Food"],
        price: 24);
    yield PostData(
        id: '6',
        title: "Mandarin Pancake",
        outstandingIMGURL: "assets/food/MandarinPancake.jpg",
        cateList: ["Bakery"],
        price: 19);
    yield PostData(
        id: '7',
        title: "Organic Mandarin",
        outstandingIMGURL: "assets/food/OrganicMandarin.jpg",
        cateList: ["Fruit"],
        price: 15);
    yield PostData(
        id: '8',
        title: "Organic Orange",
        outstandingIMGURL: "assets/food/OrganicOrange.jpg",
        cateList: ["Fruit"],
        price: 12);
    yield PostData(
        id: '9',
        title: "Raspberries Cake",
        outstandingIMGURL: "assets/food/RaspberriesCake.jpg",
        cateList: ["Bakery"],
        price: 28);
  }
  if(filter.search_type! =="category"){
    yield PostData(
        id: "1",
        title: "Chicken",
        outstandingIMGURL: "assets/category/chicken.png");
    yield PostData(
        id: '2',
        title: "Bakery",
        outstandingIMGURL: "assets/category/bakery.png");
    yield PostData(
        id: '3',
        title: "Fast Food",
        outstandingIMGURL: "assets/category/fastfood.png");
    yield PostData(
        id: '4',
        title: "Fish",
        outstandingIMGURL: "assets/category/fish.png");
    yield PostData(
        id: "5",
        title: "Fruit",
        outstandingIMGURL: "assets/category/fruit.png");
    yield PostData(
        id: '6',
        title: "Soup",
        outstandingIMGURL: "assets/category/soup.png");
    yield PostData(
        id: '7',
        title: "Vegetable",
        outstandingIMGURL: "assets/category/vegetable.png");
  }
  // ver 1: giả dữ liệu local
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

Future<ProfileData>? getProfile(String id) async {
  /// hàm lấy một đối tượng Profile Data dựa trên id
  if (id == "1") {
    return ProfileData(
        id: "1",
        name: "Lương Đạt",
        userAsset: "assets/profile/dhia.jpg",
        wallAsset: "assets/profile/first.png",
        friendsNumber: 777,
        works: ["Người Việt Trẻ 06/01 - CLB Sinh viên vận động hiến máu Trường ĐH Công nghệ"],
        schools: ["Trường ĐH Công Nghệ - ĐHQGHN", "THPT Chuyên Đại học Sư Phạm"],
        dayOfBirth: "11/10/2001",
        gender: "Nam",
        location: "Hà Nội",
        favorites: ["Bóng đá", "Tình nguyện"]
    );
  } else {
    return ProfileData(
        id: "2",
        name: "Minh Quang",
        userAsset: "assets/profile/dhia.jpg",
        wallAsset: "assets/profile/first.png",
        mutualism: 25,
        location: "Hải Dương",
        gender: "Nam",
        schools: ["Khoa Công nghệ Thông tin - Trường ĐH Công Nghệ - VNU", "THPT Thanh Hà, Thanh Hà, Hải Dương"]
    );
  }
}

Stream<Tuple2<double, Object>?> search(Filter filter) async* {
  /// hàm tìm kiếm một tập các Object theo filter và trả về 1 stream các object tìm kiếm được
  /// cùng với một số double thể hiện độ 'matching' với filter
  // TODO: implement search
  yield null;
}

Stream<User> getOnlineUsers() async* {
  /// hàm tìm kiếm một tập các User đang online là friend của user hiện tại.
  yield User(
        id: 0,
        name: "Foydalanuvchi",
        imgURL: "assets/chat/me.png"
  );
  yield User(
        id: 1,
        name: "Abdulloh",
        imgURL: "assets/chat/gerb.jpg"
  );
  yield User(
        id: 2,
        name: "Jobirhon",
        imgURL: "assets/chat/magistrial.jpg"
  );
  yield User(
        id: 3,
        name: "Javohir",
        imgURL: "assets/chat/nature.jpg"
  );
  yield User(
        id: 4,
        name: "Odilbek",
        imgURL: "assets/chat/night.jpg"
  );
  yield User(
        id: 5,
        name: "Samandar",
        imgURL: "assets/chat/night.jpg"
  );
  yield User(
        id: 6,
        name: "Boburjon",
        imgURL: "assets/chat/me.png"
  );
  yield User(
        id: 7,
        name: "Sobirxon",
        imgURL: "assets/chat/boys.jpg"
  );
}