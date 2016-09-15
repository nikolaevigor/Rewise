//
//  MenuViewControllerOutput.swift
//  Rewise
//
//  Created by Igor Nikolaev on 24/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

protocol MenuViewControllerOutput {
    var onStart: (() -> ())? { get set }
    var onInspectCards: (() -> ())? { get set }
    var onSettings: (() -> ())? { get set }
}