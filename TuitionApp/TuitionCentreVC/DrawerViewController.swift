//
//  DrawerViewController.swift
//  TuitionApp
//
//  Created by Terence Chua on 07/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var pages : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages = ["Student Profile", "Set Notification", "Upload Result", "Upload Subject/Schedule"]
        
    }
    
}

extension DrawerViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.textLabel?.text = pages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var notification = Notification(name: Notification.Name(rawValue: ""))
        
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TCProfileViewController") as? TCProfileViewController else {return}
        
        let selectedPage = pages[indexPath.row]
        
        vc.selectedPage = selectedPage
        
        if selectedPage == "Student Profile" {
            notification = Notification(name: Notification.Name(rawValue: "Navigate"), object: nil, userInfo: ["Name":"TCProfileViewController"])
        } else if selectedPage == "Set Notification" {
            notification = Notification(name: Notification.Name(rawValue: "Navigate"), object: nil, userInfo: ["Name":"SendNotificationViewController"])
        } else if selectedPage == "Upload Result" {
            notification = Notification(name: Notification.Name(rawValue: "Navigate"), object: nil, userInfo: ["Name":"UploadResultViewController"]) 
        }
        NotificationCenter.default.post(notification)
        
    }
    
    
}


