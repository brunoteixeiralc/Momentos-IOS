//
//  NewsFeedTableViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableViewController: UITableViewController {

    struct Storyboard {
        static let showWelcome = "ShowWelcomeViewController"
        static let postComposerNVC = "PostComposerNavigationVC"
        
        static let mediaCell = "MediaCell"
        static let mediaHeaderCell = "MediaHeaderCell"
        static let mediaHeaderHeight: CGFloat = 57
        static let mediaCellDefaultHeight: CGFloat = 597
        
        static let showMediaDetail = "ShowMediaDetailSegue"
        
        static let commentCell = "CommentCell"
        static let showCommentComposer = "ShowCommentComposer"
    }
    
    var imagePickerHelper:ImagePickerHelper!
    var currentUser:User?
    var media = [Media]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if user != nil{
                DatabaseReference.user(uid: (user?.uid)!).ref().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String:Any]{
                        self.currentUser = User(dictionary: userDict)
                    }
                })
                
            }else{
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        })
        
        self.tabBarController?.delegate = self

        tableView.estimatedRowHeight = Storyboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        
        fetchMedia()
    } 
    
    func fetchMedia(){
        Media.observerMedia { (media) in
            if !self.media.contains(media){
                self.media.insert(media, at: 0)
                self.tableView.reloadData()
            }
        }
    }
}

extension NewsFeedTableViewController:UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let _ = viewController as? DummyPostComposerViewController{
            
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                
                let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.postComposerNVC) as! UINavigationController
                
                let postComposerVC = postComposerNVC.topViewController as! PostComposerViewController
                postComposerVC.image = image
                
                self.present(postComposerNVC, animated: true, completion: nil)
            })
            
            return false
        }
        
        return true
    }
}

extension NewsFeedTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return media.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if media.count == 0{
            return 0
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaTableViewCell
        
        cell.currentUser = currentUser
        cell.media = media[indexPath.section]
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = media[section]
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.mediaHeaderHeight
    }
}
