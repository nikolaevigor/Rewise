//
//  BaseCoordinator.swift
//  Rewise
//
//  Created by Igor Nikolaev on 24/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation
import UIKit

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        assertionFailure("must be overriden")
    }
    
    // add only unique object
    func addDependancy(_ coordinator: Coordinator) {
        
        for element in childCoordinators {
            if ObjectIdentifier(element) == ObjectIdentifier(coordinator) { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependancy(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if ObjectIdentifier(element) == ObjectIdentifier(coordinator) {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
