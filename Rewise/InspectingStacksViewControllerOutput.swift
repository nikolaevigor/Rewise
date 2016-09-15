//
//  InspectingStacksViewControllerOutput.swift
//  Rewise
//
//  Created by Igor Nikolaev on 28/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation

protocol InspectingStacksViewControllerOutput {
    var onCloseInspector: (([Stack]) -> ())? { get set }
}