//
//  StatusesViewController.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/26/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit
import Social
import Accounts

enum TwitterView {
    case HomeTimeline
    case Mentions
    case UserProfile
}

protocol TweetsDelegate {
    func setTweets(tweets:[Tweet])
}

protocol ImageTappedDelegate {
    func pushUserProfileView(user:User)
}

class StatusesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetsDelegate, ImageTappedDelegate {
    var statuses:[Tweet]?
    var user:User?
    var refreshControl:UIRefreshControl?
    var showTimeLine:Bool!
    var showBannerImage:Bool!
    let twitterClient = TwitterClient()
    var viewType:TwitterView = .HomeTimeline
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch(viewType) {
        case .HomeTimeline:
            twitterClient.getTweets()
        case .Mentions:
            twitterClient.getMentions()
        case .UserProfile:
            twitterClient.getUserTimeLine(self.user!)
        }
        if showBannerImage! && self.user!.profileBannerUrl != nil{
            let imageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, self.tableView.frame.width, 100))
            imageView.setImageWithURL(NSURL(string: self.user!.profileBannerUrl))
            self.tableView.tableHeaderView = imageView
        }
        self.edgesForExtendedLayout = UIRectEdge.None
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 144
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColorHelper.uicolorFromHex(0x272727)
        self.refreshControl?.addTarget(self, action: "refreshTweets:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Bordered, target: self, action: "composeTweetAction:")
        self.navigationItem.rightBarButtonItem = tweetButton
        
        let statusCellNib:UINib = UINib(nibName: "StatusCell", bundle: nil)
        self.tableView.registerNib(statusCellNib, forCellReuseIdentifier: "StatusCell")
        
        twitterClient.tweetsDelegate = self
    }
    
    func refreshTweets(sender:AnyObject)
    {
        switch(viewType) {
        case .HomeTimeline:
            twitterClient.getTweets()
        case .Mentions:
            twitterClient.getMentions()
        case .UserProfile:
            twitterClient.getUserTimeLine(self.user!)
        }
        self.refreshControl!.endRefreshing()
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:StatusCell = self.tableView.dequeueReusableCellWithIdentifier("StatusCell") as StatusCell
        let tweet = self.statuses![indexPath.row] as Tweet
        cell.statusLabel.text = tweet.text
        cell.userNameLabel.text = tweet.user?.name
        cell.timeStampLabel.text = tweet.createdAtString
        cell.avatarImageView.setImageWithURL(tweet.user?.profileImageUrl)
        cell.imageTappedDelegate = self
        cell.tweet = tweet
        var cellBGColorView = UIView()
        cellBGColorView.backgroundColor = UIColorHelper.uicolorFromHex(0x55ACEE)
        cell.selectedBackgroundView = cellBGColorView
        cell.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorColor = UIColorHelper.uicolorFromHex(0x4d4d4d)
        self.tableView.backgroundColor = UIColorHelper.uicolorFromHex(0x272727)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.statuses != nil) {
            return self.statuses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tweetDetailsVC:TweetDetailsViewController = TweetDetailsViewController(nibName: "TweetDetailsViewController", bundle: nil)
        tweetDetailsVC.tweet = self.statuses![indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.pushViewController(tweetDetailsVC, animated: true)
    }
    
    
    func setTweets(tweets:[Tweet]) {
        dispatch_async(dispatch_get_main_queue(), {
            self.statuses = tweets
            self.tableView.reloadData()
        })
    }
    
    func composeTweetAction(sender:UIBarButtonItem) {
        let composeVC = ComposeViewController(nibName: "ComposeViewController", bundle: nil)
        composeVC.user = self.user
        let navVC:StatusesNavigationController = StatusesNavigationController(rootViewController: composeVC)
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    func pushUserProfileView(user:User) {
        let userProfileVC:StatusesViewController = StatusesViewController(nibName: "StatusesViewController", bundle: nil)
        userProfileVC.showBannerImage = true
        userProfileVC.user = user
        userProfileVC.navigationItem.title = "Profile"
        userProfileVC.viewType = .UserProfile
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
}
