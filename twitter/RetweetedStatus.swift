//
//  RetweetedStatus.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/29/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class RetweetedStatus: NSObject {
    var id:String!
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as String!
    }
}
