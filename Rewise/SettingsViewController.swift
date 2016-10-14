//
//  SettingsViewController.swift
//  Rewise
//
//  Created by Igor Nikolaev on 24/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewControllerOutput, CanPaintBackground {

    var onCloseSettings: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyGradientOnBackground()
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(swipedBack))
        swipeBack.direction = .right
        self.view.addGestureRecognizer(swipeBack)
    }
    
    func swipedBack() {
        onCloseSettings?()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
