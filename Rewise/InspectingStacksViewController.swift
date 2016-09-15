//
//  InspectingStacksViewController.swift
//  Rewise
//
//  Created by Igor Nikolaev on 28/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit
import Foundation
import expanding_collection

class InspectingStacksViewController: ExpandingViewController, CanPaintBackground, InspectingStacksViewControllerOutput {
    
    var cellsIsOpen     = [Bool]()
    var stacks: [Stack] = []
    
    var onCloseInspector: (([Stack]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientOnBackground()
        
        navigationController?.interactivePopGestureRecognizer?.enabled = false
        
        itemSize = CGSize(width: 256, height: 335)
        
        // register cell
        registerCell()
        registerCreateCell()
        fillCellIsOpenArray()
        addGestureToView(collectionView!)
        configureNavBar()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension InspectingStacksViewController {
    
    private func registerCell() {
        let nib = UINib(nibName: "StackCollectionViewCell", bundle: nil)
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "collectioncell")
    }
    
    private func registerCreateCell() {
        let nib = UINib(nibName: "StackCollectionViewCreateCell", bundle: nil)
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "collectioncreatecell")
    }
    
    private func fillCellIsOpenArray() {
        for _ in stacks {
            cellsIsOpen.append(false)
        }
    }
    
    private func getViewController(stack: Stack, index: Int) -> InspectorStacksTableViewController {
        let toViewController = getController("InspectorStacksTableViewController", storyboardIdentifier: "Main") as! InspectorStacksTableViewController
        toViewController.stack = stack
        toViewController.onReturn = { [weak self] stack in
            self?.stacks[index] = stack
        }
        return toViewController
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
}

extension InspectingStacksViewController {
    
    private func addGestureToView(toView: UIView) {
        let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(InspectingStacksViewController.swipeHandler(_:)))) {
            $0.direction = .Up
        }
        
        let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(InspectingStacksViewController.swipeHandler(_:)))) {
            $0.direction = .Down
        }
        toView.addGestureRecognizer(gesutereUp)
        toView.addGestureRecognizer(gesutereDown)
    }
    
    func swipeHandler(sender: UISwipeGestureRecognizer) {
        let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
        guard let cell  = collectionView?.cellForItemAtIndexPath(indexPath) as? StackCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .Up {
            pushToViewController(getViewController(stacks[indexPath.row], index: indexPath.row))
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
        
        let open = sender.direction == .Up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
    
}

extension InspectingStacksViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stacks.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(("collectioncell"), forIndexPath: indexPath) as! StackCollectionViewCell
        cell.title.text! = stacks[indexPath.row].title
        cell.textField.userInteractionEnabled = true
        cell.onEditEnd = { [weak self] title in
            self?.stacks[indexPath.row].title = title
            self?.collectionView?.reloadData()
        }
        return cell
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x < -120.0 {
            scrollView.setContentOffset(scrollView.contentOffset, animated: false)
            self.onCloseInspector?(self.stacks)
        }
    }
    
    func getController(identifier: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
}

// MARK: Actions

extension InspectingStacksViewController {
    
    @IBAction func backButtonHandler(sender: AnyObject) {
        self.onCloseInspector?(self.stacks)
    }
    
    @IBAction func newStackButtonPressed(sender: AnyObject) {
        stacks.append(Stack(title: "New stack", cards: []))
        cellsIsOpen.append(false)
        self.collectionView?.reloadData()
        let index = NSIndexPath(forItem: stacks.count - 1, inSection: 0)
        self.collectionView?.selectItemAtIndexPath(index, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
    }
}
