//
//  StackStorage.swift
//  Rewise
//
//  Created by Igor Nikolaev on 19/07/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class StackStorage {
    
    let realm = try! Realm()
    lazy var stacks: Results<RealmStack> = { self.realm.objects(RealmStack) }()
    
    func saveStacks(stacks: [Stack]) {
        
        if stacks == unwrapStacks(realm.objects(RealmStack).map{$0}) {
            return
        }
         
        try! realm.write() {
            realm.deleteAll()
            for stack in stacks {
                self.realm.add(wrapStack(stack))
            }
        }
        
    }
    
    func extractStacks() -> [Stack]? {
        let stacks = realm.objects(RealmStack).map{$0}
        return unwrapStacks(stacks)
    }
    
}

func unwrapStacks(stacksRlm: [RealmStack]) -> [Stack] {
    var stacks: [Stack] = []
    for item in stacksRlm {
        stacks.append(unwrapStack(item))
    }
    return stacks
}

func unwrapStack(realmStack: RealmStack) -> Stack {
    let stack = Stack(title: realmStack.title, cards: unwrapCards(realmStack.cards.map{$0}))
    return stack
}

func unwrapCard(realmCard: RealmCard) -> Card {
    let card = Card(title: realmCard.title, text: realmCard.text)
    return card
}

func unwrapCards(cardsRlm: [RealmCard]) -> [Card] {
    var cards: [Card] = []
    for item in cardsRlm {
        cards.append(unwrapCard(item))
    }
    return cards
}

func wrapStack(stack: Stack) -> RealmStack {
    let rlm = RealmStack()
    rlm.title = stack.title
    rlm.cards = wrapCards(stack.cards)
    return rlm
}

func wrapCard(card: Card) -> RealmCard {
    let rlm = RealmCard()
    rlm.title = card.title
    rlm.text = card.text
    return rlm
}

func wrapCards(cards: [Card]) -> List<RealmCard> {
    let rlm = List<RealmCard>()
    for card in cards {
        rlm.append(wrapCard(card))
    }
    return rlm
}

class RealmStack: Object {
    
    dynamic var title: String = ""
    var cards = List<RealmCard>()
    
}

class RealmCard: Object {
    
    dynamic var title: String = ""
    dynamic var text: String = ""
    
}