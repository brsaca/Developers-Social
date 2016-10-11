//
//  FeedCell.swift
//  Developers Social
//
//  Created by brenda saavedra on 06/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configetCell(post:Post){
        self.post = post
        likesLbl.text = "\(self.post.likes)"
        captionText.text = self.post.caption
        
        
    }

}
