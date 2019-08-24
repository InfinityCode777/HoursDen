//
//  ActivityModel.swift
//  Hour
//
//  Created by Jing Wang on 8/21/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit

public struct ActivityModel {
    var category: String
    var name: String
    var desc: String?
    
    init(category: String, name: String, desc: String) {
        self.category = category
        self.name = name
        self.desc = name
    }
}
