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
    }
    
    func userChecking () {
        if Auth.auth().currentUser != nil {
            let sb = UIStoryboard(name: "Detail", bundle: Bundle.main)
            guard let navVC = sb.instantiateViewController(withIdentifier: "TabBarController1") as? UITabBarController else {return}
            self.present(navVC, animated: true, completion: nil)
        }
    }

    @objc func signInButtonTapped() {
                guard let email = emailTextField.text,
                    let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.showAlert(withTitle: "Error", message: validError.localizedDescription)
            }
            
            if user != nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                let sb = UIStoryboard(name: "Detail", bundle: Bundle.main)
                guard let navVC = sb.instantiateViewController(withIdentifier: "TabBarController1") as? UITabBarController else {return}
                self.present(navVC, animated: true, completion: nil)
                
            }
        }

    }

}

