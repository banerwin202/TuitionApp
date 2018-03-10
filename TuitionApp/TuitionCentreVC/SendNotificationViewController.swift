//
//  SendNotificationViewController.swift
//  TuitionApp
//
//  Created by Ban Er Win on 06/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseDatabase
import FirebaseAuth



class SendNotificationViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var ref: DatabaseReference!
    
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = titleTextField.text ?? "No Title"
        content.body = textView.text
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        addNotification()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func addNotification() {
      guard let title = titleTextField.text,
        let text = textView.text else {return}
        
        let userPost: [String:Any] = ["Title" : title, "Text" : text]
        
        self.ref.child("Tuition").child("Notification").childByAutoId().setValue(userPost)
            
            
    }

 

}
