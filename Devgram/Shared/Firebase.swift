//
//  Firebase.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/29/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Firebase

final class FirebaseService
{
    static let databaseURL = Database.database().reference()
    static let databaseUsersRef = FirebaseService.databaseURL.child("users")
    static let storageRef = Storage.storage().reference()
    static let storageProfileImagesRef = FirebaseService.storageRef.child("profile_images")
    static let currentUserUID = Auth.auth().currentUser?.uid
}
