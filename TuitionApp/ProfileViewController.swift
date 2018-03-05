//
//  ProfileViewController.swift
//  TuitionApp
//
//  Created by Ban Er Win on 01/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var ref : DatabaseReference!
    var students : [Student] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
          collectionView.dataSource = self
            
        }
    }
    @IBAction func logoutBtnTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
              dismiss(animated: true, completion: nil)
        } catch {
            
        }
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        observeUsers()
       
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func observeUsers() {
//        ref.child("Tuition").childByAutoId().observe(.value) { (snapshot) in
//
//            print("testing")
//        }
//
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
        
        let parent = Auth.auth().currentUser
        if let parent = parent {
            let parentID = parent.uid
            
        
        ref.child("Tuition").child("Parent").child(parentID).child("Student").observe(.childAdded, with: { (snapshot) in
            
            guard let userDict = snapshot.value as? [String:Any] else {return}

            let user = Student(uid: snapshot.key, dict: userDict)
            
            DispatchQueue.main.async {
                self.students.append(user)
                let indexPath = IndexPath(row: self.students.count - 1, section: 0)
                self.collectionView.insertItems(at: [indexPath])
                
            }
            
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
        self.collectionView.reloadData()
        
        }
    }
    

   

}

extension ProfileViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
        
        cell.idLabel.text = students[indexPath.row].uid
        cell.nameLabel.text = students[indexPath.row].name
        
        return cell
    }
}

