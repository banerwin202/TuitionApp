//
//  StudentSignUpViewController.swift
//  TuitionApp
//
//  Created by Lih Heng Yew on 05/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class StudentSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var studentImageView: UIImageView! {
        didSet {
            studentImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(findImageButtonTapped))
            studentImageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var studentAgeTextField: UITextField!
    @IBOutlet weak var studentIDTextField: UITextField!
//    @IBOutlet weak var subjectPickerView: UIPickerView!
//    @IBOutlet weak var subjectSelected: UILabel!
    
    var ref : DatabaseReference!
    let imagePicker = UIImagePickerController()
//    let subject = ["Mathematics","Chemistry","XCode","Physics","Moral"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
//        subjectPickerView.dataSource = self
//        subjectPickerView.delegate = self
//        createAlertView()
        ref = Database.database().reference()
    }

    @IBAction func createStudentButtonTapped(_ sender: Any) {
        signUpUser()
    }
    

    
    
    @objc func findImageButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func signUpUser() {
        guard let studentName = studentNameTextField.text,
            let studentID = studentIDTextField.text,
            let studentAge = studentAgeTextField.text else {return}
        
        if let image = self.studentImageView.image {
            self.uploadToStorage(image)
        }
        
        let newStudent : [String : Any] = ["StudentName" : studentName, "StudentAge" : studentAge]
        
        self.ref.child("Tuition").child("Student").child(studentID).setValue(newStudent)
        
//        let sb = UIStoryboard(name: "DetailsStoryboard", bundle: Bundle.main)
//        guard let vc = sb.instantiateViewController(withIdentifier: "navigationController") as? UITabBarController else {return}
//        self.navigationController?.popViewController(animated: false)
//        self.present(vc, animated: false, completion: nil)
        
    }

    func uploadToStorage(_ image: UIImage) {
        let storageRef = Storage.storage().reference()
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        guard let studentID = studentIDTextField.text else {return}

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.child(studentID).child("profilePic").putData(imageData, metadata: metaData) { (meta, error) in
            
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let downloadURL = meta?.downloadURL()?.absoluteString {
                self.ref.child("Tuition").child("Student").child(studentID).child("StudentPicURL").setValue(downloadURL)
            }
        }
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            studentImageView.contentMode = .scaleAspectFit
            studentImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
//    func createAlertView() {
//
//        let alertView = UIAlertController(title: "hello", message: "hi", preferredStyle: UIAlertControllerStyle.alert)
//
////        subjectPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 60))
//        subjectPickerView.dataSource = self
//        subjectPickerView.delegate = self
//
//        alertView.view.addSubview(subjectPickerView!)
//
//        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
//
//        alertView.addAction(action)
//        present(alertView, animated: true, completion: nil)
//
//
//
//        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .actionSheet)
//        alert.isModalInPopover = true
//
//        //  Create a frame (placeholder/wrapper) for the picker and then create the picker
//        let pickerFrame = CGRect(x: 17, y: 52, width: 270, height: 100) // CGRectMake(left), top, width, height) - left and top are like margins
//        let picker = UIPickerView(frame: pickerFrame)
//
//        //  set the pickers datasource and delegate
//        picker.delegate = self
//        picker.dataSource = self
//
//        //  Add the picker to the alert controller
//        alert.view.addSubview(picker)
//
//    }


}

//extension StudentSignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return subject.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return subject[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        subjectSelected.text = subject[row]
//    }
//
//}

