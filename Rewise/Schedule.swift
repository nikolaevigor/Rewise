//
//  Schedule.swift
//  Rewise
//
//  Created by Igor Nikolaev on 23/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import Foundation

struct Schedule {
    var repetitions: [Date] = []
    
    init(repetitions: [Date]) {
        self.repetitions = repetitions
    }
    
    mutating func setForLongTime() {
        let currentDate = Date()
        
        let firstRepeat  = currentDate.addingTimeInterval(0)
        let secondRepeat = currentDate.addingTimeInterval(30*60)
        let thirdRepeat  = currentDate.addingTimeInterval(24*60*60)
        let forthRepeat  = currentDate.addingTimeInterval(14*24*60*60)
        let fifthRepeat  = currentDate.addingTimeInterval(60*24*60*60)
        
        self.repetitions = [firstRepeat, secondRepeat, thirdRepeat, forthRepeat, fifthRepeat]
    }
    
    mutating func setForShortTime() {
        let currentDate = Date()
        
        let firstRepeat  = currentDate.addingTimeInterval(0)
        let secondRepeat = currentDate.addingTimeInterval(20*60)
        let thirdRepeat  = currentDate.addingTimeInterval(8*60*60)
        let forthRepeat  = currentDate.addingTimeInterval(24*60*60)
        
        self.repetitions = [firstRepeat, secondRepeat, thirdRepeat, forthRepeat]
    }
}
