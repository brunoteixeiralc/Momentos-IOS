//
//  CommentComposerViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 26/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class CommentComposerViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var usernameLabel: UIButton!
    @IBOutlet weak var postBarButtomItem: UIBarButtonItem!
    
    var currentUser: User!
    var media:Media!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = postBarButtomItem
        navigationItem.title = "Novo comentário"
        
        postBarButtomItem.isEnabled  = false
        captionTextView.text = ""
        captionTextView.becomeFirstResponder()
        captionTextView.delegate = self
        
        if currentUser.profileImage == nil{
            profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
            currentUser.downloadProfilePicture(completion: { (image, error) in
                if(error == nil){
                   self.profileImageView.image = image
                }
                
            })
        }else{
            profileImageView.image = currentUser.profileImage
        }
        
        usernameLabel.setTitle(currentUser.userName, for: [])
        
    }
    
    @IBAction func postDidTap(){
        
        let comment = Comments(mediaUid: media.uid, from: currentUser, caption: captionTextView.text)
        comment.save()
        media.comments.append(comment)
        
        self.navigationController?.popViewController(animated: true)
        
    }
}

extension CommentComposerViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""{
            postBarButtomItem.isEnabled = false
        }else{
            postBarButtomItem.isEnabled = true
        }
    }
}
 
