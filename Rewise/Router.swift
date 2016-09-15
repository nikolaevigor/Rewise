//
//  Router.swift
//  Rewise
//
//  Created by Igor Nikolaev on 24/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

protocol Router: class {
    
    weak var rootController: UINavigationController? { get }
    
    func present(controller: UIViewController?)
    func present(controller: UIViewController?, animated: Bool)
    
    func push(controller: UIViewController?)
    func push(controller: UIViewController?, animated: Bool)
    
    func popController()
    func popController(animated: Bool)
    
    func dismissController()
    func dismissController(animated: Bool)
}