//
//  CoreTabControllerOutput.swift
//  Rewise
//
//  Created by Igor Nikolaev on 18/07/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

protocol CoreTabControllerOutput {
    var onMenu: (() -> ())? { get set }
}