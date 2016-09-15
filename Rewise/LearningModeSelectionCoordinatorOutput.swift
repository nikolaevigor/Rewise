//
//  LearningModeSelectionCoordinatorOutput.swift
//  Rewise
//
//  Created by Igor Nikolaev on 13/09/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation

protocol LearningModeSelectionCoordinatorOutput {
    var onMenu: (() -> ())? { get set }
    var onLearning: ((LearningMode) -> ())? { get set }
}