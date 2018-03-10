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
    
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    var monthNumber : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadDate()
    }
    
    func loadDate() {
        
        let dict = ["01" : "January", "02" : "February", "03" : "March", "04" : "April", "05" : "May", "06" : "June", "07" : "July", "08" : "August", "09" : "September", "10" : "October", "11" : "November", "12" : "December"]
        
        guard let monthName = dict[selectedMonth] else {return}
        
        dateLabel.text = "\(selectedDate)" + monthName + "\(selectedYear)"
    }
    
    @objc func uploadEvent() {
        guard let eventType = eventTypeTextField.text,
            let subject = subjectTextField.text else {return}
        
        let ref = self.ref.child("Tuition").child("Event").childByAutoId()
        
        let newEvent : [String:Any] = ["Event Type" : eventType, "Subject" : subject, "Date" : dateStr, "Month" : selectedMonth]
        
        ref.setValue(newEvent)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
}
