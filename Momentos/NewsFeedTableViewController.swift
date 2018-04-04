//
//  NewsFeedTableViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

public struct NewsFeedStoryboard {
    static let mediaHeaderHeight: CGFloat = 57
    static let mediaCellDefaultHeight: CGFloat = 597
    
    static let showWelcome = "ShowWelcomeViewController"
    static let postComposerNVC = "PostComposerNavigationVC"
    static let mediaCell = "MediaCell"
    static let mediaHeaderCell = "MediaHeaderCell"
    static let showMediaDetail = "ShowMediaDetailSegue"
    static let commentCell = "CommentCell"
    static let showCommentComposer = "ShowCommentComposer"
}

class NewsFeedTableViewController: UITableViewController{
    
    var imagePickerHelper:ImagePickerHelper!
    var currentUser:User?
    var media = [Media]()
    private var task: URLSessionDataTask?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: view)

        }
        
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil{
                DatabaseRef.user(uid: (user?.uid)!).ref().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String:Any]{
                        self.currentUser = User(dictionary: userDict)
                    }
                })
                
            }else{
                self.performSegue(withIdentifier: NewsFeedStoryboard.showWelcome, sender: nil)
            }
        })
        
        self.tabBarController?.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshOptions), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando...")
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        tableView.estimatedRowHeight = NewsFeedStoryboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        tableView.prefetchDataSource = self
        
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
    
    func downloadMediaImage(forItemAtIndex index: Int){
      media[index].downloadMediaImage { (image, error) in
            if error == nil{
                self.media[index].mediaImage = image
            }
        }
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        fetchMedia()
        sender.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == NewsFeedStoryboard.showMediaDetail{
            let mediaDetailTVC = segue.destination as! MediaDetailTableViewController
            //if let selectedIndex = tableView.indexPathForSelectedRow{
                mediaDetailTVC.currentUser = currentUser!
                //mediaDetailTVC.media = media[selectedIndex.section]
                mediaDetailTVC.media = sender as! Media
           // }
        }else if segue.identifier == NewsFeedStoryboard.showCommentComposer{
            let commentComposer = segue.destination as! CommentComposerViewController
            let selectedMedia = sender as! Media
            commentComposer.currentUser = currentUser
            commentComposer.media = selectedMedia
        }
    }
}

extension NewsFeedTableViewController:UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let _ = viewController as? DummyPostComposerViewController{
            
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                
                let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NewsFeedStoryboard.postComposerNVC) as! UINavigationController
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedStoryboard.mediaCell, for: indexPath) as! MediaNewsFeedViewCell
        
        cell.currentUser = currentUser
        cell.media = media[indexPath.section]
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedStoryboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = media[section]
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsFeedStoryboard.mediaHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: Storyboard.showMediaDetail, sender: nil)
    }

}

extension NewsFeedTableViewController:MediaNewsFeedViewCellDelegate{
    
    func commentDidTap(media: Media) {
        self.performSegue(withIdentifier: NewsFeedStoryboard.showCommentComposer, sender: media)

    }
    
    func seeCommentDidTap(media: Media) {
         self.performSegue(withIdentifier: NewsFeedStoryboard.showMediaDetail, sender: media)
    }
}

//Force Touch in the newsFeedImage
extension NewsFeedTableViewController:UIViewControllerPreviewingDelegate{
  
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = tableView?.indexPathForRow(at: location)
        let cell = tableView?.cellForRow(at: indexPath!)
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "MediaDetailTableViewController") as? MediaDetailTableViewController
        
        detailVC?.currentUser = currentUser!
        detailVC?.media = media[(indexPath?.section)!]
        detailVC?.preferredContentSize = CGSize(width: 0.0, height: 375)
        
        previewingContext.sourceRect = (cell?.frame)!
        
        return detailVC
    }
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

extension NewsFeedTableViewController:UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { self.downloadMediaImage(forItemAtIndex: $0.section) }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }
}

