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
    var colorTable:[UIColor] = [#colorLiteral(red: 0.6862745098, green: 0.0431372549, blue: 0.2196078431, alpha: 1), #colorLiteral(red: 0.7529411765, green: 0.06666666667, blue: 0, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.2980392157, blue: 0, alpha: 1), #colorLiteral(red: 0.8431372549, green: 0.5254901961, blue: 0, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0.01568627451, blue: 0.6235294118, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.1803921569, blue: 0.7450980392, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.5764705882, blue: 0.003921568627, alpha: 1)]
    var activityTimer: Timer?
    var flowLayout: UICollectionViewFlowLayout?
    var testCounter: Int = 0
    var activityCellWidth: CGFloat = 0
    var itemSpacing: CGFloat = ((19/375)*UIScreen.main.bounds.width).rounded()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        itemSpacing = itemSpacing.rounded()
        
        activityCellWidth = (UIScreen.main.bounds.width - 3*itemSpacing)/2.0
        //        var activityCellWidth = (activityOverview.bounds.width - 70)/2.0
        activityCellWidth = activityCellWidth.rounded(.down)
        
        flowLayout = activityOverview.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: activityCellWidth, height: activityCellWidth)
        //        flowLayout?.estimatedItemSize = CGSize(width: activityCellWidth, height: activityCellWidth)
        flowLayout?.minimumLineSpacing = itemSpacing
        flowLayout?.minimumInteritemSpacing = itemSpacing
        flowLayout?.sectionInset = UIEdgeInsets(top: 0,
                                                left: itemSpacing,
                                                bottom: 0,
                                                right: itemSpacing)
        
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
        
        for idx in 0..<activityList.count {
            activityList[idx].bgColor = colorTable[idx % 8]
        }
        
        activityOverview.delegate = self
        activityOverview.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
//        cell.contentView.backgroundColor = colorTable[indexPath.row % 8]
        cell.startButtonTappedHandler = { [weak self] sender in
            self?.onStartBtnTapped(sender)
        }
        
        
        //        cell.sizeAnchors == CGSize(width: activityCellWidth, height: activityCellWidth)
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }

    
}



// Callback handling from ActivityCell
extension ActivityOverviewVC {
    
    func onStartBtnTapped(_ sender: ActivityCell) {
        if activityTimer == nil {
            activityTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] _ in
                PubSub.shared.post(.UpdateTimer, userInfo: [])
                //                self?.testCounter += 1
                //                print("TimerStarts >> Tick >> \(self?.testCounter) ")
                //
            })
        }
        //        if let activityCell = activityOverview.visibleCells.first as? ActivityCell {
        //            print("activityCell.timerLabel.frame >> \(activityCell.timerLabel.frame)")
        //        }
        
//        sender.title.setFontToFitHeight()
//        sender.timerLabel.text = (TimeInterval(0)).toDisplayTime()
//        //        timerLabel.setFontToFitHeight()
//        sender.timerLabel.setKernSpacing()
//        sender.timerLabel.setFontToFit()
        
    }
    
    override func viewDidLayoutSubviews() {
//        // At this point, the frame of cell is still the init value, and it seems that autolayout has not taken effect yet. By Jing, 9/20/19
//        if activityOverview.visibleCells.count > 0 {
//            if let activityCell = activityOverview.visibleCells.first as? ActivityCell {
//                print("1.activityCell.timerLabel.frame >> \(activityCell.timerLabel.frame)")
//            }
//        }
    }
    
    override func viewWillLayoutSubviews() {
        if activityOverview.visibleCells.count > 0 {
            if let activityCell = activityOverview.visibleCells.first as? ActivityCell {
                print("2.activityCell.timerLabel.frame >> \(activityCell.timerLabel.frame)")
            }
        }
    }
    
}

// Utils for navigation
extension ActivityOverviewVC {
    func prepare(for segue: UIStoryboardSegue, sender: ActivityCell) {
        
    }
}


//// Utils for flow layout May cause some conflicts
//extension UICollectionViewDelegateFlowLayout {
//
//}
