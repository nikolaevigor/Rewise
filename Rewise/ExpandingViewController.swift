//
//  PageViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

/// UIViewController with UICollectionView with custom transition method
open class ExpandingViewController: UIViewController {
    
    /// The default size to use for cells.
    open var itemSize = CGSize(width: 256, height: 335)
    
    ///  The collection view object managed by this view controller.
    open var collectionView: UICollectionView?
    
    fileprivate var transitionDriver: TransitionDriver?
    
    /// Index of current cell
    open var currentIndex: Int {
        guard let collectionView = self.collectionView else { return 0 }
        
        let startOffset = (collectionView.bounds.size.width - itemSize.width) / 2
        guard let collectionLayout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return 0
        }
        
        let minimumLineSpacing = collectionLayout.minimumLineSpacing
        let a = (collectionView.contentOffset.x + startOffset + itemSize.width / 2)
        let b = (itemSize.width + minimumLineSpacing)
        return Int(a / b)
    }
}

// MARK: life cicle

extension ExpandingViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

// MARK: Transition

public extension ExpandingViewController {
    
    /**
     Pushes a view controller onto the receiver’s stack and updates the display with custom animation.
     
     - parameter viewController: The table view controller to push onto the stack.
     */
    func pushToViewController(_ viewController: ExpandingTableViewController) {
//        guard let collectionView = self.collectionView,
//            let navigationController = self.navigationController else {
//                return
//        }
        
        guard let collectionView = self.collectionView else {
                return
        }
        
        let cell = collectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! StackCollectionViewCell
        cell.textField.isUserInteractionEnabled = false
        
        viewController.transitionDriver = transitionDriver
//        let insets = viewController.automaticallyAdjustsScrollViewInsets
//        let tabBarHeight =  insets == true ? navigationController.navigationBar.frame.size.height : 0
        let tabBarHeight = CGFloat(0)
//        let statusBarHeight = insets == true ? UIApplication.sharedApplication().statusBarFrame.size.height : 0
        let statusBarHeight = CGFloat(0)
        let backImage = getBackImage(viewController, headerHeight: viewController.headerHeight)
        
        transitionDriver?.pushTransitionAnimationIndex(currentIndex,
                                                       collecitionView: collectionView,
                                                       backImage: backImage,
                                                       headerHeight: viewController.headerHeight,
                                                       insets: tabBarHeight + statusBarHeight) { headerView in
                                                        viewController.tableView.tableHeaderView = headerView
                                                        self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}

// MARK: create

extension ExpandingViewController {
    
    fileprivate func commonInit() {
        
        let layout = PageCollectionLayout(itemSize: itemSize)
        collectionView = PageCollectionView.createOnView(view,
                                                         layout: layout,
                                                         height: itemSize.height + itemSize.height / 5 * 2,
                                                         dataSource: self,
                                                         delegate: self)
        transitionDriver = TransitionDriver(view: view)
    }
}

// MARK: Helpers

extension ExpandingViewController {
    
    fileprivate func getBackImage(_ viewController: UIViewController, headerHeight: CGFloat) -> UIImage? {
        let imageSize = CGSize(width: viewController.view.bounds.width, height: viewController.view.bounds.height - headerHeight)
        let imageFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
        return viewController.view.takeSnapshot(imageFrame)
    }
    
}

// MARK: UICollectionViewDataSource

extension ExpandingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard case let cell as BasePageCollectionCell = cell else {
            return
        }
        
        cell.configureCellViewConstraintsWithSize(itemSize)
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("need emplementation in subclass")
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("need emplementation in subclass")
    }
}

// MARK: UIScrollViewDelegate 

extension ExpandingViewController {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        if case let currentCell as BasePageCollectionCell = collectionView?.cellForItem(at: indexPath) {
            currentCell.configurationCell()
        }
    }
}

