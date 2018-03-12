//
//  TCSignInViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 05/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import KYDrawerController

class TCSignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        }
    }
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        //Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "EducationBackground")
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    
    func userChecking () {
        ref.child("Tuition Centre").observe(.childAdded) { (snapshot) in
            guard let currentUserUID = Auth.auth().currentUser?.uid else {return}

            if Auth.auth().currentUser != nil && currentUserUID == snapshot.key {
                let sb = UIStoryboard(name: "TCDetail", bundle: Bundle.main)
                guard let navVC = sb.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController else {return}
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func signInButtonTapped() {
        var userIsTuitionCheck : Bool = false
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        ref.child("Tuition Centre").observe(.value) { (snapshot) in
            
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
                                    let sb = UIStoryboard(name: "TCDetail", bundle: Bundle.main)
                                    guard let navVC = sb.instantiateViewController(withIdentifier: "TCNavigationController") as? UINavigationController else {return}
                                    self.present(navVC, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                }
                
                if userIsTuitionCheck == false {
                    self.showAlert(withTitle: "Error", message: "Please sign in with existing tuition centre account")
                }
            }
        }
    }
    
}

