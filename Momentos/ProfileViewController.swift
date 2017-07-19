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
    
    var currentUser:User!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Current user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
        let firstNavVC = tabBarController.viewControllers!.first as! UINavigationController
        let newsFeedController = firstNavVC.topViewController as! NewsFeedTableViewController
        currentUser = newsFeedController.currentUser
        
        fullNameTextFields.text = currentUser.fullName
        usernameTextField.text = currentUser.userName
        followTextField.text = "\(String(currentUser.follows.count)) amigos"
        followerTextField.text = "\(String(currentUser.followedBy.count)) usuários te seguem"
        currentUser.downloadProfilePicture(completion: { (image, error) in
            self.profileImageView.image = image
            self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2.0
            self.profileImageView.layer.masksToBounds = true
        })
        
    }

    @IBAction func logOutDidTap(_ sender: Any) {
        try! Auth.auth().signOut()
        self.tabBarController?.selectedIndex = 0
    }
}
