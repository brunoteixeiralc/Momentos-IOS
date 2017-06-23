//
//  MediaDetailTableViewController.swift
//  Momentos
//
//  Created by Bruno Corrêa on 22/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

class MediaDetailTableViewController: UITableViewController {
    
    var media:Media!
    var currentUser:User!
    var comments = [Comments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Foto"
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = Storyboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        comments = media.comments
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaTableViewCell
            cell.currentUser = currentUser
            cell.media = media
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.commentCell, for: indexPath) as! CommentsTableViewCell
            cell.comment = comments[indexPath.row - 1]
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = media
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.mediaHeaderHeight
    }
}
