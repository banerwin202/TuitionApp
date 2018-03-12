//
//  AttendanceViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 04/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AttendanceViewController: UIViewController {

    @IBOutlet weak var kidPickerView: UIPickerView!
    @IBOutlet weak var subjectPickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
//            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.rowHeight = 180
        }
    }
    
    var ref : DatabaseReference!
    var attend : [Attendance] = []
    var subject : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        subjectPickerView.dataSource = self
        subjectPickerView.delegate = self
        subjectPickerView.selectRow(0, inComponent: 0, animated: true)
        ref = Database.database().reference()
        
        observeSubject()
//        observeFirebase()

    }
    
    func observeSubject() {
        ref.child("Tuition").child("Student").child("STC-0001").child("Subjects").observe(.childAdded) { (snapshot) in
            
            let subjectObserved = snapshot.key
//            print("\(subjectObserved) is observed")
            self.subject.append(subjectObserved)
            print(self.subject)
            self.subjectPickerView.reloadComponent(0)
        }
    }
    
    func observeFirebase() {
//        let selectedIndex = self.subjectPickerView.selectedRow(inComponent: 0)
//        let selectedSubject = self.subject[selectedIndex]
//        print(selectedIndex)

//        ref.child("Attendance").child(selectedSubject).observe(.childAdded) { (snapshot) in
        ref.child("Attendance").observe(.childAdded) { (snapshot) in

            guard let attendanceDict = snapshot.value as? [String:Any] else {return}
            
//            for i in attendanceDict {
//                let date = i.key
//
//                guard let statusDict = i.value as? [String:Any] else {return}
//                for x in statusDict {
//                    guard let status = x.value as? Bool else {return}
//                    let attendance = Attendance(subject: snapshot.key, date: date, status: status )
//
//                    self.attend.append(attendance)
//
//                }
//
//            }
            
            DispatchQueue.main.async {
//                self.results.append(result)
//                let indexPath = IndexPath(row: self.results.count - 1, section: 0)
//                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addSubjectButtonTapped(_ sender: Any) {
        
        let selectedIndex = subjectPickerView.selectedRow(inComponent: 0)
        let selectedSubject = subject[selectedIndex]
        print(selectedSubject)
        
        ref.child("Attendance").child(selectedSubject).observe(.childAdded) { (snapshot) in
            
            guard let attendanceDict = snapshot.value as? [String:Any] else {return}
            
            for i in attendanceDict {
                    guard let status = i.value as? Bool else {return}
                    let attendance = Attendance(subject: selectedSubject, date: snapshot.key, status: status)
                    self.attend.append(attendance)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
}

extension AttendanceViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
//        subjectSelectedLabel.text = subject[row]
    }
}

extension AttendanceViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AttendanceTableViewCell", owner: self, options: nil)?.first as! AttendanceTableViewCell
        cell.subjectLabel.text = attend[indexPath.row].subject
        cell.attendanceDateLabel.text = attend[indexPath.row].date
        
        if String(attend[indexPath.row].status) == "true" {
            cell.attendLabel.text = "Attended"
        } else {
            cell.attendLabel.text = "Absent"
        }
        
        
        return cell
    }
}

