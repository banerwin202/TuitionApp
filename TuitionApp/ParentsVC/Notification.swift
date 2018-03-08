//
//  Notification.swift
//  TuitionApp
//
//  Created by Ban Er Win on 07/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import Foundation

class NotificationClass {
    var uid : String = ""
    var title : String = ""
    var text : String = ""
    
    init() {
        
    }

    init(uid : String, dict : [String:Any]) {
        self.uid = uid
        self.title = dict["title"] as? String ?? "No Title"
        self.text = dict["text"] as? String ?? "No Text"
    }
}



