//
//  StackCollectionViewCreateCell.swift
//  Rewise
//
//  Created by Igor Nikolaev on 18/07/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import expanding_collection

class StackCollectionViewCreateCell: BasePageCollectionCell {
    
    var createNewStackLogic: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.shadowView?.removeFromSuperview()
    }
    
    @IBAction func newStackButtonPressed(sender: AnyObject) {
        self.createNewStackLogic?()
    }
}