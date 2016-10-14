//
//  Transitions.swift
//  Rewise
//
//  Created by Igor Nikolaev on 19/07/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

class TabDelegate: NSObject, UITabBarControllerDelegate {
    
    var direction: TabTransitionDirection
    
    init(direction: TabTransitionDirection) {
        self.direction = direction
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          animationControllerForTransitionFrom fromVC: UIViewController,
                                                                             to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabControllerAnimator(direction: self.direction)
    }
    
}

class TabControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var direction: TabTransitionDirection
    
    init(direction: TabTransitionDirection) {
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.transitAnimationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        transitionContext.containerView.addSubview(toVC!.view)
        
        let screenWidth = UIScreen.main.bounds.width
        
        switch self.direction {
        case .left:
            toVC!.view.frame.origin.x -= screenWidth
            UIView.animate(withDuration: Constants.transitAnimationTime, animations: {
                toVC!.view.frame.origin.x += screenWidth
                fromVC!.view.frame.origin.x += screenWidth
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        case .right:
            toVC!.view.frame.origin.x += screenWidth
            UIView.animate(withDuration: Constants.transitAnimationTime, animations: {
                toVC!.view.frame.origin.x -= screenWidth
                fromVC!.view.frame.origin.x -= screenWidth
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}

class NavDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                                                              from fromVC: UIViewController,
                                                                                 to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return NavigationControllerAnimator(operation: operation)
    }
}

class NavigationControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationControllerOperation
    
    init(operation: UINavigationControllerOperation) {
        self.operation = operation
    }
    
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.transitAnimationTime
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        let toVC = context.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        guard toVC != nil && fromVC != nil else {
            print("animation failure")
            return
        }
        
        context.containerView.addSubview(toVC!.view)
        
        let screenWidth = UIScreen.main.bounds.width
        
        switch operation {
        case .push:
            toVC!.view.frame.origin.x = screenWidth
            fromVC!.view.frame.origin.x = 0.0
            UIView.animate(withDuration: Constants.transitAnimationTime, animations: {
                toVC!.view.frame.origin.x -= screenWidth
                fromVC!.view.frame.origin.x -= screenWidth
                },
                                       completion: { finished in
                                        context.completeTransition(!context.transitionWasCancelled)
            })
        case .pop:
            toVC!.view.frame.origin.x = -screenWidth
            fromVC!.view.frame.origin.x = 0.0
            UIView.animate(withDuration: Constants.transitAnimationTime, animations: {
                toVC!.view.frame.origin.x += screenWidth
                fromVC!.view.frame.origin.x += screenWidth
                },
                                       completion: { finished in
                                        context.completeTransition(!context.transitionWasCancelled)
            })
        default:
            print("unhandled transition")
        }
    }
}

enum TabTransitionDirection {
    case left
    case right
}
