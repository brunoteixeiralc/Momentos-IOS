//
//  MediaDetailTableViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 22/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

public struct DetailStoryboard {
    static let mediaHeaderHeight: CGFloat = 57
    static let mediaCellDefaultHeight: CGFloat = 535
    static let mediaCommentCellDefaultHeight: CGFloat = 100
    
    static let showMediaDetail = "ShowMediaDetailSegue"
    static let commentCell = "CommentCell"
    static let showCommentComposer = "ShowCommentComposer"
    static let mediaCell = "MediaCell"
    static let mediaHeaderCell = "MediaHeaderCell"

}

class MediaDetailTableViewController: UITableViewController {
    
    var media:Media!
    var currentUser:User!
    var comments = [Comments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comentários"
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = DetailStoryboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        comments = media.comments
        tableView.reloadData()
        
        self.fetchComments()
    }
    
    func fetchComments(){
        media.observeNewComment { (comment) in
            if !self.comments.contains(comment){
                self.comments.insert(comment, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func commentDidTap(){
        self.performSegue(withIdentifier: DetailStoryboard.showCommentComposer, sender: media)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DetailStoryboard.showCommentComposer{
            let commmentComposer = segue.destination as! CommentComposerViewController
            commmentComposer.media = media
            commmentComposer.currentUser = currentUser
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailStoryboard.mediaCell, for: indexPath) as! MediaDetailViewCell
            cell.currentUser = currentUser
            cell.media = media
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailStoryboard.commentCell, for: indexPath) as! CommentsTableViewCell
            cell.comment = comments[indexPath.row - 1]
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailStoryboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = media
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DetailStoryboard.mediaHeaderHeight
    }
    
}

