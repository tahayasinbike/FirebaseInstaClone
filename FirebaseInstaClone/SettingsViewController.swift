//
//  SettingsViewController.swift
//  FirebaseInstaClone
//
//  Created by Taha Yasin Bike on 22.06.2024.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("error")
        }
        
    }
    

}
