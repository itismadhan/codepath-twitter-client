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

    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/10
        self.avatarImageView.layer.masksToBounds = true;
        self.avatarImageView.layer.borderWidth = 0;

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
