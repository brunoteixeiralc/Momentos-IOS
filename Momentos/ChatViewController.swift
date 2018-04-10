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
    var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    var userIsTypingRef = DatabaseRef.chats.ref()
    var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.observeTyping()
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
        isTyping = textView.text != ""
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            if let chatImage = image{
                 self.sendImage(image: chatImage)
            }
        })
    }
}

extension ChatViewController{
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let newMessage = Message(senderUID: currentUser.uid, senderDisplayName: currentUser.fullName, type: MessageType.text, text: text)
        newMessage.save()
        chat.send(message: newMessage)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        
        isTyping = false
    }
    
    func sendImage(image:UIImage){
        let newMessage = Message(senderUID: currentUser.uid, senderDisplayName: currentUser.fullName, type: MessageType.image, text: "")
        newMessage.save()
        
        let firImage = FIRImage(image: image)
        firImage.saveChatImage(uid: newMessage.uid) { (error) in
           self.chat.sendImage(message: newMessage)
        }
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
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
                if message.type == MessageType.text{
                    self.add(message, mediaItem: nil)
                }else if message.type == MessageType.image{
                    if let senderId = message.senderUID as String?,let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: senderId == self.currentUser.uid){
                        FIRImage.downloadChatImage(uid: message.uid, completion: { (image, error) in
                           mediaItem.image = image
                           self.add(message, mediaItem: mediaItem)
                           self.photoMessageMap.removeValue(forKey: message.senderUID)
                        })
                    }
                }
                self.finishReceivingMessage()
            })
        })
    }
    
    func add(_ message:Message, mediaItem:JSQPhotoMediaItem?){
        if message.type == MessageType.text{
            let jsqMessage = JSQMessage(senderId: message.senderUID, displayName: message.senderDisplayName, text: message.text)
            jsqMessages.append(jsqMessage!)
        }else if message.type == MessageType.image{
            let jsqImage = JSQMessage(senderId: message.senderUID, displayName: "", media: mediaItem)
            jsqMessages.append(jsqImage!)
            
            if (mediaItem?.image == nil) {
                photoMessageMap[message.uid] = mediaItem
            }
            collectionView.reloadData()
        }
    }
}

extension ChatViewController{

    func observeTyping() {
        let typingIndicatorRef = chat.ref.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()

        let usersTypingQuery = chat.ref.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
        usersTypingQuery.observe(.value, with: { (snapshot) in
            if snapshot.childrenCount == 1 && self.isTyping {
                return
            }
            self.showTypingIndicator = snapshot.childrenCount > 0
            self.scrollToBottom(animated: true)
        })
    }
}
