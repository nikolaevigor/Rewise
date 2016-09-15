//
//  SettingsViewControllerOutput.swift
//  Rewise
//
//  Created by Igor Nikolaev on 26/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

protocol SettingsViewControllerOutput {
    var onCloseSettings: (() -> ())? { get set }
}