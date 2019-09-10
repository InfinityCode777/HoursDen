//
//  ExtTimeInterval.swift
//  Hour
//
//  Created by Jing Wang on 8/24/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//


import UIKit

extension TimeInterval {
    
    func toDisplayTime() -> String {
        let hour = Int(self)/3600
        let minute = (Int(self) % 3600)/60
        let second = (Int(self) % 3600) % 60
        
//        return String(format: "%02i:%02i:%02i", hour, minute, second)
        return String(format: "%02i:%02i", minute, second)

        
    }
}
