//
//  Stack.swift
//  Rewise
//
//  Created by Igor Nikolaev on 23/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation

struct Stack: Equatable {
    
    var id: String
    var title: String
    var cards: [Card]
    
    init(id: String, title: String, cards: [Card]) {
        self.title = title
        self.cards = cards
        self.id = id
    }
    
}

func ==(lhs: Stack, rhs: Stack) -> Bool {
    return lhs.title == rhs.title && lhs.cards == rhs.cards
}
