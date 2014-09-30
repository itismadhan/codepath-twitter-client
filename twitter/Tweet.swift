//
//  Tweet.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/27/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id:String!
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount: Int?
    var favoriteCount: Int?
    var favorited:Bool?
    var retweeted:Bool?
    var retweetedStatusID:String!
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as String!
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = dictionary["retweet_count"] as Int!
        favoriteCount = dictionary["favorite_count"] as Int!
        favorited = dictionary["favorited"] as Bool!
        retweeted = dictionary["retweeted"] as Bool!
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        createdAtString = createdAt?.prettyTimestampSinceNow()
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
