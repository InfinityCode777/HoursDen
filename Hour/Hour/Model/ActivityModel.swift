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
    var UID: UUID
    var desc: String?
    
    init(category: String, name: String, desc: String?, UID: UUID) {
        self.category = category
        self.name = name
        self.desc = name
        self.UID = UID
    }
}
