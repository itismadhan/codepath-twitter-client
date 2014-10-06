//
//  StatusCell.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/26/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
    var tweet:Tweet?
    var imageTappedDelegate:ImageTappedDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.userInteractionEnabled = true
        var tapImage = UITapGestureRecognizer(target: self, action: "imageTapped:")
        tapImage.delegate = self
        self.avatarImageView?.addGestureRecognizer(tapImage)
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/10
        self.avatarImageView.layer.masksToBounds = true;
        self.avatarImageView.layer.borderWidth = 0;
    }
    
    func imageTapped(sender:UITapGestureRecognizer) {
        imageTappedDelegate?.pushUserProfileView(self.tweet!.user!)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
