//
//  WelcomeViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true);
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if user != nil{
                self.dismiss(animated: false, completion: nil)
            }else{
                
            }
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
