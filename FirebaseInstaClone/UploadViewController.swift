//
//  UploadViewController.swift
//  FirebaseInstaClone
//
//  Created by Taha Yasin Bike on 22.06.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRec)
    }
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media") // farklı isim yazsaydık kendisi gidip oluştururdu
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            imageReference.putData(data) { metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "error")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String:Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Erro!", messageInput: error?.localizedDescription ?? "error")
                                }else{
                                    self.imageView.image = UIImage(named: "selectImage")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0 //butonların sırası
                                }
                            })
                            
                        }
                    }
                }
            }
        }
    }
    
}
