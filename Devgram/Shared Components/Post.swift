//
//  Post.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/2/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

struct Post
{
    var id: String?
    
    let postImageURL: String?
    let imageWidth: NSNumber?
    let imageHeight: NSNumber?
    let creationDate: Date?
    let caption: String?
    let user: User?
    
    var hasLiked: Bool = false
    
    init(user: User?, _ dictionary: [String: Any])
    {
        postImageURL = dictionary["imageURL"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        creationDate = Date(timeIntervalSince1970:(dictionary["creationDate"] as? Double ?? 0))
        caption = dictionary["caption"] as? String
        self.user = user
    }
}
