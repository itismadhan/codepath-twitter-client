//
//  UserProfileMetaDataCell.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 10/7/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class UserProfileMetaDataCell: UITableViewCell {
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
