//
//  LoginViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 10/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login no Momentos"
        
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func loginDidTap() {
        
        if(emailTextField.text != "" && (passwordTextField.text?.count)! > 6){
            let email = emailTextField.text
            let password = passwordTextField.text
            
            Auth.auth().signIn(withEmail: email!, password: password!, completion: { (firUser, error) in
                if let error = error{
                    self.alert(title: "Opps!", message: error.localizedDescription, buttonTitle: "OK")
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }else{
            self.alert(title: "Momentos Login", message: "Oops...ocorreu um erro ao fazer login.\nVerifique seu email e senha.", buttonTitle: "OK")
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
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
            loginDidTap()
        }
        
        return true
    }
    
}
