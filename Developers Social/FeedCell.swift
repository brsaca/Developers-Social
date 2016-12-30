//
//  FeedCell.swift
//  Developers Social
//
//  Created by brenda saavedra on 06/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    var likeRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likeBtn.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
    }

    func configetCell(post:Post, img: UIImage? = nil){
        self.post = post
        likeRef = DataService.instance.currentUserRef.child("likes").child(post.postKey)
        likesLbl.text = "\(self.post.likes)"
        captionText.text = self.post.caption
        
        if img != nil {
            postImg.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion:{(data, error) in
                if error != nil {
                    print("Error:: Unable to download image from firebase")
                }else{
                    print("BSC:: Downloaded image from firebase")
                    if let imgData = data {
                        if let img = UIImage(data:imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeBtn.setImage(UIImage(named:"empty-heart"), for: .normal)
            }else{
                self.likeBtn.setImage(UIImage(named:"filled-heart"), for: .normal)
            }
        })
        
    }
    
    func likeTapped(){
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeBtn.setImage(UIImage(named:"filled-heart"), for: .normal)
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            }else{
                self.likeBtn.setImage(UIImage(named:"empty-heart"), for: .normal)
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }

    
}
