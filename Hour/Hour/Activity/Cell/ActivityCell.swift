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
//    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var startBtn: ActivityButton!
    @IBOutlet weak var canvasView: UIView!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    // Elapsed time in second
    private var elapsedTime: TimeInterval = 0
    
    private var timerStatus: TimeStatus = .stopped
    private var UIDebug: Bool = false
    
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
        if !UIDebug {
            canvasView.backgroundColor = UIColor.clear
            title.backgroundColor = UIColor.clear
            startBtn.backgroundColor = UIColor.clear
            timerLabel.backgroundColor = UIColor.clear
        }
        
//        startBtn.titleLabel?.numberOfLines = 1
//        startBtn.titleLabel?.adjustsFontSizeToFitWidth = true
//        timerLabel.adjustsFontSizeToFitWidth = true
//        title.adjustsFontSizeToFitWidth = true
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
//        canvasView.layer.cornerRadius = 5
//        canvasView.layer.masksToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // TODO
    }
    
    func loadData() {
        self.title.text = activity?.name
//        self.subtitle.text = activity?.name
        //        self.desc = activity?.desc
        title.setFontToFitHeight()
        timerLabel.setFontToFitHeight()
    }

    
    
    func updateUI() {
        startBtn.setTitle(elapsedTime.toDisplayTime(), for: .normal)
    }
    
}


extension ActivityCell: Listner {
    func onEvent(_ event: Event, userInfo: Any) {
        elapsedTime += 1
//        startBtn.setTitle(elapsedTime.toDisplayTime(), for: .normal, animated: false)
        timerLabel.text = elapsedTime.toDisplayTime()
    }
}
