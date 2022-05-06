# Ứng dụng iOS: Authentication
Gồm những tính năng (features): <br>

* Login với email
* Register với email có avatar
* Login bằng Facebook

## Install environments
**Công cụ (Tool):**<br>
* Xcode 13.3.1
* Firebase: https://console.firebase.google.com/u/0/<br>

**Ngôn ngữ (Language):**<br>
* Swift

Mở Terminal, cd vào folder firebase chứa Podfile, run: 
```
pod install
```

## Quick start
Các bạn có thể clone repo này về và chạy ngay bằng câu lệnh dưới đây. Trước đó b thay thế link_to_image bằng đường dẫn tới ảnh muốn đọc
```
python main.py --image_path=link_to_image 
```

## Kết quả
   Project nhận diện biển số xe này của mình có thể hoạt động trên cả biển một dòng hoặc hai dòng. Thậm chí đôi khi biển số xe bị che khuất một chút vẫn đọc được. :sunglasses:
   <p align="center" >
   <img src="https://images.viblo.asia/877154c3-929f-431c-a728-4a994acf6869.png" >
    Ảnh 4:  Kết quả
</p>

Tuy nhiên, nó vẫn có một số nhược điểm::worried:

* Khi ảnh đầu vào bị đặt một góc quá nghiên thì một vài kí tự sẽ bị nhầm dòng. Có một cách giải quyết là dùng một mạng transformer xoay ảnh nghiêng về ảnh thẳng.
* Đôi khi bị nhận dạng nhầm giữa 8 và B, 0 và D
*  Hoạt động kém khi bức ảnh quá mờ
