//
//  File.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/27/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import Foundation

class UIColorHelper {
    
    class func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let blue = CGFloat(rgbValue & 0xFF)/255.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}