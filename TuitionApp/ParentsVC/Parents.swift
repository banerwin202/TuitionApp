//
//  Parents.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 02/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import Foundation

class Parent {
    var uid : String = ""
    var email : String = ""
    var username : String = ""
    var contact : String = ""
    
    init() {
        
    }
    
    init(uid: String, userDict: [String : Any]){
        self.uid = uid
        self.email = userDict["email"] as? String ?? "No email"
        self.username = userDict["username"] as? String ?? "No username"
        self.contact = userDict["contact"] as? String ?? "No contact"
    }
    
    static var currentUser : Parent?
    
}
