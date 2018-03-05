//
//  Student.swift
//  TuitionApp
//
//  Created by Terence Chua on 01/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import Foundation

class Student {
    var age : Int = 0
    var name : String = ""
    var subjects : [Subject] = []
    var results : String = ""
    var uid : String = ""
    var imageURL : String = ""
    var url : String = ""
    
    init(uid: String, dict: [String:Any]) {
        
        self.uid = uid
        self.name = dict["Name"] as? String ?? "No Name"
        self.url = dict["profilePicUrl"] as? String ?? "No Url"
   
    }


}
