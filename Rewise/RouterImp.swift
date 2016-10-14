//
//  RouterImp.swift
//  Rewise
//
//  Created by Igor Nikolaev on 24/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

final class RouterImp: Router {
    
    fileprivate(set) weak var rootController: UINavigationController?
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
    }
    
    func present(_ controller: UIViewController?) {
        present(controller, animated: true)
    }
    func present(_ controller: UIViewController?, animated: Bool) {
        guard let controller = controller else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func push(_ controller: UIViewController?)  {
        push(controller, animated: true)
    }
    
    func push(_ controller: UIViewController?, animated: Bool)  {
        guard let controller = controller else { return }
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popController()  {
        popController(true)
    }
    
    func popController(_ animated: Bool)  {
        _ = rootController?.popViewController(animated: animated)
    }
    
    func dismissController() {
        dismissController(true)
    }
    
    func dismissController(_ animated: Bool) {
        rootController?.dismiss(animated: animated, completion: nil)
    }
}
