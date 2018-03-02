//
//  Subject.swift
//  TuitionApp
//
//  Created by Terence Chua on 01/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import Foundation

class Subject {
    var name : String = ""
    var schedule : Schedule!
    
    init(name: String) {
        self.name = name
    }
}

class Schedule {
    var date : Int = 0
    var time : Int = 0
}
