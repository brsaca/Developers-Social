//
//  DataService.swift
//  Developers Social
//
//  Created by brenda saavedra on 06/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef:FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef:FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    var currentUserRef:FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = usersRef.child(uid!)
        return user        
    }
    
    var postsRef:FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_POSTS)
    }
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: FIR_URL_STORAGE)
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child(FIR_STORAGE_IMAGES)
    }
    
    func saveUser(uid: String, isLoginWithFB:Bool){
        let provider = isLoginWithFB ? "facebook.com" : "firebase"
        let userData: Dictionary<String, AnyObject> = [FIR_CHILD_USERS_PROVIDER: provider as AnyObject]
        usersRef.child(uid).updateChildValues(userData)
    }
    
    func savePost(senderUID:String, mediaURL:URL, caption: String){
        let pr: Dictionary<String, Any> = ["imageUrl":mediaURL.absoluteString,"likes": 0, "caption":caption]
        postsRef.childByAutoId().setValue(pr)
    }
    
    
    
    
}
