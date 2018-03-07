//
//  NotificationViewController.swift
//  TuitionApp
//
//  Created by Ban Er Win on 01/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NotificationViewController: UIViewController {
    
    var ref : DatabaseReference!
    var notifications : [NotificationClass] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
        tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        observeNotification()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func observeNotification() {
        
        ref.child("Tuition").child("Notification").observe(.childAdded) { (snapshot) in
            
            guard let userDict = snapshot.value as? [String:Any] else {return}
            
            let user = NotificationClass(uid: snapshot.key, dict: userDict)
            
            DispatchQueue.main.async {
                self.notifications.append(user)
                let indexPath = IndexPath(row: self.notifications.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
            self.tableView.reloadData()
            
        }
    }

}

extension NotificationViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        
        cell.textLabel?.text = notifications[indexPath.row].title
        cell.detailTextLabel?.text = notifications[indexPath.row].text
        
        return cell
    }
    
    
}
