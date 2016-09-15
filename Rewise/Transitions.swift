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
    
    func tabBarController(tabBarController: UITabBarController,
                          animationControllerForTransitionFromViewController fromVC: UIViewController,
                                                                             toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabControllerAnimator(direction: self.direction)
    }
    
}

class TabControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var direction: TabTransitionDirection
    
    init(direction: TabTransitionDirection) {
        self.direction = direction
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Constants.transitAnimationTime
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        transitionContext.containerView()!.addSubview(toVC!.view)
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        switch self.direction {
        case .Left:
            toVC!.view.frame.origin.x -= screenWidth
            UIView.animateWithDuration(Constants.transitAnimationTime, animations: {
                toVC!.view.frame.origin.x += screenWidth
                fromVC!.view.frame.origin.x += screenWidth
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        case .Right:
            toVC!.view.frame.origin.x += screenWidth
            UIView.animateWithDuration(Constants.transitAnimationTime, animations: {
                toVC!.view.frame.origin.x -= screenWidth
                fromVC!.view.frame.origin.x -= screenWidth
                },
                                       completion: { finished in
                                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }
}

class NavDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController,
                              animationControllerForOperation operation: UINavigationControllerOperation,
                                                              fromViewController fromVC: UIViewController,
                                                                                 toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return NavigationControllerAnimator(operation: operation)
    }
}

class NavigationControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationControllerOperation
    
    init(operation: UINavigationControllerOperation) {
        self.operation = operation
    }
    
    func transitionDuration(context: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Constants.transitAnimationTime
    }
    
    func animateTransition(context: UIViewControllerContextTransitioning) {
        let toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        guard toVC != nil && fromVC != nil else {
            print("animation failure")
            return
        }
        
        context.containerView()!.addSubview(toVC!.view)
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        switch operation {
        case .Push:
            toVC!.view.frame.origin.x = screenWidth
            fromVC!.view.frame.origin.x = 0.0
            UIView.animateWithDuration(Constants.transitAnimationTime, animations: {
                toVC!.view.frame.origin.x -= screenWidth
                fromVC!.view.frame.origin.x -= screenWidth
                },
                                       completion: { finished in
                                        context.completeTransition(!context.transitionWasCancelled())
            })
        case .Pop:
            toVC!.view.frame.origin.x = -screenWidth
            fromVC!.view.frame.origin.x = 0.0
            UIView.animateWithDuration(Constants.transitAnimationTime, animations: {
                toVC!.view.frame.origin.x += screenWidth
                fromVC!.view.frame.origin.x += screenWidth
                },
                                       completion: { finished in
                                        context.completeTransition(!context.transitionWasCancelled())
            })
        default:
            print("unhandled transition")
        }
    }
}

enum TabTransitionDirection {
    case Left
    case Right
}