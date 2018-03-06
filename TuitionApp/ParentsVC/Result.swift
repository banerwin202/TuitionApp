//
//  Result.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 03/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import Foundation

class Result {
    var uid : String = ""
    var score : Int = 0
    var testName : String = ""
    var Date : String = ""
    var scoreImageURL : String = ""
    var comment : String = ""
    
    init() {
        
    }
    
    init(uid: String, userDict: [String : Any]){
        self.uid = uid
        self.score = userDict["Score"] as? Int ?? 0
        self.testName = userDict["TestName"] as? String ?? "No Test"
        self.Date = userDict["Date"] as? String ?? "No Date"
        self.comment = userDict["Comment"] as? String ?? "Congratz~! Your kid did very well !!"
    }
    
    static var currentUser : Parent?
    
}
