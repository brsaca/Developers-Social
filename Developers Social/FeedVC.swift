//
//  FeedVC.swift
//  Developers Social
//
//  Created by brenda saavedra on 06/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    

}
