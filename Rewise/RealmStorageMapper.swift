//
//  RealmStorageMapper.swift
//  Rewise
//
//  Created by Igor Nikolaev on 06/10/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

class RealmStorageMapper: RealmStorageMapperServiceProtocol {
    
    func convertPlainToRealm(stack: Stack) -> RealmStack {
        var realmCards: [RealmCard] = []
        
        for card in stack.cards {
            realmCards.append(convertPlainToRealm(card: card))
        }
        
        return RealmStack(id: stack.id, title: stack.title, cards: realmCards)
    }
    
    func convertPlainToRealm(card: Card) -> RealmCard {
        return RealmCard(id: card.id, title: card.title, text: card.text)
    }
    
}
