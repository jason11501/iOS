//
//  registerViewController.swift
//  firebase
//
//  Created by jason on 04/05/2022.
//

import UIKit

//xuất bảng thông báo để debug
import Toast_Swift

import FirebaseAuth
import FirebaseDatabase

//avatar
import FirebaseStorage

import ProgressHUD// loading
class registerViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupImageAvatar()
    }
    
    func setupImageAvatar(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseAvatar))
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(tapGesture)
    }
    
    //Khi nhấp ava sẽ có 3 trường hợp
    @objc func chooseAvatar(){
        let alert = UIAlertController(title: nil, message: "Choose options", preferredStyle: .actionSheet)
        //TH1: CHỤP ẢNH
        let action1 = UIAlertAction(title: "Take a photo", style: .default) { (action1) in
            self.imgPicker.sourceType = .camera
            self.present(self.imgPicker, animated: true, completion: nil)
        }
        //TH2: CHỌN TỪ LIBRARY
        let action2 = UIAlertAction(title: "Choose from library", style: .default) { (action2) in
            self.imgPicker.sourceType = .photoLibrary
            self.imgPicker.delegate = self
            self.present(self.imgPicker, animated: true, completion: nil)
        }
        //TH3: KHÔNG CHỌN GÌ
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapOnRegister(_ sender: Any) {
        ProgressHUD.show()
        //ProgressHUD.show(icon: .succeed) // loading icon
        iconview.endEditing(true)
        if tfEmail.text == "" || tfPassword.text == ""{
            //Firebase đã xét hết những trường hợp gõ ko hợp lệ về mail, pass nên ta ko cần làm
            self.view.makeToast("Sorry, please enter your info.")
            ProgressHUD.dismiss()// tắt loading icon tại mỗi case lỗi
        }else{
            //REGISTER
            Auth.auth().createUser(withEmail: tfEmail.text!, password: tfPassword.text!) { (authData, error) in
                
                if error != nil{
                    self.view.makeToast(error!.localizedDescription)
                    ProgressHUD.dismiss()// tắt loading icon tại mỗi case lỗi
                }
//                    else{
//                        self.view.makeToast("Successfully registered.")
//                        print(authData?.user.email)
//                    }
                //VERIFY MAIL để biết nhập mail thật hay giả
                authData?.user.sendEmailVerification(completion: {(error) in
                    if error != nil{
                        self.view.makeToast(error!.localizedDescription)
                        ProgressHUD.dismiss()// tắt loading icon tại mỗi case lỗi
                    }else{
                        self.view.makeToast("Sent verification mail")
                        
                        // UP AVA của user vào database sau khi verify mail/ STORAGE
                        if let userData = authData{
                            let imageName = userData.user.uid
                            if let imageUpload = self.imgAvatar.image{
                                // min 0, max 1, nên từ 0.3-0.5
                                if let imgData = imageUpload.jpegData(compressionQuality: 0.5){
                                    let storageRef = Storage.storage().reference()
                                    let uploadStorage = storageRef.child("Avatar").child(imageName)
                                    uploadStorage.putData(imgData, metadata: nil){ (meta, error) in
                                        if error != nil{
                                            self.view.makeToast(error!.localizedDescription)
                                        }else{
                                            self.view.makeToast("Avatar in database")
                                            
                                            //DOWNLOAD ẢNH/ LẤY URL sau khi đã save trong database để display
                                            //để mỗi lần muốn display ko cần phải mỗi lần tải về, mà
                                            // ta đã chỉ cần lấy url đã save trong database để display
                                            uploadStorage.downloadURL{ (url, error) in
                                                if error != nil{
                                                    self.view.makeToast(error!.localizedDescription)
                                                }else{
                                                    //SAVE URL IN DATABASE
                                                    let databaseRef = Database.database().reference()
                                                    guard let avatarUrl = url else {return}
                                                    let value = ["email": self.tfEmail.text!, "id": userData.user.uid, "avatar": "\(avatarUrl)"]
                                                    databaseRef.child("User").child(userData.user.uid).setValue(value)
                                                    
                                                    ProgressHUD.showSuccess()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
}

// support cho action2 tại dòng .delegate
extension registerViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgAvatar.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
/*
 STORAGE S
 S.B1: up ảnh of client vào database
 S.B2: firebase save ảnh ---return--> URL để client display ảnh
 S.B3: client muốn display ảnh:
        S.B3.1: client tải ảnh (lấy URL về)
        S.B3.2: client phải lưu URL trong database
 */

////loading
//import SwiftUI
//
//struct SpinningView: View {
//
//    // MARK:- variables
//    @State var circleEnd: CGFloat = 0.001
//    @State var smallerCircleEnd: CGFloat = 1
//
//    @State var rotationDegree: Angle = Angle.degrees(-90)
//    @State var smallerRotationDegree: Angle = Angle.degrees(-30)
//
//    let trackerRotation: Double = 1
//    let animationDuration: Double = 1.35
//
//    // MARK:- views
//    var body: some View {
//        ZStack {
//            Color.black
//                .edgesIgnoringSafeArea(.all)
//            ZStack {
//                Circle()
//                    .trim(from: 0, to: circleEnd)
//                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
//                    .fill(Color.white)
//                    .rotationEffect(self.rotationDegree)
//                    .frame(width: 130, height: 130)
//                Circle()
//                    .trim(from: 0, to: smallerCircleEnd)
//                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
//                                        .fill(Color.white.opacity(0.9))
//                    .rotationEffect(self.smallerRotationDegree)
//                    .frame(width: 48, height: 48 )
//            }.offset(y: -48)
//            Text("@shubham_iosdev")
//                .foregroundColor(.white)
//                .font(.system(size: 20, weight: .medium, design: .monospaced))
//                .opacity(0.7)
//                .offset(x: 96, y: 380)
//            .onAppear() {
//                animate()
//                Timer.scheduledTimer(withTimeInterval: animationDuration * 1.98, repeats: true) { _ in
//                    reset()
//                    animate()
//                }
//            }
//        }
//    }
//
//    // MARK:- functions
//    func animate() {
//        withAnimation(Animation.easeOut(duration: animationDuration)) {
//            self.circleEnd = 1
//        }
//        withAnimation(Animation.easeOut(duration: animationDuration * 1.1)) {
//            self.rotationDegree = RotationDegrees.initialCicle.getRotationDegrees()
//        }
//
//        /// smaller circle
//        withAnimation(Animation.easeOut(duration: animationDuration * 0.85)) {
//                self.smallerCircleEnd = 0.001
//            self.smallerRotationDegree = RotationDegrees.initialSmallCircle.getRotationDegrees()
//        }
//
//
//        Timer.scheduledTimer(withTimeInterval: animationDuration * 0.7, repeats: false) { _ in
//            withAnimation(Animation.easeIn(duration: animationDuration * 0.4)) {
//                self.smallerRotationDegree = RotationDegrees.middleSmallCircle.getRotationDegrees()
//                self.rotationDegree = RotationDegrees.middleCircle.getRotationDegrees()
//            }
//        }
//
//        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
//            withAnimation(Animation.easeOut(duration: animationDuration)) {
//                self.rotationDegree = RotationDegrees.last.getRotationDegrees()
//                self.circleEnd = 0.001
//            }
//
//            /// smaller circle
//            withAnimation(Animation.linear(duration: animationDuration * 0.8)) {
//                self.smallerCircleEnd = 1
//                self.smallerRotationDegree = RotationDegrees.last.getRotationDegrees()
//            }
//        }
//    }
//
//    func reset() {
//        self.rotationDegree = .degrees(-90)
//        self.smallerRotationDegree = Angle.degrees(-30)
//    }
//}
//
//struct SpinningView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            SpinningView()
//        }
//    }
//}
//
//
//enum RotationDegrees {
//    case initialCicle
//    case initialSmallCircle
//
//    case middleCircle
//    case middleSmallCircle
//
//    case last
//
//    func getRotationDegrees() -> Angle {
//        switch self {
//        case .initialCicle:
//            return .degrees(365)
//        case .initialSmallCircle:
//            return .degrees(679)
//
//        case .middleCircle:
//            return .degrees(375)
//        case .middleSmallCircle:
//            return .degrees(825)
//
//        case .last:
//            return .degrees(990)
//        }
//    }
//}
////end loading
