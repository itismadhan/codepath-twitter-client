//
//  TweetDetailsViewController.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/27/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

enum TweetDetails:Int {
    case MainCell
    case MetaDataCell
    case ButtonsCell
}

class TweetDetailsViewController: UIViewController,  UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var tweet:Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 144
        let tweetDetailsMainCellNib:UINib = UINib(nibName: "TweetDetailsMainCell", bundle: nil)
        self.tableView.registerNib(tweetDetailsMainCellNib, forCellReuseIdentifier: "TweetDetailsMainCell")
        
        let tweetDetailsMetaDataCellNib:UINib = UINib(nibName: "TweetDetailsMetaDataCell", bundle: nil)
        self.tableView.registerNib(tweetDetailsMetaDataCellNib, forCellReuseIdentifier: "TweetDetailsMetaDataCell")
        
        let tweetDetailsButtonsCellNib:UINib = UINib(nibName: "TweetDetailsButtonsCell", bundle: nil)
        self.tableView.registerNib(tweetDetailsButtonsCellNib, forCellReuseIdentifier: "TweetDetailsButtonsCell")
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.separatorColor = UIColorHelper.uicolorFromHex(0x4d4d4d)
        self.tableView.backgroundColor = UIColorHelper.uicolorFromHex(0x272727)
        switch(indexPath.row) {
        case TweetDetails.MainCell.toRaw():
            var cell:TweetDetailsMainCell = self.tableView.dequeueReusableCellWithIdentifier("TweetDetailsMainCell") as TweetDetailsMainCell
            cell.avatarImageView.setImageWithURL(tweet?.user?.profileImageUrl)
            cell.userNameLabel.text = tweet?.user?.name
            cell.statusLabel.text = tweet?.text
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        case TweetDetails.MetaDataCell.toRaw():
            var cell:TweetDetailsMetaDataCell = self.tableView.dequeueReusableCellWithIdentifier("TweetDetailsMetaDataCell") as TweetDetailsMetaDataCell
            cell.retweetsLabel.text = String(tweet!.retweetCount!) + " Retweets"
            cell.favoritesLabel.text = String(tweet!.favoriteCount!) + " Favorites"
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        case TweetDetails.ButtonsCell.toRaw():
            var cell:TweetDetailsButtonsCell = self.tableView.dequeueReusableCellWithIdentifier("TweetDetailsButtonsCell") as TweetDetailsButtonsCell
            cell.layoutMargins = UIEdgeInsetsZero
            cell.tweet = self.tweet
            if(cell.tweet!.favorited!) {
                cell.favoriteButton.setImage(TwitterButtonImage.FavoriteOnImage, forState: UIControlState.Normal)
            } else {
                cell.favoriteButton.setImage(TwitterButtonImage.FavoriteDefaultImage, forState: UIControlState.Normal)
            }
            if(cell.tweet!.retweeted!) {
                cell.retweetButton.setImage(TwitterButtonImage.RetweetedOnImage, forState: UIControlState.Normal)
            } else {
                cell.retweetButton.setImage(TwitterButtonImage.RetweetedDefaultImage, forState: UIControlState.Normal)
            }
            return cell
        default:
            break;
        }
        return self.tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
}
