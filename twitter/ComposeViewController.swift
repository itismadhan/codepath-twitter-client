//
//  ComposeViewController.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/30/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    var user:User?
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    let twitterClient = TwitterClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.userNameLabel.text = user?.name as String!
        self.avatarImageView.setImageWithURL(user?.profileImageUrl)
        self.tweetTextView.becomeFirstResponder()
        
        let cancelButton:UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelTweetAction:")
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let tweetButton:UIBarButtonItem = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Bordered, target: self, action: "sendTweetAction:")
        self.navigationItem.rightBarButtonItem = tweetButton
        
    }
    
    func cancelTweetAction(sender:UIBarButtonItem) {
        self.tweetTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendTweetAction(sender:UIBarButtonItem) {
        twitterClient.postTweet(self.tweetTextView.text)
        self.tweetTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(sender:NSNotification) {
        var info = sender.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        self.textViewBottomConstraint.constant = keyboardFrame.height
    }
}
