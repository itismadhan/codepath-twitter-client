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

protocol TweetsDelegate {
    func setUser(user:User)
    func setTweets(tweets:[Tweet])
}

class StatusesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetsDelegate {
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var statuses:[Tweet]?
    var user:User?
    var refreshControl:UIRefreshControl?
    var twitterClient = TwitterClient()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 144
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColorHelper.uicolorFromHex(0x272727)
        self.refreshControl?.addTarget(self, action: "refreshTweets:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        self.navigationItem.title = "Timeline"
        
        let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Bordered, target: self, action: "composeTweetAction:")
        self.navigationItem.rightBarButtonItem = tweetButton
        
        let statusCellNib:UINib = UINib(nibName: "StatusCell", bundle: nil)
        self.tableView.registerNib(statusCellNib, forCellReuseIdentifier: "StatusCell")
        
        
        twitterClient.tweetsDelegate = self
    }
    
    func refreshTweets(sender:AnyObject)
    {
        twitterClient.getTweets()
        self.tableView.reloadData()
        self.refreshControl!.endRefreshing()
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
    
    func setUser(user: User) {
        self.user = user
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
    
}
