//
//  LearningViewController.swift
//  Rewise
//
//  Created by Igor Nikolaev on 20/07/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit
import SnapKit

class LearningViewController: UIViewController, LeariningCoordinatorOutput {
    
    var onLearningModeSelection: (() -> ())?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var learningMode: LearningMode?
    
    var stacks: [Stack] = []
    var allCards: [Card] = []
    var currentCard: Card? { didSet {
            contentText.text = currentCard!.text
        } }
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    var stacksAlert = UILabel()
    var contentText = UILabel()
    
    func showMenu() {
        self.onLearningModeSelection?()
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = Constants.lightColor
        self.scrollView.backgroundColor = Constants.lightColor
        
        redButton.layer.borderWidth   = 1.0
        greenButton.layer.borderWidth = 1.0
        blueButton.layer.borderWidth  = 1.0
        redButton.layer.borderColor   = Constants.darkColor.cgColor
        greenButton.layer.borderColor = Constants.darkColor.cgColor
        blueButton.layer.borderColor  = Constants.darkColor.cgColor
        
        contentText.numberOfLines = 0
        contentText.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentText.textColor = Constants.darkColor
        self.scrollView.addSubview(contentText)
        
        contentText.snp.makeConstraints({ make in
            make.centerX.equalTo(self.scrollView)
            make.leading.equalTo(self.scrollView.snp.leading).offset(10.0)
            make.trailing.equalTo(self.scrollView.snp.trailing).offset(-10.0)
            make.top.equalTo(self.scrollView.snp.top).offset(10.0)
            make.bottom.equalTo(self.scrollView.snp.bottom).offset(-10.0)
        })
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(LearningViewController.showMenu))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
        
        allCards = extractCards(stacks)
        setRandomCard()
    }
    
    @IBAction func redButtonPressed(_ sender: AnyObject) {
        setRandomCard()
    }
    
    @IBAction func greenButtonPressed(_ sender: AnyObject) {
        setRandomCard()
    }
    
    @IBAction func blueButtonPressed(_ sender: AnyObject) {
        setRandomCard()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}

extension LearningViewController {
    
    func extractCards(_ stacks: [Stack]?) -> [Card] {
        guard let stacks_ = stacks else {
            showStacksAlert()
            return []
        }
        
        var extractedCards: [Card] = []
        
        for stack in stacks_ {
            for card in stack.cards {
                extractedCards.append(card)
            }
        }
        
        return extractedCards
    }
    
    func setRandomCard() {
        
        let randomNumber = arc4random_uniform(UInt32(allCards.count))
        
        if allCards.isEmpty {
            showStacksAlert()
        }
        else {
            currentCard = allCards[Int(randomNumber)]
        }
        
    }
    
    func showStacksAlert() {
        
        stacksAlert.text = "You have no stacks yet"
        stacksAlert.textColor = Constants.darkColor
        self.scrollView.addSubview(stacksAlert)
        
        stacksAlert.snp.makeConstraints({ make in
            make.centerX.equalTo(self.scrollView)
            make.centerY.equalTo(self.scrollView).offset(-20.0)
        })
        
    }
    
    func hideStacksAlert() {
        stacksAlert.removeFromSuperview()
    }
    
}
