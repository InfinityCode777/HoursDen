//
//  ActivityOverviewVC.swift
//  Hour
//
//  Created by Jing Wang on 8/21/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit

class ActivityOverviewVC: UIViewController {

    
    @IBOutlet weak var activityOverview: UICollectionView!
    
    
    var activityList = [ActivityModel]()
    var colorTable:[UIColor] = [#colorLiteral(red: 0.2951881886, green: 0.5202374458, blue: 0.7776803374, alpha: 1), #colorLiteral(red: 0.6425715685, green: 0.1104490235, blue: 0.01544517558, alpha: 1), #colorLiteral(red: 0.7791575789, green: 0.7919260263, blue: 0.9991839528, alpha: 1), #colorLiteral(red: 0.6648513079, green: 0.2806694508, blue: 0.528647542, alpha: 1), #colorLiteral(red: 0.7375733256, green: 0.5681271553, blue: 0.1588199437, alpha: 1), #colorLiteral(red: 0.9983283877, green: 0.709824264, blue: 0.6186549067, alpha: 1), #colorLiteral(red: 0.9165030122, green: 0.7589698434, blue: 0.9985856414, alpha: 1), #colorLiteral(red: 0.2929282188, green: 0.5532175899, blue: 0.2777415812, alpha: 1)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityList = [ActivityModel(category: "Work", name: "dev", activitDesc: nil),
        ActivityModel(category: "Work", name: "meeting", activitDesc: nil),
        ActivityModel(category: "Work", name: "office chore", activitDesc: nil),
        ActivityModel(category: "Work", name: "data collection", activitDesc: nil),
        ActivityModel(category: "Work", name: "tech support", activitDesc: nil),
        ActivityModel(category: "Work", name: "commute", activitDesc: nil),
        ActivityModel(category: "Work", name: "lunch", activitDesc: nil)]
        
        
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCellType1", for: indexPath) as! ActivityCell
        let activity = activityList[indexPath.row]
        cell.activityTitle.text = activity.category
        cell.activitySubtitle.text = activity.name
        cell.backgroundColor = colorTable[indexPath.row % 8]
        return cell
    }
    
    
}

