//
//  Account.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/26/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit
import Social
import Accounts


class TwitterClient: NSObject {
    var tweet:Tweet?
    var tweetsDelegate:TweetsDelegate?
    var retweetedTweetsDelegate:RetweetedTweetsDelegate?
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let accountStore = ACAccountStore()
    
    override init() {
        super.init()
        self.login()
        self.getTweets()
    }
    
    func login() -> Void {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (success, error) in
            if(success) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                let url = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                authRequest.account = accounts[0] as ACAccount
                
                let request = authRequest.preparedURLRequest()
                let task = self.urlSession.dataTaskWithRequest(request, completionHandler: {
                    (data, response, error) in
                    if error != nil {
                        println("Error in timeline")
                    } else {
                        let dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                        var user = User(dictionary: dict)
                        self.tweetsDelegate?.setUser(user)
                    }
                })
                task.resume()
            } else {
                println("Error \(error)")
            }
        }
    }
    
    func getTweets() -> Void {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (success, error) in
            if(success) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                authRequest.account = accounts[0] as ACAccount
                
                let request = authRequest.preparedURLRequest()
                let task = self.urlSession.dataTaskWithRequest(request, completionHandler: {
                    (data, response, error) in
                    if error != nil {
                        println("Error in timeline")
                    } else {
                        let array:[NSDictionary] = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as [NSDictionary]
                        var tweets = Tweet.tweetsWithArray(array)
                        self.tweetsDelegate?.setTweets(tweets)
                    }
                })
                task.resume()
            } else {
                println("Error \(error)")
            }
        }
    }
    
    func favoriteTweet(tweet:Tweet) -> Void {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (success, error) in
            if(success) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                var url:NSURL!
                if(tweet.favorited!) {
                    url = NSURL(string: "https://api.twitter.com/1.1/favorites/destroy.json?id=\(tweet.id)")
                } else {
                    url = NSURL(string: "https://api.twitter.com/1.1/favorites/create.json?id=\(tweet.id)")
                }
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
                authRequest.account = accounts[0] as ACAccount
                
                let request = authRequest.preparedURLRequest()
                let task = self.urlSession.dataTaskWithRequest(request, completionHandler: {
                    (data, response, error) in
                    if error != nil {
                        println("Favorite failed \(error)")
                    } else {
                        println(response)
                    }
                })
                task.resume()
            } else {
                println("Error \(error)")
            }
        }
    }
    
    func retweetTweet(tweet:Tweet) -> Void {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (success, error) in
            if(success) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                let url:NSURL = NSURL(string: "https://api.twitter.com/1.1/statuses/retweet/\(tweet.id).json")
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
                authRequest.account = accounts[0] as ACAccount
                
                let request = authRequest.preparedURLRequest()
                let task = self.urlSession.dataTaskWithRequest(request, completionHandler: {
                    (data, response, error) in
                    if error != nil {
                        println("Retweet failed \(error)")
                    } else {
                        let dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                        println(dict)
                        let retweetedStatusDict = dict["retweeted_status"] as NSDictionary
                        tweet.id = dict["id_str"] as String!
                        tweet.retweetedStatusID = retweetedStatusDict["id_str"] as String!
                        self.retweetedTweetsDelegate?.setTweetWithRetweetedDictionary(tweet)
                    }
                })
                task.resume()
            } else {
                println("Error \(error)")
            }
        }
    }
    
    func undoRetweet(tweet:Tweet) -> Void {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (success, error) in
            if(success) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                let url:NSURL = NSURL(string: "https://api.twitter.com/1.1/statuses/destroy/\(tweet.retweetedStatusID).json")
  
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
                authRequest.account = accounts[0] as ACAccount
                
                let request = authRequest.preparedURLRequest()
                let task = self.urlSession.dataTaskWithRequest(request, completionHandler: {
                    (data, response, error) in
                    if error != nil {
                        println("Retweet failed \(error)")
                    } else {
                        tweet.id = tweet.retweetedStatusID
                        println("Undo success \(tweet.retweetedStatusID)")
                        tweet.retweetedStatusID = nil
                        self.retweetedTweetsDelegate?.setTweetWithRetweetedDictionary(tweet)
                    }
                })
                task.resume()
            } else {
                println("Error \(error)")
            }
        }
    }
    
    func postTweet(tweet:String) -> Void {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (success, error) in
            if(success) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                let url:NSURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json?status=\(tweet)")
                
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
                authRequest.account = accounts[0] as ACAccount
                
                let request = authRequest.preparedURLRequest()
                let task = self.urlSession.dataTaskWithRequest(request, completionHandler: {
                    (data, response, error) in
                    if error != nil {
                        println("Retweet failed \(error)")
                    } else {
                        println("Tweet Posted")
                    }
                })
                task.resume()
            } else {
                println("Error \(error)")
            }
        }
    }
}
