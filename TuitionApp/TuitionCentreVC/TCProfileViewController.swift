//
//  TCProfileViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 06/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TCProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var ref : DatabaseReference!
    
    var students : [Student] = []
    
    var selectedPage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadDetails()

    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
        
    }
    
    func loadDetails() {
        ref.child("Tuition").child("Student").observe(.childAdded) { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any],
                let age = dict["Age"] as? Int,
                let name = dict["Name"] as? String,
                let studentImageURL = dict["Image"] as? String {
                
                let student = Student(age: age, name: name, studentImageURL: studentImageURL)
                
                DispatchQueue.main.async {
                    self.collectionView.performBatchUpdates({ 
                        self.students.append(student)
                        let indexPath = IndexPath(row: self.students.count - 1, section: 0)
                        self.collectionView.insertItems(at: [indexPath])
                        self.collectionView.reloadData()
                    }, completion: nil)
                }
            }
        }
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let image = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }

}

extension TCProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let borderColor : CGColor = UIColor.black.cgColor
        let borderWidth : CGFloat = 1
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TCProfileCollectionViewCell else {return UICollectionViewCell()}
        
        if let imageViewForCell = cell.profileImageView {
            let picURL = students[indexPath.row].url
            
            getImage(picURL, imageViewForCell)
        }
        
        cell.nameLabel.text = students[indexPath.row].name
        cell.ageLabel.text = String(students[indexPath.row].age)
        
        cell.layer.borderColor = borderColor
        cell.layer.borderWidth = borderWidth
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddSubjectViewController") as? AddSubjectViewController else {return}
        
        let selectedStudent = students[indexPath.row]
        
        vc.selectedStudent = selectedStudent
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
}
