//
//  PostTableViewController.swift
//  Cumulus
//
//  Created by Felix Hedlund on 2017-09-28.
//  Copyright © 2017 Jayway. All rights reserved.
//

import UIKit
import SDWebImage

class PostTableViewController: UITableViewController, PushHelperDelegate {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        refreshData()
        PushHelper.sharedInstance.delegate = self
    }
    
    func refreshPosts() {
        self.refreshData()
    }
    
    @objc func refreshData(){
        PostFetcher.fetchPosts(success: { (posts) in
            self.posts = posts
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }) {
            self.tableView.refreshControl?.endRefreshing()
            let alertVC = UIAlertController(title: "Failure", message: "Could not fetch posts", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let imageURL = post.getImageURL(){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithImage", for: indexPath)
            if let label = cell.viewWithTag(99) as? UILabel{
                label.text = post.getMessage()
            }
            if let imageView = cell.viewWithTag(88) as? UIImageView{
                imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "Cloud"))
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessagePost", for: indexPath)
            if let label = cell.viewWithTag(99) as? UILabel{
                label.text = post.getMessage()
            }
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
