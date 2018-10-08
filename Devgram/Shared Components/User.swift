//
//  User.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

struct User
{
    var uid: String?
    var username: String?
    var profileImageURL: URL?
    var email: String?
    
    init(uid: String?, _ dictionary: [String: Any])
    {
        self.username = dictionary["username"] as? String
        self.profileImageURL = (dictionary["profileImageURL"] as? String)?.url
        self.email = dictionary["email"] as? String
        self.uid = uid
    }
}