//
//  TweetDetailsMetaDataCell.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/28/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class TweetDetailsMetaDataCell: UITableViewCell {
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
