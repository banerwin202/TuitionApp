//
//  TCTakeAttendanceViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 07/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class TCTakeAttendanceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subjectPickerTextField: UITextField!{
        didSet{
            subjectPickerTextField.layer.borderColor = UIColor.blue.cgColor
            subjectPickerTextField.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var datePickerTextField: UITextField! {
        didSet{
            datePickerTextField.layer.borderColor = UIColor.red.cgColor
            datePickerTextField.layer.borderWidth = 0.5
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        
        observeStudent()
    }
    
    @IBAction func attendButtonTapped(_ sender: Any) {
        takeAttendance(true)
    }
    
    @IBAction func absentButtonTapped(_ sender: Any) {
        takeAttendance(false)
    }
    
    let datePicker = UIDatePicker()
    let subjectPickerView = UIPickerView()
    var ref: DatabaseReference!
    var students : [Student] = []
    var subjects : [Subject] = []
    var subject : [String] = []
    var studentName = ""
    var selectedStudents : [Student] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        subjectPickerView.dataSource = self
        subjectPickerView.delegate = self
        ref = Database.database().reference()

        showDatePicker()
        observeSubject()
        showSubjectPicker()
    }
    
    func takeAttendance(_ attend: Bool) {
        for i in selectedStudents {
            let selectedIndex = subjectPickerView.selectedRow(inComponent: 0)
            let selectedSubject = subject[selectedIndex]
            let userPost : [String:Any] = [i.name : attend]
            
            if let selectDate = datePickerTextField.text,
                selectDate != "" {
                self.ref.child("Attendance").child(selectedSubject).child(selectDate).child("Students Attended").child(i.uid).updateChildValues(userPost)
            } else {
                print("please enter date")
                showAlert(withTitle: "Invalid Date", message: "Please input valid Date")
            }
            
        }
    }
    
    func observeStudent() {
        let selectedIndex = subjectPickerView.selectedRow(inComponent: 0)
        let selectedSubject = subject[selectedIndex]

        ref.child("Tuition").child("Subject").child(selectedSubject).observeSingleEvent(of: .childAdded) { (snapshot) in

            guard let dict = snapshot.value as? [String:Any] else {return}
            self.students.removeAll()
            for dictName in dict {
                
                self.studentName = dictName.value as! String 
                
                let student = Student(uid: dictName.key, name: self.studentName)
                
                self.students.append(student)

//                if dictName.key == "Name" {
//                    print(dictName.value)
//                    self.studentName = dictName.value as! String
//                    let student = Student(uid: snapshot.key, name: self.studentName)
//                    self.students.append(student)
//                    let indexPath = IndexPath(row: self.students.count - 1, section: 0)
//                    self.tableView.insertRows(at: [indexPath], with: .automatic)
//                }
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func showSubjectPicker(){
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        subjectPickerTextField.inputAccessoryView = toolbar
        subjectPickerTextField.inputView = subjectPickerView
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        datePickerTextField.inputAccessoryView = toolbar
        datePickerTextField.inputView = datePicker
    }
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        datePickerTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func observeSubject() {
        ref.child("Tuition").child("Subject").observe(.childAdded) { (snapshot) in
            let subjectObserved = snapshot.key
            print("\(subjectObserved) is observedddd")
            self.subject.append(subjectObserved)
            print(self.subject)
            self.subjectPickerView.reloadComponent(0)
        }
    }

}

extension TCTakeAttendanceViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
        subjectPickerTextField.text = subject[row]
//        index = row
    }
}

extension TCTakeAttendanceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TCAttendanceTableViewCell else {return UITableViewCell()}

        cell.textLabel?.text = students[indexPath.row].name
        cell.detailTextLabel?.text = students[indexPath.row].uid

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let targetStudent = students[indexPath.row]
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            if let index = selectedStudents.index(where: { (stu) -> Bool in
                stu.uid == targetStudent.uid
            }) {
                selectedStudents.remove(at: index)
            }
            
        } else {
            cell?.accessoryType = .checkmark
            selectedStudents.append(targetStudent)
        }
    }
    
    
}
