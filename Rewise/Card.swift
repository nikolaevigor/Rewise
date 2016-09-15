//
//  Card.swift
//  Rewise
//
//  Created by Igor Nikolaev on 23/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    var title: String
    var text: String
    var lastTimeShown: NSDate?
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
}

func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.title == rhs.title && lhs.text == rhs.text
}