//
//  CoreTabController.swift
//  Rewise
//
//  Created by Igor Nikolaev on 18/07/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

class CoreTabController: UITabBarController, CoreTabControllerOutput, CanPaintBackground {
    
    var onMenu: (() -> ())?
    
    override func viewDidLoad() {
        self.applyGradientOnBackground()
        self.tabBar.hidden = true
        self.onMenu?()
    }
    
}