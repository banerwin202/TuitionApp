//
//  ResultsViewController.swift
//  TuitionApp
//
//  Created by Ban Er Win on 01/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var subJectLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
//            tableView.rowHeight = tableView.frame.height
//            tableView.rowHeight = 180
            tableView.rowHeight = UITableViewAutomaticDimension
//            tableView.estimatedRowHeight = 165
            
        }
    }
    
    var selectedSubject : Subject = Subject()
    var selectedStudent : Student = Student()
    var results : [Result] = []
  

    var ref : DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        subJectLabel.text = selectedSubject.name
        ref = Database.database().reference()
        observeFirebase()
    }
    
    func observeFirebase() {
        let a = ref.child("Tuition").child("Result").child(selectedSubject.name).child(selectedStudent.uid)
        print("\(a) is student IDDDDD")
        
        ref.child("Tuition").child("Result").child(selectedSubject.name).child(selectedStudent.uid).observe(.childAdded) { (snapshot) in
//            if snapshot.hasChild("UID") {
//
//            } else {
//
//            }
            print("\(self.selectedStudent.uid) is student ID222222")
            print("\(self.selectedSubject.name) is subjectName ID222222")

            guard let resultDict = snapshot.value as? [String:Any] else {return}
            let result = Result(uid: snapshot.key, userDict: resultDict)
            
            DispatchQueue.main.async {
                self.results.append(result)
                let indexPath = IndexPath(row: self.results.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
//    func observeFirebase(withcompletion completion:@escaping ([String:Any]) -> Void) {
//        //take the subject from terrance at .child("Maths")
//        let subjectResult = ref.child("Tuition").child("Student").child("StudentID").child("Subjects").observe(.value) { (snapshot) in
//
//            guard let dict = snapshot.value as? [String:Any] else {return}
//
//            completion(dict)
//
//        }

//
////        print("heheheh \(math) hellllllll yapyoyokb")
//
//        ref.child("Tuition").child("Result").observe(.childAdded) { (snapshot) in
//
//            guard let resultDict = snapshot.value as? [String:Any] else {return}
//            let result = Result(uid: snapshot.key, userDict: resultDict)
//
//            DispatchQueue.main.async {
//                self.results.append(result)
//                let indexPath = IndexPath(row: self.results.count - 1, section: 0)
//                self.tableView.insertRows(at: [indexPath], with: .automatic)
//            }
//
////            print(snapshot.key)
////            print("testing")
//        }
//    }
    
}

extension ResultsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ResultTableViewCell", owner: self, options: nil)?.first as! ResultTableViewCell
        let result = results[indexPath.row]

        if result.score < 50 {
            print("fail")
            cell.resultImage.image = UIImage(named: "fail")
        } else if result.score < 70 {
            cell.resultImage.image = UIImage(named:"B")

            print("you get B only")
        } else {
            cell.resultImage.image = UIImage(named:"A")

            print("You get A !!!!")
        }
        
        cell.scoreLabel.text = String(result.score)
        cell.testDateLabel.text = result.Date
        cell.TestLabel.text = result.testName
        cell.commentTextView.text = result.comment
        return cell
    }

    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        self.tableView.estimatedRowHeight = 80
//        return UITableViewAutomaticDimension
//    }
}


