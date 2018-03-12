//
//  CreateEventViewController.swift
//  TuitionApp
//
//  Created by Terence Chua on 09/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.text = selectedDate + " " + selectedMonth + " " + selectedYear
        }
    }
    
    @IBOutlet weak var eventTypeTextField: UITextField!
    
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var addEventButton: UIButton! {
        didSet {
            addEventButton.addTarget(self, action: #selector(uploadEvent), for: .touchUpInside)
        }
    }
    
    var ref : DatabaseReference!
    
    var selectedDate : String = ""
    var selectedMonth : String = ""
    var selectedYear : String = ""
    
    var dateStr : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadDate()
    }
    
    func loadDate() {

        let dict = ["January" : "01", "February" : "02", "March" : "03", "April" : "04", "May" : "05", "June" : "06", "July" : "07", "August" : "08", "September" : "09", "October" : "10", "November" : "11", "December" : "12"]

        guard let monthNumber = dict[selectedMonth] else {return}

        dateStr = "\(selectedYear) \(monthNumber) \(selectedDate)"
    }
    
    @objc func uploadEvent() {
        guard let eventType = eventTypeTextField.text,
            let subject = subjectTextField.text else {return}
        
        let ref = self.ref.child("Tuition").child("Event").childByAutoId()
        
        let newEvent : [String:Any] = ["Event Type" : eventType, "Subject" : subject, "Date" : dateStr, "Month" : selectedMonth]
        
        if eventType != "" && subject != "" {
            ref.setValue(newEvent)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
}
