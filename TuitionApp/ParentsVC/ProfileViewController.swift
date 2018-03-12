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
          collectionView.delegate = self
            
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
       
        //Set Background image
            let imageView = UIImageView()
            imageView.image = UIImage(named:"StudentStudying")
            imageView.contentMode = .scaleAspectFill
        
        self.collectionView?.backgroundView = imageView
        
   
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
    
    func renderImage(_ urlString: String, cellImageView: UIImageView) {
        
        guard let url = URL.init(string: urlString) else {return}
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let image = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    cellImageView.image = image
                }
            }
        }
        task.resume()
    }
    
}

extension ProfileViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
        
        let url = students[indexPath.row].url
        if let a = cell.imageView {
            renderImage(url, cellImageView: a)
        }
        
        cell.idLabel.text = students[indexPath.row].uid
        cell.nameLabel.text = students[indexPath.row].name
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        return cell
    }
}

extension ProfileViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "StudentViewController") as? StudentViewController else {return}
        
          let student = students[indexPath.row]
       
            vc.selectedStudent = student
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
    }
}

}
