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
    
//    let subject = ["Mathematics","Chemistry","XCode","Physics","Moral"]
    var subject : [String] = []
    var index : Int = 0
    var ref: DatabaseReference!
    var selectedStudent : Student = Student()
    var subjects : [Subject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        subjectPickerView.dataSource = self
        subjectPickerView.delegate = self
        ref = Database.database().reference()
        
        studentNameLabel.text = selectedStudent.name
        
        observeSubject()
        observeFirebase()
    }

    @IBAction func addSubjectButtonTapped(_ sender: Any) {
        
        let selectedIndex = subjectPickerView.selectedRow(inComponent: 0)
        let selectedSubject = subject[selectedIndex]
        print(selectedSubject)
        
        let userPost: [String:Any] = [selectedSubject: true]
        let userPost2: [String:Any] = [selectedStudent.uid: selectedStudent.name]
        self.ref.child("Tuition").child("Student").child(selectedStudent.uid).child("Subjects").updateChildValues(userPost)
        self.ref.child("Tuition").child("Subject").child(selectedSubject).child("Students").updateChildValues(userPost2)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func observeSubject() {
        ref.child("Tuition").child("Subject").observe(.childAdded) { (snapshot) in
            let subjectObserved = snapshot.key
            print("\(subjectObserved) is observed")
            self.subject.append(subjectObserved)
            print(self.subject)
            self.subjectPickerView.reloadComponent(0)
        }
    }
    
    func observeFirebase() {
        ref.child("Tuition").child("Student").child(selectedStudent.uid).child("Subjects").observe(.childAdded) { (snapshot) in
            
            let subject = Subject(name: snapshot.key)
            self.subjects.append(subject)
            let indexPath = IndexPath(row: self.subjects.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
//            if let subjectDict = snapshot.value as? [String:Any] {
//                let subjectKey = subjectDict.keys
//
//                for sub in subjectKey {
//                    let subject = Subject(name: sub)
//                    self.subjects.append(subject)
//                    let indexPath = IndexPath(row: self.subjects.count - 1, section: 0)
//                    self.tableView.insertRows(at: [indexPath], with: .automatic)
//                    print(self.subjects)
//                }
//                self.tableView.reloadData()
//            }
        }
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
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = subjects[indexPath.row].name
        
        return cell
    }
    
}
