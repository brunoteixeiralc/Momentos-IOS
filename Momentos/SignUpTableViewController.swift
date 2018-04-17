//
//  SignUpTableViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextFields: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var imagePickerHelper:ImagePickerHelper!
    var profileImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Criar nova conta"
        
        //round images
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2.0
        profileImageView.layer.masksToBounds = true
        
        emailTextField.delegate = self
        fullNameTextFields.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    @IBAction func createNewAccountDidTap() {
        
        if emailTextField.text != ""
            && (passwordTextField.text?.count)! > 6
            && (usernameTextField.text?.count)! > 6
            && fullNameTextFields.text != ""{
            
            let email = emailTextField.text!
            let password = passwordTextField.text!
            let username = usernameTextField.text!
            let fullname = fullNameTextFields.text!
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (firuser, error) in
                if(error != nil){
                    self.alert(title: "Momentos Login", message: (error?.localizedDescription)!, buttonTitle: "OK")
                
                }else if let firuser = firuser{
                    
                    let newUser = User(uid: firuser.uid, userName: username, fullName: fullname, bio: "", website: "", profileImage: self.profileImage, follows: [], followedBy: [])
                    newUser.save(completion: { (error) in
                        if error != nil{
                            self.alert(title: "Momentos Login", message: (error?.localizedDescription)!, buttonTitle: "OK")
                        }else{
                            Auth.auth().signIn(withEmail: email, password: password, completion: { (firuser, error) in
                                if error != nil{
                                   self.alert(title: "Momentos Login", message: (error?.localizedDescription)!, buttonTitle: "OK")
                                }else{
                                   self.dismiss(animated: true, completion: nil)
                                }
                            })
                            
                        }
                    })
                }
            })
            
        }else{
            self.alert(title: "Momentos", message: "Oops...ocorreu um erro ao se cadastrar. Todos os campos são obrigatórios.", buttonTitle: "OK")
        }
    }
    
    func alert(title:String,message:String,buttonTitle:String){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func backDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func changeProfilePhotoDidTap(_ sender: Any) {
        
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
        
    }
}

extension SignUpTableViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            fullNameTextFields.becomeFirstResponder()
        }else if textField == fullNameTextFields{
            usernameTextField.becomeFirstResponder()
        }else if textField == usernameTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
            createNewAccountDidTap()
        }
        
        return true
    }
}
