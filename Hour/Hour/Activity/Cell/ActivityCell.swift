//
//  ActivityCell.swift
//  Hour
//
//  Created by Jing Wang on 8/21/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit

enum TimeStatus {
    case started
    case stopped
}



class ActivityCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var startBtn: ActivityButton!
    
    // Elapsed time in second
    private var elapsedTime: TimeInterval = 0
    
    private var timerStatus: TimeStatus = .stopped
    
    
    //TOTO we need to fnd way to link model with view/cell
    public var activity: ActivityModel? { didSet {
        loadData()
        }}
    
    public func resetTimer() {
        
    }
    
    public func startTimer() {
        timerStatus = .started
        PubSub.shared.register(.UpdateTimer, listner: self)
    }
    
    public func pauseTimer() {
        
    }
    
    public func stopTimer() {
        timerStatus = .stopped
        PubSub.shared.unregister(.UpdateTimer, listner: self)
    }
    
    public var startButtonTappedHandler: ((_ sender: ActivityButton) -> ())?
    
    @IBAction func onStartBtnTapped(_ sender: ActivityButton) {
        self.startButtonTappedHandler?(sender)
        
        switch timerStatus {
        case .started:
            stopTimer()
        case .stopped:
            startTimer()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // TODO
    }
    
    func loadData() {
        self.title.text = activity?.category
        self.subtitle.text = activity?.name
        //        self.desc = activity?.desc
    }

    
    
    func updateUI() {
        startBtn.setTitle(elapsedTime.toDisplayTime(), for: .normal)
    }
    
}


extension ActivityCell: Listner {
    func onEvent(_ event: Event, userInfo: Any) {
        elapsedTime += 1
        startBtn.setTitle(elapsedTime.toDisplayTime(), for: .normal, animated: false)
    }
}