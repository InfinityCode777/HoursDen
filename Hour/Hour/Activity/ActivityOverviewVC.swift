//
//  ActivityOverviewVC.swift
//  Hour
//
//  Created by Jing Wang on 8/21/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit
import Anchorage

class ActivityOverviewVC: ActivityBaseVC {

    
    @IBOutlet weak var activityOverview: UICollectionView!
    
    
    var activityList = [ActivityModel]()
    var colorTable:[UIColor] = [#colorLiteral(red: 0.2951881886, green: 0.5202374458, blue: 0.7776803374, alpha: 1), #colorLiteral(red: 0.6425715685, green: 0.1104490235, blue: 0.01544517558, alpha: 1), #colorLiteral(red: 0.7791575789, green: 0.7919260263, blue: 0.9991839528, alpha: 1), #colorLiteral(red: 0.6648513079, green: 0.2806694508, blue: 0.528647542, alpha: 1), #colorLiteral(red: 0.7375733256, green: 0.5681271553, blue: 0.1588199437, alpha: 1), #colorLiteral(red: 0.9983283877, green: 0.709824264, blue: 0.6186549067, alpha: 1), #colorLiteral(red: 0.9165030122, green: 0.7589698434, blue: 0.9985856414, alpha: 1), #colorLiteral(red: 0.2929282188, green: 0.5532175899, blue: 0.2777415812, alpha: 1)]
    var activityTimer: Timer?
    var flowLayout: UICollectionViewFlowLayout?
    var testCounter: Int = 0
    var activityCellWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityCellWidth = (UIScreen.main.bounds.width - 12)/2.0
        //        var activityCellWidth = (activityOverview.bounds.width - 70)/2.0
        activityCellWidth = activityCellWidth.rounded(.down)

        flowLayout = activityOverview.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.estimatedItemSize = CGSize(width: activityCellWidth, height: activityCellWidth)
        flowLayout?.minimumLineSpacing = 12
        flowLayout?.minimumInteritemSpacing = 12
        
        let activityCellNib = UINib(nibName: "\(ActivityCell.self)", bundle: nil)
        activityOverview.register(activityCellNib, forCellWithReuseIdentifier: "Type1")
        
        
        activityList = [
            ActivityModel(category: "Work", name: "dev", desc: nil, UID: UUID()),
            ActivityModel(category: "Work", name: "meeting", desc: nil, UID: UUID()),
            ActivityModel(category: "Work", name: "office chore", desc: nil, UID: UUID()),
            ActivityModel(category: "Work", name: "data collection", desc: nil, UID: UUID()),
            ActivityModel(category: "Work", name: "tech support", desc: nil, UID: UUID()),
            ActivityModel(category: "Work", name: "commute", desc: nil, UID: UUID()),
            ActivityModel(category: "Work", name: "lunch", desc: nil, UID: UUID())
        ]
        
        
        
        activityOverview.delegate = self
        activityOverview.dataSource = self
        
        activityOverview.reloadData()
        
        
        
        
        
    }


}

extension ActivityOverviewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Type1", for: indexPath) as! ActivityCell
        let activity = activityList[indexPath.row]
        
        cell.activity = activity
//        cell.backgroundColor = colorTable[indexPath.row % 8]
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = colorTable[indexPath.row % 8]
        cell.startButtonTappedHandler = { [weak self] sender in
            self?.onStartBtnTapped(sender)
        }
        
//        cell.sizeAnchors == CGSize(width: activityCellWidth, height: activityCellWidth)
        
        return cell
    }
    
    
}



// Callback handling from ActivityCell
extension ActivityOverviewVC {
    
    func onStartBtnTapped(_ sender: ActivityButton) {
        if activityTimer == nil {
            activityTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] _ in
                PubSub.shared.post(.UpdateTimer, userInfo: [])
//                self?.testCounter += 1
//                print("TimerStarts >> Tick >> \(self?.testCounter) ")
//                
            })
        }
    }
    
}


extension ActivityOverviewVC {
     func prepare(for segue: UIStoryboardSegue, sender: ActivityCell) {
        
    }
}
