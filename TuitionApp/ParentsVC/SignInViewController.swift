//
//  SignInViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 02/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        }
    }
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()      
        ref = Database.database().reference()
        userChecking()
        TCUserChecking()
    }
    
    func userChecking () {
        ref.child("Tuition").child("Parent").observe(.childAdded) { (snapshot) in
            guard let b = Auth.auth().currentUser?.uid else {return}
            print(b)
            guard let a = Auth.auth().currentUser?.uid else {return}
            
            if Auth.auth().currentUser != nil && a == snapshot.key {
                let sb = UIStoryboard(name: "Detail", bundle: Bundle.main)
                guard let navVC = sb.instantiateViewController(withIdentifier: "TabBarController1") as? UITabBarController else {return}
//                guard let navVC = sb.instantiateViewController(withIdentifier: "AttendanceViewController") as? AttendanceViewController else {return}

                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    func TCUserChecking () {
        ref.child("Tuition Centre").observe(.childAdded) { (snapshot) in
            guard let a = Auth.auth().currentUser?.uid else {return}
            
            if Auth.auth().currentUser != nil && a == snapshot.key {
                let sb = UIStoryboard(name: "TCDetail", bundle: Bundle.main)
//                guard let navVC = sb.instantiateViewController(withIdentifier: "TCNavigationController") as? UINavigationController else {return}
                guard let navVC = sb.instantiateViewController(withIdentifier: "KYDrawerController") as? DrawerViewController else {return}

                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func signInButtonTapped() {
        var userIsTuitionCheck : Bool = false
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        ref.child("Tuition").child("Parent").observe(.value) { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any] {
                
                for id in dict {
                    if let idValues = id.value as? [String:Any],
                        let emailValue = idValues["Email"] as? String {
                        
                        if email == emailValue {
                            userIsTuitionCheck = true
                            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                                if let validError = error {
                                    self.showAlert(withTitle: "Error", message: validError.localizedDescription)
                                    
                                }
                                
                                if user != nil {
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
                                    let sb = UIStoryboard(name: "Detail", bundle: Bundle.main)
                                    guard let navVC = sb.instantiateViewController(withIdentifier: "TabBarController1") as? UITabBarController else {return}
//                                    guard let navVC = sb.instantiateViewController(withIdentifier: "AttendanceViewController") as? AttendanceViewController else {return}

                                    self.present(navVC, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                }
                if userIsTuitionCheck == false {
                    self.showAlert(withTitle: "Error", message: "Please sign in with existing Parent account")
                }
            }
        }
    }

}

