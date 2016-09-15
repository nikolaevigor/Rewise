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
    var rightTransitionDelegate = TabDelegate(direction: .Right)
    var leftTransitionDelegate  = TabDelegate(direction: .Left)
    
    init(tabController: CoreTabController) {
        self.tabController = tabController
    }
    
    override func start() {
        tabController.onMenu = runMenu()
    }
    
    private func runMenu() -> (() -> ()) {
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
    
    private func runLearningModeSelection() -> (() -> ()) {
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
    
    private func runLearning(learningMode: LearningMode) -> (() -> ()) {
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
    
    private func runInspector() -> (() -> ()) {
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
                
                storage.saveStacks(stacks)
            }
            
            self.addViewControllerToTabStack(nav)
            self.selectViewController(nav)
        }
    }
    
}

extension ApplicationCoordinator {
    
    func addViewControllerToTabStack(controller: UIViewController) {
        let tab: UITabBarController = self.tabController
        
        if tab.viewControllers == nil {
            tab.viewControllers = [controller]
        }
        else {
            tab.viewControllers!.append(controller)
        }
    }
    
    func removeViewControllerFromTabStack(controller: UIViewController) {
        let tab: UITabBarController = self.tabController
        guard tab.viewControllers != nil else {
            return
        }
        
        for (index, item) in tab.viewControllers!.enumerate() {
            if ObjectIdentifier(item) == ObjectIdentifier(controller) {
                tab.viewControllers!.removeAtIndex(index)
            }
        }
    }
    
    func selectViewController(controller: UIViewController) {
        let tab: UITabBarController = self.tabController
        guard tab.viewControllers != nil else {
            return
        }
        
        tab.selectedIndex = tab.viewControllers!.indexOf(controller)!
    }
    
    func getController(identifier: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    func configureNavigationTabBar() {
        //transparent background
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage     = UIImage()
        UINavigationBar.appearance().translucent     = true
        
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSShadowAttributeName: shadow
        ]
    }
    
}