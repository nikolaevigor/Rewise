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
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        itemSize = CGSize(width: 256, height: 335)
        
        // register cell
        registerCell()
        registerCreateCell()
        fillCellIsOpenArray()
        addGestureToView(collectionView!)
        configureNavBar()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

extension InspectingStacksViewController {
    
    fileprivate func registerCell() {
        let nib = UINib(nibName: "StackCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "collectioncell")
    }
    
    fileprivate func registerCreateCell() {
        let nib = UINib(nibName: "StackCollectionViewCreateCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "collectioncreatecell")
    }
    
    fileprivate func fillCellIsOpenArray() {
        for _ in stacks {
            cellsIsOpen.append(false)
        }
    }
    
    fileprivate func getViewController(_ stack: Stack, index: Int) -> InspectorStacksTableViewController {
        let toViewController = getController("InspectorStacksTableViewController", storyboardIdentifier: "Main") as! InspectorStacksTableViewController
        toViewController.stack = stack
        toViewController.onReturn = { [weak self] stack in
            self?.stacks[index] = stack
        }
        return toViewController
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
}

extension InspectingStacksViewController {
    
    fileprivate func addGestureToView(_ toView: UIView) {
        let gestureUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(InspectingStacksViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let gestureDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(InspectingStacksViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        toView.addGestureRecognizer(gestureUp)
        toView.addGestureRecognizer(gestureDown)
    }
    
    func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? StackCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController(stacks[(indexPath as NSIndexPath).row], index: (indexPath as NSIndexPath).row))
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
    }
    
}

extension InspectingStacksViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stacks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ("collectioncell"), for: indexPath) as! StackCollectionViewCell
        cell.title.text! = stacks[indexPath.row].title
        cell.textField.isUserInteractionEnabled = true
        cell.onEditEnd = { [weak self] title in
            self?.stacks[(indexPath as NSIndexPath).row].title = title
            self?.collectionView?.reloadData()
            
            let stackStorage = StackStorage()
            
            if let stack = self?.stacks[(indexPath as NSIndexPath).row] {
                stackStorage.save(stack: stack)
            }
            else {
                print("unable to save. stack is nil")
            }
        }
        return cell
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < -120.0 {
            scrollView.setContentOffset(scrollView.contentOffset, animated: false)
            self.onCloseInspector?(self.stacks)
        }
    }
    
    func getController(_ identifier: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}

// MARK: Actions

extension InspectingStacksViewController {
    
    @IBAction func backButtonHandler(_ sender: AnyObject) {
        self.onCloseInspector?(self.stacks)
    }
    
    @IBAction func newStackButtonPressed(_ sender: AnyObject) {
        let newStack = Stack(id: UUID().uuidString, title: "New stack", cards: [])
        stacks.append(newStack)
        
        let stackStorage = StackStorage()
        stackStorage.save(stack: newStack)
        
        cellsIsOpen.append(false)
        self.collectionView?.reloadData()
        let index = IndexPath(item: stacks.count - 1, section: 0)
        self.collectionView?.selectItem(at: index, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }
}
