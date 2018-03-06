//
//  TCSignUpViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 05/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TCSignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        signUpUser()
    }
    
    func signUpUser() {
        guard let email = emailTextField.text,
            let userName = usernameTextField.text,
            let contact = contactTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {return}
        
        if !email.contains("@") {
            //show error //if email not contain @
            showAlert(withTitle: "Invalid Email format", message: "Please input valid Email")
        } else if password.count < 1 {
            //show error
            showAlert(withTitle: "Invalid Password", message: "Password must contain 1 characters")
        } else if password != confirmPassword {
            //show error
            showAlert(withTitle: "Password Do Not Match", message: "Password must match")
        } else if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: contact)) == false {
            //show error
            showAlert(withTitle: "Contact format incorrect", message: "Contact contains non-numeric")
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                //ERROR HANDLING
                if let validError = error {
                    self.showAlert(withTitle: "Error", message: validError.localizedDescription)
                }
                
                //HANDLE SUCESSFUL CREATION OF USER
                if let validUser = user {
                    self.usernameTextField.text = ""
                    self.emailTextField.text = ""
                    self.contactTextField.text = ""
                    self.passwordTextField.text = ""
                    self.confirmPasswordTextField.text = ""
                    
                    let userPost: [String:Any] = ["Username": userName, "Email": email, "Contact":contact]
                    
                    self.ref.child("Tuition Centre").child(validUser.uid).setValue(userPost)
                    let sb = UIStoryboard(name: "TCDetail", bundle: Bundle.main)
                    guard let navVC = sb.instantiateViewController(withIdentifier: "TTCNavigationController") as? UINavigationController else {return}
                    self.present(navVC, animated: true, completion: nil)
                    print("sign up method successful")
                }
            })
        }
    }    
}
