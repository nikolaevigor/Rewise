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
    
    func present(_ controller: UIViewController?)
    func present(_ controller: UIViewController?, animated: Bool)
    
    func push(_ controller: UIViewController?)
    func push(_ controller: UIViewController?, animated: Bool)
    
    func popController()
    func popController(_ animated: Bool)
    
    func dismissController()
    func dismissController(_ animated: Bool)
}
