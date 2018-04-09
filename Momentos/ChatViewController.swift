//
//  ChatViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 16/07/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {

    var imagePickerHelper:ImagePickerHelper!
    
    var chat: Chat!
    var currentUser: User!
    
    var messagesRef = DatabaseRef.messages.ref()
    
    var messages = [Message]()
    var jsqMessages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!

    var userIsTypingRef = DatabaseRef.chats.ref()
    var localTyping = false
//    var isTyping: Bool {
//        get {
//            return localTyping
//        }
//        set {
//            localTyping = newValue
//            userIsTypingRef.setValue(newValue)
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //self.observeTyping()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.observeMessage()
        
        title = chat.title
        self.setupBubbleImages()
        self.setupAvatarImages()
        
        let backButtom = UIBarButtonItem(image: UIImage(named:"icon-back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButtom
        
    }
    
    func back(_ sender:UIBarButtonItem){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupBubbleImages(){
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
    }
    
    func setupAvatarImages(){
       collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
       collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
    }

}

extension ChatViewController{
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return jsqMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId{
            cell.textView?.textColor = UIColor.white
        }else{
            cell.textView?.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId{
            return outgoingBubbleImageView
        }else{
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
       // isTyping = textView.text != ""
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
           // self.profileImageView.image = image
           // self.profileImage = image
        })
    }
}

extension ChatViewController{
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        if chat.messageIds.count == 0{
            chat.save()
            
            for account in chat.users{
                account.save(new: chat)
            }
        }
        
        let newMessage = Message(senderUID: currentUser.uid, senderDisplayName: currentUser.fullName, type: MessageType.text, text: text)
        newMessage.save()
        chat.send(message: newMessage)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        
       // isTyping = false
    }
    
}

extension ChatViewController{
    
    func observeMessage(){
        let chatMessageIdsRef = chat.ref.child("messageIds")
        chatMessageIdsRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.value as! String
            DatabaseRef.messages.ref().child(messageId).observe(.value, with: { (snapshot) in
                let message = Message(dictionary: snapshot.value as! [String:Any])
                self.messages.append(message)
                self.add(message)
                self.finishReceivingMessage()
            })
            
        })
    }
    
    func add(_ message:Message){
        if message.type == MessageType.text{
            let jsqMessage = JSQMessage(senderId: message.senderUID, displayName: message.senderDisplayName, text: message.text)
            jsqMessages.append(jsqMessage!)
        }
    }
}

extension ChatViewController{

//    func observeTyping() {
//        let typingIndicatorRef = chat.ref.child("typingIndicator")
//        userIsTypingRef = typingIndicatorRef.child(senderId)
//        userIsTypingRef.onDisconnectRemoveValue()
//
//        let usersTypingQuery = chat.ref.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
//        usersTypingQuery.observe(.value, with: { (snapshot) in
//            if snapshot.childrenCount == 1 && self.isTyping {
//                return
//            }
//            self.showTypingIndicator = snapshot.childrenCount > 0
//            self.scrollToBottom(animated: true)
//        })
//    }
}
