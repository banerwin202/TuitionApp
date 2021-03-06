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
    var url : String = ""
    
    init() {
        
    }
    
    init(uid: String, dict: [String:Any]) {
        
        self.uid = uid
        self.name = dict["Name"] as? String ?? "No Name"
        self.url = dict["profilePicUrl"] as? String ?? "No Url"
   
        self.results = dict["result"] as? String ?? "No Result"
    }
    
    init(age: Int, name: String, studentImageURL: String, studentUID: String) {
        
        self.age = age
        self.name = name
        self.url = studentImageURL
        self.uid = studentUID
        
    }
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }

}
