//
//  AuthService.swift
//  Developers Social
//
//  Created by brenda saavedra on 05/10/16.
//  Copyright © 2016 bsc. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftKeychainWrapper

typealias Completion = (_ errMsg: String?, _ data:AnyObject?)-> Void

class AuthService{
    fileprivate static let _instance = AuthService()
    
    static var instance:AuthService{
        return _instance
    }
    
    func loginWithCredential(_ credential: FIRAuthCredential, onComplete:Completion?){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print ("loginWithCredential Error:: " + error.debugDescription)
                self.handleFirebaseError(error as! NSError, onComplete: onComplete)
            } else {
                print ("BSC:: successfully auth Firebase")
                self.saveUserInKeychain((user?.uid)!, isLoginWithFB: true)
                onComplete?(nil,user)
            }
        })
    }
    
    func loginWithEmail(_ email:String, password:String, onComplete:Completion?){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue:error!._code){
                    if errorCode == .errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.handleFirebaseError(error as! NSError, onComplete: onComplete)
                            }else{
                                if user?.uid != nil {
                                    //Sign in
                                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil{
                                            self.handleFirebaseError(error as! NSError, onComplete: onComplete)
                                        }else{
                                            self.saveUserInKeychain((user?.uid)!, isLoginWithFB: false)
                                            onComplete?(nil,user)
                                        }
                                    })
                                }
                            }
                        })
                    }
                }else{
                    self.handleFirebaseError(error as! NSError, onComplete: onComplete)
                }
            }else{
                //Successfully logged in
                onComplete?(nil,user)
            }
        })
    }
    
    func handleFirebaseError(_ error:NSError, onComplete:Completion?){
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error.code){
            switch errorCode {
                
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
                
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                break
                
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
                break
                
            default:
                onComplete?("There was a problem, try again", nil)
                break
            }
        }
    }
    
    func saveUserInKeychain(_ userID: String, isLoginWithFB: Bool){
        DataService.instance.saveUser(uid: userID, isLoginWithFB: isLoginWithFB)
         KeychainWrapper.standard.set(userID, forKey: KEY_UID)
    }
    
    func signOut(){
        try! FIRAuth.auth()?.signOut()
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
    }
    
}

