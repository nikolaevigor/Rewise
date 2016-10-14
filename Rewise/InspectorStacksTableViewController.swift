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
        tableView.separatorInset.right = 30
        tableView.separatorInset.left = 30
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        if fromEditor {
            self.navigationController?.navigationBar.frame.origin.y -= (self.navigationController?.navigationBar.frame.size.height)!
            UIView.animate(withDuration: Constants.transitAnimationTime/2.0, animations: {
                self.navigationController?.navigationBar.frame.origin.y += (self.navigationController?.navigationBar.frame.size.height)!
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if let cell_ = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell") {
            cell = cell_
        }
        else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CardTableViewCell")
        }
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "SFUIText-Ultrathin", size: 20.0)
        cell.textLabel?.text = stack?.cards[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stack?.cards.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = getController("CardEditViewController", storyboardIdentifier: "Main") as! CardEditViewController
        controller.card = stack!.cards[indexPath.row]
        controller.onReturn = { [weak self] card in
            self?.stack!.cards[indexPath.row] = card
            self?.tableView.reloadData()
        }
        
        self.navigationController?.navigationBar.isHidden = true
        self.fromEditor = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -120.0 {
            self.onReturn?(stack!)
            backButtonHandler(self)
        }
    }
    
    func getController(_ identifier: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}

// MARK: Helpers

extension InspectorStacksTableViewController {
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}

// MARK: Actions

extension InspectorStacksTableViewController {
    
    @IBAction func newCardButtonHandler(_ sender: AnyObject) {
        let card = Card(id: UUID().uuidString, title: "new card", text: "Text")
        self.stack?.cards.append(card)
        self.tableView.reloadData()
        
        let stackStorage = StackStorage()
        stackStorage.save(stack: stack!)
    }
    
    @IBAction func backButtonHandler(_ sender: AnyObject) {
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
