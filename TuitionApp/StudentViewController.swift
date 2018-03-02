//
//  StudentViewController.swift
//  TuitionApp
//
//  Created by Ban Er Win on 02/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StudentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    
    var subjects : [Subject] = []
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        getSubjectName()
    }
    
    //SUBJECT NAMES
    func getSubjectName() {
        ref.child("Tuition").child("Student").child("StudentID").child("Subjects").observe(.value) { (snapshot) in
            
            self.subjects.removeAll()
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                
                let subjectName = Subject(name: key)
                
                self.subjects.append(subjectName)
            }
            self.tableView.reloadData()
        }
    }
    
}

extension StudentViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = subjects[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else {return}
        
        vc.selectedSubject = subjects[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}