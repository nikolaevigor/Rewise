//
//  MenuViewController.swift
//  Rewise
//
//  Created by Igor Nikolaev on 23/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MenuViewControllerOutput, CanPaintBackground {
    
    var onStart: (() -> ())?
    var onInspectCards: (() -> ())?
    var onSettings: (() -> ())?
    
    @IBOutlet weak var startUnderline: UIView!
    @IBOutlet weak var inspectUnderline: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyGradientOnBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func startButtonTouchUpOutside(sender: AnyObject) {
        self.startUnderline.alpha = 1.0
    }
    
    @IBAction func startButtonTouchDown(sender: AnyObject) {
        self.startUnderline.alpha = 0.3
    }
    
    @IBAction func startButtonTouchUpInside(sender: AnyObject) {
        self.startUnderline.alpha = 1.0
        onStart?()
    }
    
    @IBAction func inspectCardsButtonTouchUpOutside(sender: AnyObject) {
        self.inspectUnderline.alpha = 1.0
    }
    
    @IBAction func inspectCardsButtonTouchDown(sender: AnyObject) {
        self.inspectUnderline.alpha = 0.3
    }
    
    @IBAction func inspectCardsButtonTouchUpInside(sender: AnyObject) {
        self.inspectUnderline.alpha = 1.0
        onInspectCards?()
    }
    
}