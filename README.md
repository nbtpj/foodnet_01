# foodnet_01

Dự án FoodNet - Mạng xã hội review ẩm thực (cài đặt phía ứng dụng).

## Getting Started

Chạy lệnh sau để chạy ứng dụng trong các máy ảo:

```cmd
flutter run
```

Để ứng dụng hoạt động, máy cần phải có kết nối mạng.

Các tài liệu liên quan được cập nhật tại địa chỉ [Google Driver](https://drive.google.com/drive/folders/1GCwJzF32qca5T-HzU_95EOmZjZCo5D99?usp=sharing), bao gồm:
* [Tài liệu hướng dẫn sử dụng](https://docs.google.com/document/d/1TiTDeaF_t5___Y3sHM969yky0OKN9ArO/edit?usp=sharing&ouid=101352446849824163988&rtpof=true&sd=true)
* [Báo cáo](https://docs.google.com/document/d/1X1j7BIUgD4pPOVZDAcsCAc9WP_9fThTP/edit?usp=sharing&ouid=101352446849824163988&rtpof=true&sd=true)
* [Phân công công việc](https://docs.google.com/spreadsheets/d/14ROmwByNcetT_ewgx4Gf5Eghc_ls20IkjzbFpV1v3tc/edit?usp=sharing)
* [Video demo](https://youtu.be/Nk5OWpM3rFs)
* [Phiên bản cài đặt (cho Android)](https://drive.google.com/drive/folders/12tNAMTDt_631zcC2YndRZKceum_tzP1n?usp=sharing)

## Nhóm tác giả
* Lương Duy Đạt
* Nguyễn Minh Quang
* Phạm Văn Trọng
* Đào Trọng Tuấn

## Lưu ý khi sử dụng mã nguồn
File [cloud_function.js](cloud_function_define/cloud_function.js) mô tả các cloud function được cài đặt trên Firebase, KHÔNG thể triển khai trực tiếp từ project này. Trên thực tế, một project Firebase khác được tạo ra và triển khai, quản lý các chức năng này.

Các API key được thể hiện trong mã nguồn với mục đích build thử nghiệm. Mọi hành vi lạm dụng các API này cho mục đích khác đều KHÔNG được phép.

Mã nguồn này đã build và chạy được trên máy ảo IOS, tuy nhiên do một số chính sách của Apple, sẽ không có file cài đặt cho IOS.
## Tài liệu tham khảo
Dự án này tham khảo một số thiết kế từ :
* [food_order_ui](https://github.com/iremaysel/food_order_ui)
* [facebook_clone](https://github.com/youssefmarzouk621/facebook-clone)
