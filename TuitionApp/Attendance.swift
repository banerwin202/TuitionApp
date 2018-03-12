//
//  Attendance.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 10/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import Foundation

class Attendance {
    var uid : String = ""
    var StudentID : String = ""
    var date : String = ""
    var subject : String = ""
    var status : Bool = true
    
    init() {
        
    }
    
    init(subject: String, date: String , userDict: [String : Any]){
        self.subject = subject
//        self.uid = userDict["uid"] as? String ?? "No uid"
        self.StudentID = userDict["StudentID"] as? String ?? "no come eh"
        self.date = date
    }
    
    init(subject: String, date: String , status: Bool){
        self.subject = subject
        self.date = date
        self.status = status
    }
    
    static var currentUser : Parent?
}
