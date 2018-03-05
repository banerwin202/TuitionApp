//
//  StudentSignUpViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 05/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class StudentSignUpViewController: UIViewController {
    
    var ref : DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    @IBAction func logoutBtnTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
        
    }

}
