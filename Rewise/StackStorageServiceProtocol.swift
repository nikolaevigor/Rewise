//
//  StackStorageServiceProtocol.swift
//  Rewise
//
//  Created by Igor Nikolaev on 06/10/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation

protocol StackStorageServiceProtocol {
    
    func extractStacks() -> [Stack]?
    
    func save(stacks: [Stack])
    
    func save(stack: Stack)
    
    func save(card: Card)
    
    func delete(stack: Stack)
    
    func wipe()
    
}
