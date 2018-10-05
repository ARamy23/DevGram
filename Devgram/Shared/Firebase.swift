//
//  Firebase.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/29/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Firebase
import SVProgressHUD

final class FirebaseService
{
    static let databaseURL = Database.database().reference()
    static let databaseUsersRef = FirebaseService.databaseURL.child("users")
    static let databasePostsRef = FirebaseService.databaseURL.child("posts")
    static let databaseCurrentUserPostsRef = FirebaseService.databasePostsRef.child(FirebaseService.currentUserUID ?? "")
    static let databaseFollowingsRef = FirebaseService.databaseURL.child("following")
    static let databaseCommentsRef = FirebaseService.databaseURL.child("comments")
    static let databaseLikesRef = FirebaseService.databaseURL.child("likes")
    static let storageRef = Storage.storage().reference()
    static let storageProfileImagesRef = FirebaseService.storageRef.child("profile_images")
    static let storagePostsImagesRef = FirebaseService.storageRef.child("posts_images")
    static let currentUserUID = Auth.auth().currentUser?.uid
    static var currentUser: User?
    
    static func getCurrentUser(_ onCompletion: @escaping (User?) -> ())
    {
        print("fetching current user")
        guard let uid = FirebaseService.currentUserUID else { return }
        FirebaseService.databaseUsersRef.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            if let userDictionary = snapshot.value as? [String: Any]
            {
                let fetchedUser = User(uid: uid, userDictionary)
                FirebaseService.currentUser = fetchedUser
                onCompletion(fetchedUser)
            }
        }
    }
    
    static func getUser(with uid: String, _ onCompletion: @escaping (User?) -> ())
    {
        FirebaseService.databaseUsersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: Any]
            {
                let fetchedUser = User(uid: uid, userDictionary)
                onCompletion(fetchedUser)
            }
        }) { (err) in
            print(err)
            SVProgressHUD.showError(withStatus: err.localizedDescription)
        }
    }
}
