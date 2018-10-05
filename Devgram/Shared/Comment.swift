//
//  Comment.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/5/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

struct Comment
{
    let user: User
    
    let text: String?
    let uid: String?
    
    init(_ user: User, _ dictionary: [String: Any])
    {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.user = user
    }
}
