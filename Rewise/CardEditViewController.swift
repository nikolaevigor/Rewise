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
        
        
        
        self.navigationController?.navigationBar.isHidden = true
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(CardEditViewController.returnToStack))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
    }
    
    func returnToStack() {
        
        card?.text = textView.text
        
        let stackStorage = StackStorage()
        stackStorage.save(card: card!)
        
        _ = self.navigationController?.popViewController(animated: true)
        onReturn?(card!)
    }
    
    @IBAction func textFieldEditingBegin(_ sender: AnyObject) {
        self.cardTitle.isHidden = true
        self.textField.isHidden = false
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: AnyObject) {
        self.cardTitle.text = self.textField.text!
        self.cardTitle.isHidden = false
        self.textField.isHidden = true
        
        card?.title = self.cardTitle.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.text = ""
        return false
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
