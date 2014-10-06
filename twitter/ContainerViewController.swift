//
//  ContainerViewController.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 10/5/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit
protocol UserDelegate {
    func setUser(user:User)
}

class ContainerViewController: UIViewController, UserDelegate {
    var user:User?
    @IBOutlet weak var contentViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var sidebarView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var timelineButton: UIButton!
    @IBOutlet weak var mentionsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    let twitterClient = TwitterClient()
    
    var viewControllers:[UIViewController] = [StatusesViewController(nibName: "StatusesViewController", bundle: nil), StatusesViewController(nibName: "StatusesViewController", bundle: nil), StatusesViewController(nibName: "StatusesViewController", bundle: nil)]
    
    var activeViewController:UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.didMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    @IBAction func onSendButton(sender: UIButton) {
        UIView.animateWithDuration(0.35, animations: {
            self.contentViewCenterXConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        if (sender == timelineButton) {
            let statusesNavigationVC:StatusesNavigationController = StatusesNavigationController()
            let timeLineVC:StatusesViewController = self.viewControllers[0] as StatusesViewController
            timeLineVC.showTimeLine = true
            timeLineVC.showBannerImage = false
            timeLineVC.user = self.user
            timeLineVC.viewType = .HomeTimeline
            timeLineVC.navigationItem.title = "Timeline"
            statusesNavigationVC.pushViewController(timeLineVC, animated: true)
            self.activeViewController = statusesNavigationVC
        } else if (sender == mentionsButton) {
            let statusesNavigationVC:StatusesNavigationController = StatusesNavigationController()
            let mentionsVC:StatusesViewController = self.viewControllers[1] as StatusesViewController
            mentionsVC.showTimeLine = false
            mentionsVC.showBannerImage = false
            mentionsVC.user = self.user
            mentionsVC.viewType = .Mentions
            mentionsVC.navigationItem.title = "Mentions"
            statusesNavigationVC.pushViewController(mentionsVC, animated: true)
            self.activeViewController = statusesNavigationVC
        } else if (sender == profileButton) {
            let statusesNavigationVC:StatusesNavigationController = StatusesNavigationController()
            let userProfileVC:StatusesViewController = self.viewControllers[2] as StatusesViewController
            userProfileVC.showTimeLine = true
            userProfileVC.showBannerImage = true
            userProfileVC.user = self.user
            userProfileVC.viewType = .UserProfile
            userProfileVC.navigationItem.title = "Profile"
            statusesNavigationVC.pushViewController(userProfileVC, animated: true)
            self.activeViewController = statusesNavigationVC
        } else {
            println("Unknown button Clicked")
        }
    }
    
    @IBAction func onSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .Ended {
            UIView.animateWithDuration(0.35, animations: {
                self.contentViewCenterXConstraint.constant = -self.sidebarView.frame.size.width
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twitterClient.login()
        twitterClient.userDelegate = self
        self.contentViewCenterXConstraint.constant = 0
        self.edgesForExtendedLayout = UIRectEdge.None
        let statusesNavigationVC:StatusesNavigationController = StatusesNavigationController()
        var timeLineVC:StatusesViewController = self.viewControllers[0] as StatusesViewController
        timeLineVC.showTimeLine = true
        timeLineVC.showBannerImage = false
        timeLineVC.navigationItem.title = "Timeline"
        timeLineVC.viewType = .HomeTimeline
        statusesNavigationVC.pushViewController(timeLineVC, animated: true)
        self.activeViewController = statusesNavigationVC
    }
    
    
    func setUser(user: User) {
        dispatch_async(dispatch_get_main_queue(), {
            self.user = user
        })
    }
}
