//
//  FeedVC.swift
//  Developers Social
//
//  Created by brenda saavedra on 06/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.postsRef.observe(.value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let post = Post.init(postKey: snap.key, postData: postDict )
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -IBAction
    @IBAction func signOutBtnPressed(_ sender: AnyObject) {
        AuthService.instance.signOut()
        performSegue(withIdentifier: SEGUE_SIGNINVC, sender: nil)
    }

    @IBAction func postBtnPressed(_ sender: AnyObject) {
    }
    
    //MARK: -TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FeedCell {
            cell.configetCell(post: posts[indexPath.row])
            return cell
        }
        return FeedCell()
    }
    
    
    

}
