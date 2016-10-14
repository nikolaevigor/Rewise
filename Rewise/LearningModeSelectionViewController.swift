//
//  LearningModeSelectionViewController.swift
//  Rewise
//
//  Created by Igor Nikolaev on 13/09/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

class LearningModeSelectionViewController: UIViewController, LearningModeSelectionCoordinatorOutput {
    
    var onMenu: (() -> ())?
    var onLearning: ((LearningMode) -> ())?
    
    @IBOutlet weak var repetitionUnderline: UIView!
    @IBOutlet weak var randomUnderline: UIView!
    
    override func loadView() {
        
        super.loadView()
        
        view.backgroundColor = Constants.lightColor
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(LearningModeSelectionViewController.showMenu))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
        
    }
    
    func showMenu() {
        onMenu?()
    }
    
    @IBAction func repetitionTouchUpOutside(_ sender: AnyObject) {
        self.repetitionUnderline.alpha = 1.0
    }
    
    @IBAction func repetitionTouchDown(_ sender: AnyObject) {
        self.repetitionUnderline.alpha = 0.3
    }
    
    @IBAction func repetitionTouchUpInside(_ sender: AnyObject) {
        self.repetitionUnderline.alpha = 1.0
        onLearning?(.repetition)
    }
    
    @IBAction func randomTouchUpOutside(_ sender: AnyObject) {
        self.randomUnderline.alpha = 1.0
    }
    
    @IBAction func randomTouchDown(_ sender: AnyObject) {
        self.randomUnderline.alpha = 0.3
    }
    
    @IBAction func randomTouchUpInside(_ sender: AnyObject) {
        self.randomUnderline.alpha = 1.0
        onLearning?(.random)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
