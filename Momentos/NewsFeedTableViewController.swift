//
//  NewsFeedTableViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableViewController: UITableViewController {

    struct Storyboard {
        static let showWelcome = "ShowWelcomeViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if let user = user{
                
            }else{
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        })

    }
}
