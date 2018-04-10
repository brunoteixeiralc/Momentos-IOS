//
//  InboxTableViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 16/07/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class InboxViewController: UITableViewController {
    
    struct Storyboard {
        static let chatCell = "ChatCell"
        static let showChatViewController = "ShowChatViewController"
    }
    
    var chats = [Chat]()
    var currentUser: User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Current user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
        let firstNavVC = tabBarController.viewControllers!.first as! UINavigationController
        let newsFeedController = firstNavVC.topViewController as! NewsFeedTableViewController
        currentUser = newsFeedController.currentUser
        
        chats.removeAll()
        fetchChat()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func fetchChat(){
        Chat.observerChat { (chat) in
            if self.currentUser != nil && chat.users.contains(self.currentUser){
                self.chats.insert(chat, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.chatCell, for: indexPath) as! ChatTableViewCell
        cell.chat = chats[indexPath.row] 
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showChatViewController{
            if let selectedIndex = tableView.indexPathForSelectedRow{
                let chat = chats[selectedIndex.row]
                let chatVC = segue.destination as! ChatViewController

                chatVC.senderId = currentUser.uid
                chatVC.senderDisplayName = currentUser.fullName
                chatVC.currentUser = self.currentUser

                chatVC.chat = chat
                chatVC.hidesBottomBarWhenPushed = true
            }
        }
    }
}
