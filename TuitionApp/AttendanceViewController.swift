//
//  AttendanceViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 04/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
//            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.rowHeight = 180
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
