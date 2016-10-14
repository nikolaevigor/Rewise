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

class StackStorage: StackStorageServiceProtocol {
    
    let realm = try! Realm()
    let realmStorageService = RealmStorageMapper()
    
    func save(stacks: [Stack]) {
        
        for stack_ in stacks {
            
            let realmStack = realmStorageService.convertPlainToRealm(stack: stack_)
            
            try! realm.write {
                realm.add(realmStack, update: true)
            }
        }
        
    }
    
    func save(stack: Stack) {
        
        let realmStack = realmStorageService.convertPlainToRealm(stack: stack)
        
        try! realm.write {
            realm.add(realmStack, update: true)
        }
        
    }
    
    func save(card: Card) {
        
        let realmCard = realmStorageService.convertPlainToRealm(card: card)
        
        try! realm.write {
            realm.add(realmCard, update: true)
        }

    }
    
    func delete(stack: Stack) {
        
        realm.delete(realm.object(ofType: RealmStack.self, forPrimaryKey: "\(stack.id)")!)
        
    }
    
    func delete(card: Card) {
        
        realm.delete(realm.object(ofType: RealmCard.self, forPrimaryKey: "\(card.id)")!)
        
    }
    
    func extractStacks() -> [Stack]? {
        
        let extractedStacks = realm.objects(RealmStack.self)
        var stacks: [Stack] = []
        
        for realmStack in extractedStacks {
            stacks.append(realmStack.plain())
        }
        
        return stacks
        
    }
    
    func wipe() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}

class RealmStack: Object {
    
    dynamic var id = ""
    dynamic var title = ""
    var cards = List<RealmCard>()
    
    convenience init(id: String, title: String, cards: [RealmCard]) {
        self.init()
        self.title = title
        self.cards = List<RealmCard>()
        self.id = id
        
        for card in cards {
            self.cards.append(card)
        }
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func plain() -> Stack {
        var plainCards: [Card] = []
        
        for realmCard in self.cards {
            plainCards.append(realmCard.plain())
        }
        
        return Stack(id: self.id, title: self.title, cards: plainCards)
    }
}

class RealmCard: Object {
    
    dynamic var id = ""
    dynamic var title = ""
    dynamic var text = ""
    
    convenience init(id: String, title: String, text: String) {
        self.init()
        self.title = title
        self.text = text
        self.id = id
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func plain() -> Card {
        return Card(id: self.id, title: self.title, text: self.text)
    }
    
}
