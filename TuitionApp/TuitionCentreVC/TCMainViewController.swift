//
//  TCMainViewController.swift
//  TuitionApp
//
//  Created by Terence Chua on 07/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import KYDrawerController

class TCMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.white
        let image = UIImage(named: "menu")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapOpenButton(_:)))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToStudentProfileVC(notification:)), name: NSNotification.Name(rawValue: "Navigate"), object: nil)
        
        
        
    }
    
    @objc func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @objc func goToStudentProfileVC(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo?["Name"] as? String else {return}
        
        if userInfo == "TCProfileViewController" {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: userInfo) as? TCProfileViewController else {return}
            navigationController?.pushViewController(vc, animated: true)
        } else if userInfo == "SendNotificationViewController" {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: userInfo) as? SendNotificationViewController else {return}
            navigationController?.pushViewController(vc, animated: true)
        } else if userInfo == "UploadResultViewController" {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: userInfo) as? UploadResultViewController else {return}
            navigationController?.pushViewController(vc, animated: true)
        } else if userInfo == "UploadSubjectViewController" {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: userInfo) as? UploadSubjectViewController else {return}
            navigationController?.pushViewController(vc, animated: true)
        } else if userInfo == "UploadScheduleViewController" {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: userInfo) as? UploadScheduleViewController else {return}
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}
