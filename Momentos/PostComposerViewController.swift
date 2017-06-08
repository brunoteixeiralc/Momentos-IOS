//
//  PostComposerViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 07/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class PostComposerViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareBarButtom:UIBarButtonItem!

    var image:UIImage!
    var imagePickerSourceType:UIImagePickerControllerSourceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        textView.text = ""
        textView.delegate = self
        
        shareBarButtom.isEnabled = false
        imageView.image = self.image
        

    }
    
    @IBAction func cancelDidTap() {
        
        self.image = nil
        imageView.image = nil
        textView.resignFirstResponder()
        textView.text = ""
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func shareDidTap(_ sender: Any) {
        
        if let image = image, let caption = textView.text{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
            let firstNavVC = tabBarController.viewControllers!.first as! UINavigationController
            let newsFeedTVC = firstNavVC.topViewController as! NewsFeedTableViewController
            if let currentUser = newsFeedTVC.currentUser {
               let newMedia = Media(type: "imagem", caption: caption, createdBy: currentUser, mediaImage: image)
               newMedia.save(completion: { (error) in
                if let error = error{
                        self.alert(title: "Oops!", message: error.localizedDescription, buttonTitle: "Ok")
                    }else{
                        currentUser.share(newMedia: newMedia)
                    }
               })
            }
        }
        
        self.cancelDidTap()
    }
    
    func alert(title:String,message:String,buttonTitle:String){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}

extension PostComposerViewController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        shareBarButtom.isEnabled = textView.text != ""
    }
    
}
