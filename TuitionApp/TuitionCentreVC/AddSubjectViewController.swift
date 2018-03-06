//
//  AddSubjectViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 06/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddSubjectViewController: UIViewController {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var subjectPickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subjectSelectedLabel: UILabel!
    @IBOutlet weak var addSubjectButton: UIButton!
    
    let subject = ["Mathematics","Chemistry","XCode","Physics","Moral"]
    var index : Int = 0
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        subjectPickerView.dataSource = self
        subjectPickerView.delegate = self
        ref = Database.database().reference()

    }

    @IBAction func addSubjectButtonTapped(_ sender: Any) {
        
        let selectedIndex = subjectPickerView.selectedRow(inComponent: 0)
        let selectedSubject = subject[selectedIndex]
        print(selectedSubject)
        let userPost: [String:Any] = [selectedSubject: true]
        self.ref.child("Tuition").child("Student").child("StudentID").child("Subjects").updateChildValues(userPost)
    }
    
}

extension AddSubjectViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
        subjectSelectedLabel.text = subject[row]
        index = row
    }

}

extension AddSubjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel =
        return cell
    }
    
}
