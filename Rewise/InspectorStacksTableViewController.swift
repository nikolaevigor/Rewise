//
//  InspectorStacksTableViewController.swift
//  Rewise
//
//  Created by Igor Nikolaev on 29/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation
import expanding_collection

class InspectorStacksTableViewController: ExpandingTableViewController, UITextFieldDelegate {
    
    var stack: Stack?
    
    var onReturn: ((Stack) -> ())?
    
    var fromEditor: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerHeight = 236
        configureNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
        
        if fromEditor {
            self.navigationController?.navigationBar.frame.origin.y -= (self.navigationController?.navigationBar.frame.size.height)!
            UIView.animateWithDuration(Constants.transitAnimationTime/2.0, animations: {
                self.navigationController?.navigationBar.frame.origin.y += (self.navigationController?.navigationBar.frame.size.height)!
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if let cell_ = tableView.dequeueReusableCellWithIdentifier("cell") {
            cell = cell_
        }
        else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = stack?.cards[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stack?.cards.count ?? 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = getController("CardEditViewController", storyboardIdentifier: "Main") as! CardEditViewController
        controller.card = stack!.cards[indexPath.row]
        controller.onReturn = { [weak self] card in
            self?.stack!.cards[indexPath.row] = card
            self?.tableView.reloadData()
        }
        
        self.navigationController?.navigationBar.hidden = true
        self.fromEditor = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -120.0 {
            self.onReturn?(stack!)
            backButtonHandler(self)
        }
    }
    
    func buttonPressed() {
        let card = Card(title: "new card", text: "Text")
        self.stack?.cards.append(card)
        self.tableView.reloadData()
    }
    
    func getController(identifier: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
}

// MARK: Helpers

extension InspectorStacksTableViewController {
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
}

// MARK: Actions

extension InspectorStacksTableViewController {
    
    @IBAction func newCardButtonHandler(sender: AnyObject) {
        let card = Card(title: "new card", text: "Text")
        self.stack?.cards.append(card)
        self.tableView.reloadData()
    }
    
    @IBAction func backButtonHandler(sender: AnyObject) {
        // buttonAnimation
        let viewControllers: [UIViewController?] = navigationController?.viewControllers.map { $0 } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        onReturn?(self.stack!)
        popTransitionAnimation()
    }
}