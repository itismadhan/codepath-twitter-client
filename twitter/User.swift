//
//  User.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/27/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var tagLine: String?
    var dictionary:NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = NSURL(string: (dictionary["profile_image_url"] as String!))
        tagLine = dictionary["description"] as? String
    }
    
}
