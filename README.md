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

## Kết quả
   :sunglasses:
   <p align="center" >
   <img src="https://drive.google.com/file/d/18PqibS-eCCzAaQ4eQeZ8a8kfj7suzEmN/view?usp=sharing" >
    Ảnh 4:  Kết quả
</p>

Tuy nhiên, nó vẫn có một số nhược điểm::worried:

* Khi ảnh đầu vào bị đặt một góc quá nghiên thì một vài kí tự sẽ bị nhầm dòng. Có một cách giải quyết là dùng một mạng transformer xoay ảnh nghiêng về ảnh thẳng.
* Đôi khi bị nhận dạng nhầm giữa 8 và B, 0 và D
*  Hoạt động kém khi bức ảnh quá mờ
