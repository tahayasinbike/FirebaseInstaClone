//
//  FeedCell.swift
//  FirebaseInstaClone
//
//  Created by Taha Yasin Bike on 22.06.2024.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {

    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
            
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true) // merge sadece istediğimiz şeyi değiştir diyor üstüne yazıyor mesela likı verdik sadece diğerlerini vermedik ve likeı güncelledik
        }
            
        
        
    }
    
}
