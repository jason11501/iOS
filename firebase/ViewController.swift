//
//  ViewController.swift
//  firebase
//
//  Created by jason on 04/05/2022.
//

import UIKit
import Toast_Swift
import FirebaseAuth
import FBSDKLoginKit // import FacebookLogin no longer

class ViewController: UIViewController {

    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        autoLogin()
    }

//    func autoLogin(){
//        //lưu ID vào bộ nhớ đệm
//        let currentUserID = Auth.auth().currentUser?.uid
//
//        //check ngta login rồi hay chưa
//        if currentUserID != nil{
//            print("auto login")
//            //CHANGE SCREEN
//        }
//    }
    
    @IBAction func tapOnForgot(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: "mail-which-user-type-in-pop-up") { (error) in
            if error != nil{
                self.view.makeToast(error?.localizedDescription)
            }else{
                self.view.makeToast("Successfully, check your mail now")
            }
        }
    }
    
    @IBAction func tapOnLogin(_ sender: Any) {
        view.endEditing(true)
        if tfEmail.text == "" || tfPassword.text == ""{
            //Firebase đã xét hết những trường hợp gõ ko hợp lệ về mail, pass
            self.view.makeToast("Sorry, please enter your info.")
        }else{
            //REGISTER
            Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { [weak self]
                (authData, error) in
                if error != nil{
                    self?.view.makeToast(error!.localizedDescription)
                }else{
                    authData?.user.reload(completion: {(error) in
                        if (authData?.user.isEmailVerified)!{
                            //CHANGE CREEN TO HOME
                            self?.view.makeToast("Successfully login")
                        }else{
                            self?.view.makeToast("Not verified mail.")
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func tapOnRegister(_ sender: Any) {
        let vc = registerViewController(nibName: "registerViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnLoginFacebook(_ sender: Any) {
        super.viewDidLoad()

        let loginButton = FBLoginButton() //FBSDKLoginButton() no longer
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    
}
