//
//  NotificationViewController.swift
//  TuitionApp
//
//  Created by Ban Er Win on 01/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
//            <#code#>
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

    

}
