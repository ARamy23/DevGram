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
    let postImageURL: String?
    let imageWidth: NSNumber?
    let imageHeight: NSNumber?
    let creationDate: String?
    let caption: String?
    
    init(_ dictionary: [String: Any])
    {
        postImageURL = dictionary["imageURL"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        creationDate = dictionary["creationDate"] as? String
        caption = dictionary["caption"] as? String
    }
}
