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
    var activityTimer: Timer?
    var flowLayout: UICollectionViewFlowLayout?
    var testCounter: Int = 0
    var activityCellWidth: CGFloat = 0
    var itemSpacing: CGFloat = ((19/375)*UIScreen.main.bounds.width).rounded()
    
    var transitionAnimator = PopAnimator()
    
    var isUIDebug: Bool = false
    
    // Make the Status Bar Light/Dark Content for this View
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        activityList = ActivityModel.makeMockData()
        
        activityOverview.delegate = self
        activityOverview.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityOverview.reloadData()
        //        JLog.debug("PubSub >> Back to overview >>")
        //        PubSub.shared.ls()
        //        JLog.debug("PubSub >> Back to overview >> \(PubSub.shared.listners)")
        if !isUIDebug {
            activityOverview.backgroundColor = .black
            view.backgroundColor = .black
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        JLog.debug("PubSub >> Leave overview >>")
        //        PubSub.shared.ls()
        //        JLog.debug("PubSub >> Leave overview >> \(PubSub.shared.listners)")
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
        cell.contentView.backgroundColor = activity.bgColor
        cell.startButtonTappedHandler = { [weak self] sender in
            self?.onStartBtnTapped(sender)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let activityCell = collectionView.cellForItem(at: indexPath) as? ActivityCell else { return }
        
        // 1.Using segue
        performSegue(withIdentifier: "activityDetail", sender: activityCell)
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //        // 2.Directly present,
        //        // This does not 100% work, the presented VC does not cover the screen 100%
        //        let storyboard = UIStoryboard(name: "ActivityOverview", bundle: .main)
        //
        //        guard
        //            let activityDetailVC = storyboard.instantiateViewController(withIdentifier: "activityDetail") as? ActivityDetailVC2
        //            else {
        //            print("Fail to init VC from storyboard")
        //            return
        //        }
        //        modalPresentationStyle = .overFullScreen
        //        print("Style >> \(modalPresentationStyle.rawValue)")
        //        activityDetailVC.activity = activityCell.activity
        //        activityDetailVC.transitioningDelegate = self
        //        present(activityDetailVC, animated: true)
    }    
}



// Callback handling from ActivityCell
extension ActivityOverviewVC {
    
    func onStartBtnTapped(_ sender: ActivityCell) {
        if activityTimer == nil {
            activityTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
                PubSub.shared.post(.UpdateTimer, userInfo: [])
            })
        }
    }
    
}

// Utils for navigation
extension ActivityOverviewVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activityDetail" {
            if let activityCell = sender as? ActivityCell {
                if let destVC = segue.destination as? ActivityDetailVC2 {
                    destVC.transitioningDelegate = self
                    destVC.activity = activityCell.activity
                }
            }
        }
    }
}

// Animating view controller transition
extension ActivityOverviewVC: UIViewControllerTransitioningDelegate {
    
    // This will be called when the presented delegator VC is presented
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let selectedItemIndexPath = activityOverview.indexPathsForSelectedItems?.first,
            let selectedItem = activityOverview.cellForItem(at: selectedItemIndexPath) as? ActivityCell,
            let selectedItemSuperview = selectedItem.superview
            else {
                return nil
        }
        
        let originalFrame = selectedItemSuperview.convert(selectedItem.frame, to: nil)
        transitionAnimator.originalFrame = CGRect(
            x: originalFrame.origin.x, // + itemSpacing,
            y: originalFrame.origin.y, // + itemSpacing,
            width: originalFrame.width, // - itemSpacing*2,
            height: originalFrame.height // - itemSpacing*2
        )
        
        transitionAnimator.isShowingDetail = true
        
        return transitionAnimator
    }
    
    // This will be called when the presented delegator VC is dismissed
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.isShowingDetail = false
        
        return transitionAnimator
    }
    
}


