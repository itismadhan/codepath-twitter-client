//
//  StatusesNavigationController.swift
//  twitter
//
//  Created by Madhan Padmanabhan on 9/26/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class StatusesNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColorHelper.uicolorFromHex(0x55ACEE)
        navigationBarAppearace.barTintColor = UIColorHelper.uicolorFromHex(0x4d4d4d)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
}
