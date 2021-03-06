# FoodNet

Dự án FoodNet - Mạng xã hội review ẩm thực (cài đặt phía ứng dụng).

## Getting Started

Cài đặt Flutter theo [hướng dẫn](https://docs.flutter.dev/get-started/install). 

Lưu ý phiên bản Android được khuyến khích sử dụng là Android 12.0, API 31.

Tại giao diện dòng lệnh, mở đường dẫn của thư mục project và thực hiện các thao tác sau (khuyến khích sử dụng các IDE sẽ trực quan hơn để thao tác với các máy ảo)

Chạy lệnh sau để tải các package cần thiết và tạo Icon app:


```cmd
flutter pub get
flutter pub run flutter_launcher_icons:main
```

Chạy lệnh sau để chạy ứng dụng trong các máy ảo (lưu ý phải kết nối với AVD hoặc máy ảo IOS trước khi chạy):

```cmd
flutter run
```

Chạy lệnh sau để build mã nguồn sang file APK (lưu tại ```build\app\outputs\flutter-apk\app-release.apk```)

```cmd
flutter build apk --no-tree-shake-icons
```

Với phiên bản IOS:

```cmd
flutter build ios --no-tree-shake-icons
```

Tuy nhiên, như sẽ nói ở phần Lưu ý, có một vài điều kiện mà bạn phái đáp ứng thì mới có thể build & deploy app. Trong trường hợp chỉ muốn test khả năng hoạt động trên nền tảng IOS, lời khuyên là sử dụng lệnh chạy ứng dụng trên máy ảo IOS (sử dụng lệnh ```flutter run```)!


Để ứng dụng hoạt động, máy cần phải có kết nối mạng và cho phép quyền truy cập vị trí.

Các tài liệu liên quan được cập nhật tại địa chỉ [Google Driver](https://drive.google.com/drive/folders/1GCwJzF32qca5T-HzU_95EOmZjZCo5D99?usp=sharing), bao gồm:
* [Tài liệu hướng dẫn sử dụng](https://docs.google.com/document/d/1TiTDeaF_t5___Y3sHM969yky0OKN9ArO/edit?usp=sharing&ouid=101352446849824163988&rtpof=true&sd=true)
* [Báo cáo](https://drive.google.com/file/d/161pyfcBcUe-HI3U9UK0MjKQy2It7siRT/view?usp=sharing)
* [Phân công công việc](https://docs.google.com/spreadsheets/d/14ROmwByNcetT_ewgx4Gf5Eghc_ls20IkjzbFpV1v3tc/edit?usp=sharing)
* [Video demo](https://youtu.be/Nk5OWpM3rFs)
* [Phiên bản cài đặt (cho Android)](https://drive.google.com/drive/folders/12tNAMTDt_631zcC2YndRZKceum_tzP1n?usp=sharing)

## Ảnh chụp một số màn hình chính

<img src="./snapshots/Screenshot_20220626_125854.png" width="32%"> <img src="./snapshots/Screenshot_20220626_125900.png" width="32%"> 

<img src="./snapshots/Screenshot_20220626_081551.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081616.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081629.png" width="32%"> 

<img src="./snapshots/Screenshot_20220626_081642.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081705.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081718.png" width="32%"> 

<img src="./snapshots/Screenshot_20220626_081743.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081753.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081818.png" width="32%"> 

<img src="./snapshots/Screenshot_20220626_081827.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081837.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081911.png" width="32%"> 

<img src="./snapshots/Screenshot_20220626_081922.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081940.png" width="32%"> <img src="./snapshots/Screenshot_20220626_081953.png" width="32%"> 




## Nhóm tác giả
* Lương Duy Đạt
* Nguyễn Minh Quang
* Phạm Văn Trọng
* Đào Trọng Tuấn

## Công nghệ sử dụng
* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)

## Lưu ý khi sử dụng mã nguồn
File [cloud_function.js](cloud_function_define/cloud_function.js) mô tả các cloud function được cài đặt trên Firebase, KHÔNG thể triển khai trực tiếp từ project này. Trên thực tế, một project Firebase khác được sử dụng để triển khai, quản lý các chức năng này.

Các API key được thể hiện trong mã nguồn với mục đích build thử nghiệm. Mọi hành vi lạm dụng các API này cho mục đích khác đều KHÔNG được phép.

Mã nguồn này đã build và chạy được trên máy ảo IOS, tuy nhiên do một số chính sách của Apple, sẽ không có file cài đặt được cung cấp cho IOS.
Trong trường hợp bạn đã có Bundle ID và muốn thử nghiệm build và deploy, có thể tham khảo [hướng dẫn](https://docs.flutter.dev/deployment/ios).

## Tài liệu tham khảo
Dự án này tham khảo một số thiết kế từ :
* [food_order_ui](https://github.com/iremaysel/food_order_ui)
* [facebook_clone](https://github.com/youssefmarzouk621/facebook-clone)
