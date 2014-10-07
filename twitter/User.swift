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
    var screenName: String!
    var profileImageUrl: NSURL?
    var tagLine: String?
    var dictionary:NSDictionary?
    var profileBannerUrl:String!
    var statusesCount:Int!
    var followersCount:Int!
    var friendsCount:Int!
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as String!
        profileBannerUrl = dictionary["profile_banner_url"] as String!
        profileImageUrl = NSURL(string: (dictionary["profile_image_url"] as String!))
        tagLine = dictionary["description"] as? String
        statusesCount = dictionary["statuses_count"] as? Int!
        followersCount = dictionary["followers_count"] as? Int!
        friendsCount = dictionary["friends_count"] as? Int!
    }
    
}
