//
//  UploadResultViewController.swift
//  TuitionApp
//
//  Created by Ban Er Win on 07/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UploadResultViewController: UIViewController {
    
    

    @IBOutlet weak var subjectPickerView: UIPickerView! {
        didSet {
           subjectPickerView.dataSource = self
           subjectPickerView.delegate = self
        }
    }
    @IBOutlet weak var testNameTextView: UITextField!
    @IBOutlet weak var testScoreTextView: UITextField!
    @IBOutlet weak var testDateTextView: UITextField!
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBAction func addSubjectBtnTapped(_ sender: Any) {
    }
    
    var ref: DatabaseReference!
    let subject = ["Mathematics","Chemistry","XCode","Physics","Moral"]
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func addSubject() {
        guard let testName = testNameTextView.text,
        let subjectLabel = subjectLabel.text,
        let testScore = testScoreTextView.text,
        let testDate = testDateTextView.text else {return}
        
        let userPost: [String:Any] = ["TestName" : testName, "Score" : testScore, "Date" : testDate]
        
//        self.ref.child(<#T##pathString: String##String#>)
    }
    
    

}

extension UploadResultViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subject.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subject[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectLabel.text = subject[row]
        index = row
    }
}
