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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logOutDidTap(_ sender: Any) {
        
        try! Auth.auth().signOut()
        self.tabBarController?.selectedIndex = 0
    }
}
