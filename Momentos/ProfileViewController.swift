//
//  ProfileViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 10/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextFields: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var followTextField: UITextField!
    @IBOutlet weak var followerTextField: UITextField!
    
    
    var currentUser:User!{
        didSet{
            if currentUser != nil{
                updateProfile()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateProfile(){
        
    }

    @IBAction func logOutDidTap(_ sender: Any) {
        try! Auth.auth().signOut()
        self.tabBarController?.selectedIndex = 0
    }
}
