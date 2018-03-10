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

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
//            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.rowHeight = 180
        }
    }
    
    var ref : DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        observeFirebase()

    }
    
    func observeFirebase() {
        ref.child("Attendance").observe(.childAdded) { (snapshot) in
      
            guard let resultDict = snapshot.value as? [String:Any] else {return}
            let result = Result(uid: snapshot.key, userDict: resultDict)
            
            DispatchQueue.main.async {
//                self.results.append(result)
//                let indexPath = IndexPath(row: self.results.count - 1, section: 0)
//                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
}

extension AttendanceViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AttendanceTableViewCell", owner: self, options: nil)?.first as! AttendanceTableViewCell

        return cell
    }
}
