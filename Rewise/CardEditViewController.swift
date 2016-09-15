//
//  CardEditViewController.swift
//  Rewise
//
//  Created by Igor Nikolaev on 21/07/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

class CardEditViewController: UIViewController, UITextFieldDelegate {
    
    var card: Card?
    var onReturn: ((Card) -> ())?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardTitle.text = card?.title
        textView.text = card?.text
        
        self.navigationController?.navigationBar.hidden = true
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(CardEditViewController.returnToStack))
        swipe.direction = .Right
        self.view.addGestureRecognizer(swipe)
    }
    
    func returnToStack() {
        
        card?.text = textView.text
        
        self.navigationController?.popViewControllerAnimated(true)
        onReturn?(card!)
    }
    
    @IBAction func textFieldEditingBegin(sender: AnyObject) {
        self.cardTitle.hidden = true
        self.textField.hidden = false
    }
    
    @IBAction func textFieldEditingDidEnd(sender: AnyObject) {
        self.cardTitle.text = self.textField.text!
        self.cardTitle.hidden = false
        
        card?.title = self.cardTitle.text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.text = ""
        return false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}