//
//  PhoneAuthViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 28/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

class PhoneAuthViewController: UIViewController {

    @IBOutlet weak var phoneTextView: UITextField!
    @IBOutlet weak var tokenView: UIView!
    @IBOutlet weak var buttonAction: UIButton!
    
    @IBOutlet weak var code1TextView: UITextField!
    @IBOutlet weak var code2TextView: UITextField!
    @IBOutlet weak var code3TextView: UITextField!
    @IBOutlet weak var code4TextView: UITextField!
    @IBOutlet weak var code5TextView: UITextField!
    @IBOutlet weak var code6TextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //phoneTextView.text = ""
        phoneTextView.delegate = self
        phoneTextView.becomeFirstResponder()
        
        tokenView.isHidden = true
        
        code1TextView.delegate = self
        code2TextView.delegate = self
        code3TextView.delegate = self
        code4TextView.delegate = self
        code5TextView.delegate = self
        code6TextView.delegate = self

    }
    
    @IBAction func backDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func sendDidTap(){
        if let phone = phoneTextView.text{
            PhoneAuthProvider.provider().verifyPhoneNumber(phone) { (verificationID, error) in
                if let error = error {
                    print(error)
                    return
                }
                print(verificationID!)
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                
                self.tokenView.isHidden = false
                self.code1TextView.becomeFirstResponder()
                
            }
        }
    }
    
    func loginWithPhone(){
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let vericationCode = "\(String(describing: code1TextView.text!))\(String(describing: code2TextView.text!))\(String(describing: code3TextView.text!))\(String(describing: code4TextView.text!))\(String(describing: code5TextView.text!))\(String(describing: code6TextView.text!))"
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: vericationCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }else{
                self.dismiss(animated: true, completion: nil)
            }
          
        }
    }
}


extension PhoneAuthViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextView{
           phoneTextView.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField.text?.count == 1){
            if textField == code1TextView{
                code2TextView.becomeFirstResponder()
            }else if textField == code2TextView{
                code3TextView.becomeFirstResponder()
            }else if textField == code3TextView{
                code4TextView.becomeFirstResponder()
            }else if textField == code4TextView{
                code5TextView.becomeFirstResponder()
            }else if textField == code5TextView{
                code6TextView.becomeFirstResponder()
            }else if textField == code6TextView{
                code6TextView.resignFirstResponder()
                loginWithPhone()
            }
        }
        return true
    }
    
}
