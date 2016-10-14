//
//  RealmStorageMapperProtocol.swift
//  Rewise
//
//  Created by Igor Nikolaev on 06/10/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

protocol RealmStorageMapperServiceProtocol {
    
    func convertPlainToRealm(stack: Stack) -> RealmStack
    
    func convertPlainToRealm(card: Card) -> RealmCard
    
}
