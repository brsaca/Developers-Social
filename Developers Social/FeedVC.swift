//
//  FeedVC.swift
//  Developers Social
//
//  Created by brenda saavedra on 06/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var captionField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell") as! FeedCell
    }
    
    
    

}
