import 'package:tuple/tuple.dart';
import 'entities.dart';

/// định nghĩa các API sử dụng
/// các hàm này nên hỗ trợ cache dữ liệu

PostData? get_post(String id) {
  /// hàm lấy một đối tượng PostData dựa trên id
  // TODO: implement get_post
  return null;
}

Iterable<PostData> get_posts(Filter filter) sync* {
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

UserData? get_user(String id)  {
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


Iterable<Tuple2<double, Object>?> search(Filter filter) sync* {
  /// hàm tìm kiếm một tập các Object theo filter và trả về 1 stream các object tìm kiếm được
  /// cùng với một số double thể hiện độ 'matching' với filter
  // TODO: implement search
  yield null;
}