//
//  ActivityModel.swift
//  Hour
//
//  Created by Jing Wang on 8/21/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

// By Jing 2019/11/23
// A note to myself that, this is only the mode for display

import UIKit

public struct ActivityModel {
    // E.g. work, personal, work-out, etc.
    var category: String
    var name: String
    // Used as key in database
    var UID: UUID
    var bgColor: UIColor
    // Equivalent to the name but optional, if not everyone likes to use emoji
    var emoji: String?
    var startTime: Date
    var endTime: Date
    var elapsedTime: TimeInterval
    var desc: String?
    
    public init(category: String = "unknown", name: String = "activity", UID: UUID = UUID(), bgColor: UIColor = .green, emoji: String? = "😊", startTime: Date = Date(), endTime: Date = Date(), elapsedTime: TimeInterval = 0, desc: String? = nil) {
        self.category = category
        self.name = name
        self.UID = UID
        self.bgColor = bgColor
        self.emoji = emoji
        self.startTime = startTime
        self.endTime = endTime
        self.elapsedTime = elapsedTime
        self.desc = desc
    }

    // TODO: What is the best practice to 
    //    init(_ name: String){
    //        self.init(category: "unknown", name: name, UID: UUID(), bgColor: .green, emoji: "🐯", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: nil)
    //    }
    public static func makeMockData() -> [ActivityModel] {
        
        var activityList = [ActivityModel]()
        
        activityList = [
            ActivityModel(category: "Work", name: "dev", bgColor: pickRandomColor(), emoji: "🐭", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on coding, testing and deployment"),
        ActivityModel(category: "Work", name: "meeting", bgColor: pickRandomColor(), emoji: "🐂", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on all kinds of meetings, planning and discusstion"),
        ActivityModel(category: "Work", name: "office chore", bgColor: pickRandomColor(), emoji: "🐯", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent misc office duty, e.g. order something, moving office and assemble furniture"),
        ActivityModel(category: "Work", name: "Data  collection", bgColor: pickRandomColor(), emoji: "🐰", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on all data collection session either for dev purpose or requested by other groups"),
        ActivityModel(category: "Work", name: "Tech support", bgColor: pickRandomColor(), emoji: "🐲", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "The time spent on setting up demo for tools & software both internally and externally"),
        ActivityModel(category: "Work", name: "Commute", bgColor: pickRandomColor(), emoji: "🐍", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on all kinds of transportation to company or to the clients"),
        ActivityModel(category: "Work", name: "Lunch", bgColor: pickRandomColor(), emoji: "🐎", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on your lunch break"),
        ActivityModel(category: "Work", name: "Maintain", bgColor: pickRandomColor(), emoji: "🐑", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on all kinds of maintenance, e.g. repairing computers, setting up new development environment"),
        ActivityModel(category: "Work", name: "Learning", bgColor: pickRandomColor(), emoji: "🐒", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on tutorials"),
        ActivityModel(category: "Work", name: "Relax", bgColor: pickRandomColor(), emoji: "🐓", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on relax and stretch"),
        ActivityModel(category: "Work", name: "Health", bgColor: pickRandomColor(), emoji: "🐶", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "Time spent on all kinds of health issues, primarily doctor's appointment"),
        ActivityModel(category: "Work", name: "Idle", bgColor: pickRandomColor(), emoji: "🐷", startTime: Date(), endTime: Date(), elapsedTime: 0, desc: "That's it, the idle time, should be the less the better"),
        ]
        
        return activityList
    }
    
    
    private static func pickRandomColor() -> UIColor {
        let colorTable:[UIColor] = [#colorLiteral(red: 0.6862745098, green: 0.0431372549, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.7529411765, green: 0.06666666667, blue: 0, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.2980392157, blue: 0, alpha: 1), #colorLiteral(red: 0.8431372549, green: 0.5254901961, blue: 0, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0.01568627451, blue: 0.6235294118, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.1803921569, blue: 0.7450980392, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.5764705882, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.59, green: 0.177, blue: 0.2871333334, alpha: 1), #colorLiteral(red: 0.7, green: 0.1576822917, blue: 0.105, alpha: 1), #colorLiteral(red: 0.71, green: 0.3505410628, blue: 0.142, alpha: 1), #colorLiteral(red: 0.74, green: 0.5169674419, blue: 0.148, alpha: 1), #colorLiteral(red: 0.43992, green: 0.1196, blue: 0.52, alpha: 1), #colorLiteral(red: 0.26, green: 0.2805263158, blue: 0.65, alpha: 1), #colorLiteral(red: 0.1959452055, green: 0.48, blue: 0.096, alpha: 1),]
        
        guard let pickedColor = colorTable.randomElement() else {
            return #colorLiteral(red: 0.1529411765, green: 0.5764705882, blue: 0.003921568627, alpha: 1)
        }
        
        return pickedColor
        
    }
    
}



