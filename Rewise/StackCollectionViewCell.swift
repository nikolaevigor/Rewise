//
//  StackCollectionViewCell.swift
//  Rewise
//
//  Created by Igor Nikolaev on 29/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import expanding_collection

class StackCollectionViewCell: BasePageCollectionCell, UITextFieldDelegate {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var onEditEnd: ((String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backContainerView.layer.borderWidth = 0.5
        self.backContainerView.layer.borderColor = UIColor(red: 85.0/255.0, green: 97.0/255.0, blue: 112/255.0, alpha: 1.0).CGColor
    }
    
    
    @IBAction func editingBegin(sender: AnyObject) {
        self.title.hidden = true
        self.textField.hidden = false
    }
    
    @IBAction func edititngEnd(sender: AnyObject) {
        self.title.text = self.textField.text!
        self.title.hidden = false
        
        self.onEditEnd?(self.title.text!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        textField.text = ""
        return false
    }
}