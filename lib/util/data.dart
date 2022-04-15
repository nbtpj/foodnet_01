import 'package:tuple/tuple.dart';
import 'entities.dart';

/// định nghĩa các API sử dụng
/// các hàm này nên hỗ trợ cache dữ liệu

Future<PostData?> get_post(String id) async {
  /// hàm lấy một đối tượng PostData dựa trên id
  // TODO: implement get_post
  return null;
}

Future<UserData?> get_user(String id) async {
  /// hàm lấy một đối tượng UserData dựa trên id
  // TODO: implement get_user
  return null;
}

Future<GoodData?> get_good(String id) async {
  /// hàm lấy một đối tượng GoodData dựa trên id (trên thực tế GoodData kế thừa PostData
  // TODO: implement get_good
  return null;
}

Stream<Tuple2<double, Object>?> search(Filter filter) async*{
  /// hàm tìm kiếm một tập các Object theo filter và trả về 1 stream các object tìm kiếm được
  /// cùng với một số double thể hiện độ 'matching' với filter
  // TODO: implement search
  yield null;
}
