//
//  Post.swift
//  Developers Social
//
//  Created by brenda saavedra on 11/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }

    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int){
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData:Dictionary<String, AnyObject>){
        self._postKey = postKey
        
        if let caption = postData[POST_CAPTION] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData[POST_IMAGEURL] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData[POST_LIKES] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.instance.postsRef.child(_postKey)
    }
    
    func adjustLikes(addLike:Bool){
        if addLike {
            _likes = _likes + 1
        }else{
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
