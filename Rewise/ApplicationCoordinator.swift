//
//  ApplicationCoordinator.swift
//  Rewise
//
//  Created by Igor Nikolaev on 24/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

final class ApplicationCoordinator: BaseCoordinator {
    
    var tabController: CoreTabController
    var rightTransitionDelegate = TabDelegate(direction: .right)
    var leftTransitionDelegate  = TabDelegate(direction: .left)
    
    init(tabController: CoreTabController) {
        self.tabController = tabController
    }
    
    override func start() {
        tabController.onMenu = runMenu()
    }
    
    fileprivate func runMenu() -> (() -> ()) {
        return {
            let controller = self.getController("MenuViewController", storyboardIdentifier: "Main") as! MenuViewController
            
            controller.onStart = { [weak self] in
                self?.tabController.delegate = self?.rightTransitionDelegate
                let closure = self?.runLearningModeSelection()
                closure?()
                self?.removeViewControllerFromTabStack(controller)
            }
            
            controller.onInspectCards = { [weak self] in
                self?.tabController.delegate = self?.rightTransitionDelegate
                let closure = self?.runInspector()
                closure?()
                self?.removeViewControllerFromTabStack(controller)
            }
            
            self.addViewControllerToTabStack(controller)
            self.selectViewController(controller)
        }
    }
    
    fileprivate func runLearningModeSelection() -> (() -> ()) {
        return {
            let controller = self.getController("LearningModeSelectionViewController", storyboardIdentifier: "Main") as! LearningModeSelectionViewController
            
            controller.onMenu = { [weak self] in
                self?.tabController.delegate = self?.leftTransitionDelegate
                let closure = self?.runMenu()
                closure?()
                self?.removeViewControllerFromTabStack(controller)
            }
            
            controller.onLearning = { [weak self] learningMode in
                self?.tabController.delegate = self?.rightTransitionDelegate
                let closure = self?.runLearning(learningMode)
                closure?()
                self?.removeViewControllerFromTabStack(controller)
                
            }
            
            self.addViewControllerToTabStack(controller)
            self.selectViewController(controller)
        }
    }
    
    fileprivate func runLearning(_ learningMode: LearningMode) -> (() -> ()) {
        return {
            let storage = StackStorage()
            let stacks = storage.extractStacks()
            let controller = self.getController("LearningViewController", storyboardIdentifier: "Main") as! LearningViewController
            controller.learningMode = learningMode
            
            controller.onLearningModeSelection = { [weak self] in
                self?.tabController.delegate = self?.leftTransitionDelegate
                let closure = self?.runLearningModeSelection()
                closure?()
                self?.removeViewControllerFromTabStack(controller)
            }
            
            if let stacks_ = stacks { controller.stacks = stacks_ }
            
            self.addViewControllerToTabStack(controller)
            self.selectViewController(controller)
        }
    }
    
    fileprivate func runInspector() -> (() -> ()) {
        return {
            let storage = StackStorage()
            let stacks = storage.extractStacks()
            
            let controller = self.getController("InspectingStacksViewController", storyboardIdentifier: "Main") as! InspectingStacksViewController
            if let stacks_ = stacks { controller.stacks = stacks_ }
            
            let nav = UINavigationController(rootViewController: controller)
            self.configureNavigationTabBar()
            //nav.navigationBar.hidden = true
            
            controller.onCloseInspector = { [weak self] stacks in
                self?.tabController.delegate = self?.leftTransitionDelegate
                let closure = self?.runMenu()
                closure?()
                self?.removeViewControllerFromTabStack(nav)
            }
            
            self.addViewControllerToTabStack(nav)
            self.selectViewController(nav)
        }
    }
    
}

extension ApplicationCoordinator {
    
    func addViewControllerToTabStack(_ controller: UIViewController) {
        let tab: UITabBarController = self.tabController
        
        if tab.viewControllers == nil {
            tab.viewControllers = [controller]
        }
        else {
            tab.viewControllers!.append(controller)
        }
    }
    
    func removeViewControllerFromTabStack(_ controller: UIViewController) {
        let tab: UITabBarController = self.tabController
        guard tab.viewControllers != nil else {
            return
        }
        
        for (index, item) in tab.viewControllers!.enumerated() {
            if ObjectIdentifier(item) == ObjectIdentifier(controller) {
                tab.viewControllers!.remove(at: index)
            }
        }
    }
    
    func selectViewController(_ controller: UIViewController) {
        let tab: UITabBarController = self.tabController
        guard tab.viewControllers != nil else {
            return
        }
        
        tab.selectedIndex = tab.viewControllers!.index(of: controller)!
    }
    
    func getController(_ identifier: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    func configureNavigationTabBar() {
        //transparent background
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage     = UIImage()
        UINavigationBar.appearance().isTranslucent     = true
        
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSShadowAttributeName: shadow
        ]
    }
    
}
