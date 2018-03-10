//
//  UploadSubjectViewController.swift
//  TuitionApp
//
//  Created by Terence Chua on 08/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UploadSubjectViewController: UIViewController {
    
    var ref : DatabaseReference!
    var subjects : [Subject] = []
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var addSubjectTextField: UITextField!

    @IBAction func addSubjectBtnTapped(_ sender: Any) {
        addSubject()
        
        showAlert(withTitle: "Congratulations!!", message: "You have successfully added the new subject!")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        observeSubjects()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    
    func observeSubjects() {
        ref.child("Tuition").child("Subject").queryOrdered(byChild: "Subject").observe(.childAdded) { (snapshot) in
            
//           guard let userDict = snapshot.value as? String else {return}
            
            let user = Subject(name: snapshot.key)
            
            DispatchQueue.main.async {
                self.subjects.append(user)
                let indexPath = IndexPath(row: self.subjects.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
            self.tableView.reloadData()
        }
        
    }

    func addSubject() {
        guard let addSubject = addSubjectTextField.text else {return}
        
        for subject in subjects {
            if subject.name == addSubject {
                showAlert(withTitle: "Error", message: "Subject is already added")
            } else {
                  self.ref.child("Tuition").child("Subject").child(addSubject).setValue(true)
            }
        }
    }
}

extension UploadSubjectViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "uploadSubjectCell", for: indexPath)
        
        cell.textLabel?.text = subjects[indexPath.row].name
        
        return cell
    }
}
