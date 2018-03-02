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
//            collectionView.dataSource = self
            
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
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func observeUsers() {
        ref.child("Parent").childByAutoId().observe(.value) { (snapshot) in
            print("testing")
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        ref.child("Parent").childByAutoId().child("Student").queryOrdered(byChild: "Name").observe(.childAdded, with: { (snapshot) in
            
            guard let userDict = snapshot.value as? [String:Any] else {return}
//
//            let user =
//        }) { (<#Error#>) in
//            <#code#>
        }
        
        
        
        
    )}
    

   

}

extension ProfileViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

