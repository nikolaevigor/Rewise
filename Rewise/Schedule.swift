//
//  Schedule.swift
//  Rewise
//
//  Created by Igor Nikolaev on 23/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation

struct Schedule {
    var repetitions: [NSDate] = []
    
    init(repetitions: [NSDate]) {
        self.repetitions = repetitions
    }
    
    mutating func setForLongTime() {
        let currentDate = NSDate()
        
        let firstRepeat  = currentDate.dateByAddingTimeInterval(0)
        let secondRepeat = currentDate.dateByAddingTimeInterval(30*60)
        let thirdRepeat  = currentDate.dateByAddingTimeInterval(24*60*60)
        let forthRepeat  = currentDate.dateByAddingTimeInterval(14*24*60*60)
        let fifthRepeat  = currentDate.dateByAddingTimeInterval(60*24*60*60)
        
        self.repetitions = [firstRepeat, secondRepeat, thirdRepeat, forthRepeat, fifthRepeat]
    }
    
    mutating func setForShortTime() {
        let currentDate = NSDate()
        
        let firstRepeat  = currentDate.dateByAddingTimeInterval(0)
        let secondRepeat = currentDate.dateByAddingTimeInterval(20*60)
        let thirdRepeat  = currentDate.dateByAddingTimeInterval(8*60*60)
        let forthRepeat  = currentDate.dateByAddingTimeInterval(24*60*60)
        
        self.repetitions = [firstRepeat, secondRepeat, thirdRepeat, forthRepeat]
    }
}