//
//  FeedVC.swift
//  Developers Social
//
//  Created by brenda saavedra on 06/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CircleView!
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString,UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        captionField.delegate = self
        
        DataService.instance.postsRef.observe(.value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts.removeAll()
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
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: IBAction
    @IBAction func signOutBtnPressed(_ sender: AnyObject) {
        AuthService.instance.signOut()
        performSegue(withIdentifier: SEGUE_SIGNINVC, sender: nil)
    }

    @IBAction func postBtnPressed(_ sender: AnyObject) {
        guard let caption = captionField.text, caption != "" else {
            print("BSC:: Caption must be entered")
            return
        }
        
        guard let img = addImage.image else {
            print("BSC:: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let snapName = "\(NSUUID().uuidString).jpg"
            let ref = DataService.instance.imagesStorageRef.child(snapName)
            
            _ = ref.put(imgData, metadata: nil, completion: { (meta:FIRStorageMetadata?, err:Error?) in
                if err != nil {
                    print("Error uploading snap: \(err?.localizedDescription)")
                }else{
                    let downloadURL = meta!.downloadURL()
                    DataService.instance.savePost(senderUID: FIRAuth.auth()!.currentUser!.uid, mediaURL: downloadURL!, caption: caption)
                }
            })
        }
    }
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated:true, completion:nil)
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FeedCell {
            let post = posts[indexPath.row]
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configetCell(post: post, img: img)
            }else{
                cell.configetCell(post: post)
            }
            return cell
        }
        return FeedCell()
    }
    
    //MARK: ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

}
