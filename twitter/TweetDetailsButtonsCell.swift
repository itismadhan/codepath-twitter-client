//
//  TweetDetailsButtonsCell.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/29/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

struct TwitterButtonImage {
    static var FavoriteDefaultImage = UIImage(named: "twitter-favorite-default-state")
    static var FavoriteOnImage = UIImage(named: "twitter-favorite-icon-on-state")
    static var RetweetedDefaultImage = UIImage(named: "twitter-retweet-default-state")
    static var RetweetedOnImage = UIImage(named: "twitter-retweet-on-state")
}

protocol RetweetedTweetsDelegate {
    func setTweetWithRetweetedDictionary(tweet:Tweet)
}

class TweetDetailsButtonsCell: UITableViewCell, RetweetedTweetsDelegate {
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet:Tweet?
    let twitterClient = TwitterClient()
    
    @IBAction func replyButton(sender: UIButton) {
    }

    @IBAction func retweetButton(sender: UIButton) {
        if(sender.imageForState(UIControlState.Normal) == TwitterButtonImage.RetweetedDefaultImage) {
            sender.setImage(TwitterButtonImage.RetweetedOnImage, forState: UIControlState.Normal)
            twitterClient.retweetTweet(self.tweet!)
        } else {
            sender.setImage(TwitterButtonImage.RetweetedDefaultImage, forState: UIControlState.Normal)
            twitterClient.undoRetweet(self.tweet!)
        }
    }
    
    @IBAction func favoriteButton(sender: UIButton) {
        twitterClient.favoriteTweet(self.tweet!)
        if(sender.imageForState(UIControlState.Normal) == TwitterButtonImage.FavoriteDefaultImage) {
            sender.setImage(TwitterButtonImage.FavoriteOnImage, forState: UIControlState.Normal)
        } else {
            sender.setImage(TwitterButtonImage.FavoriteDefaultImage, forState: UIControlState.Normal)
        }
    }
    
    func setTweetWithRetweetedDictionary(tweet:Tweet) {
            self.tweet = tweet
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        twitterClient.retweetedTweetsDelegate = self
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
