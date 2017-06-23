//
//  WelcomeViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class WelcomeViewController: UIViewController {
    
    var email:String!
    var profileImage:String!
    
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
    
    func alert(title:String,message:String,buttonTitle:String){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func facebookLogin(){
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    self.alert(title: "Momentos Login", message: "Oops...erro ao entrar com o FB", buttonTitle: "OK")
                    return
                
                }else{
                    let newUser = User(uid: (user?.uid)!, userName: (user?.displayName?.removeWhitespace())!, fullName: (user?.displayName)!, bio: "", website: "", profileImage: nil, follows: [], followedBy: [])
                    newUser.save(completion: { (error) in
                        if error != nil{
                        }else{
                          self.dismiss(animated: true, completion: nil)
                        }
                    })

                }
                
            })
            
        }
        
    }
    
}

extension String {
  
    func removeWhitespace() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
