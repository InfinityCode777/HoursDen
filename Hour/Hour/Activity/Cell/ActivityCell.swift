//
//  ActivityCell.swift
//  Hour
//
//  Created by Jing Wang on 8/21/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit
import Anchorage

enum TimeStatus {
    case started
    case stopped
    case paused
}



class ActivityCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var startBtn: ActivityButton!
    @IBOutlet weak var pauseBtn: ActivityButton!
    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // Elapsed time in second
    private var elapsedTime: TimeInterval = 0
    
    private var timerStatus: TimeStatus = .stopped { didSet {
        onTimerStatusChanged()
        }
    }
    private var UIDebug: Bool = false
    
    //TOTO we need to fnd way to link model with view/cell
    public var activity: ActivityModel? { didSet {
        loadData()
        }}
    
    public func resetTimer() {
        
    }
    
    public func startTimer() {
        timerStatus = .started
        timerLabel.isHidden = false
        canvasView.backgroundColor = activity?.bgColor ?? .black
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.65)
        //        startStopBtn.isHidden = true
        PubSub.shared.register(.UpdateTimer, listner: self)
    }
    
    public func pauseTimer() {
        
    }
    public func stopTimer() {
        timerStatus = .stopped
        timerLabel.isHidden = true
        canvasView.backgroundColor = .black
        title.textColor = activity?.bgColor ?? .lightGray
        //        startStopBtn.isHidden = false
        PubSub.shared.unregister(.UpdateTimer, listner: self)
    }
    
    public var startButtonTappedHandler: ((_ sender: ActivityCell) -> ())?
    
    @IBAction func onStartBtnTapped(_ sender: ActivityButton) {
        timerStatus = .started
        self.startButtonTappedHandler?(self)
    }
    
    @IBAction func onPauseBtnTapped(_ sender: ActivityButton) {
        //        self.startButtonTappedHandler?(self)
        timerStatus = .paused
    }
    
    @IBAction func onResumeBtnTapped(_ sender: UIButton) {
        //        self.startButtonTappedHandler?(self)
        timerStatus = .started
    }
    
    @IBAction func onStopBtnTapped(_ sender: UIButton) {
        //        self.startButtonTappedHandler?(self)
        timerStatus = .stopped
    }
    
    
    
    func onTimerStatusChanged(){
        switch timerStatus {
        case .started:
            timerLabel.isHidden = false
            canvasView.backgroundColor = activity?.bgColor ?? .black
            title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.65)
            PubSub.shared.register(.UpdateTimer, listner: self)
            startBtn.isEnabled = false
            pauseBtn.isEnabled = false
            // All above needs to happen immediately without delay
            layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           animations: { [weak self] in
                            self?.startBtn.alpha = 0
                }, completion: { [weak self] _ in
                    self?.startBtn.isEnabled = true
                    self?.pauseBtn.isEnabled = true
            })
            
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           animations: { [weak self] in
                            self?.pauseBtn.alpha = 0.08
                }, completion: { _ in
                    
            })
            
            
            
        case .stopped:
            //            startTimer()
            //            sender.alpha = 0.05
            //            timerStatus = .stopped
            timerLabel.isHidden = true
            canvasView.backgroundColor = .black
            title.textColor = activity?.bgColor ?? .lightGray
            //        startStopBtn.isHidden = false
            PubSub.shared.unregister(.UpdateTimer, listner: self)
            
        case .paused:
            //            timerLabel.isHidden = false
            //            canvasView.backgroundColor = activity?.bgColor ?? .black
            //            title.textColor = .white
            PubSub.shared.unregister(.UpdateTimer, listner: self)
            startBtn.isEnabled = false
            pauseBtn.isEnabled = false
            resumeBtn.isEnabled = false
            stopBtn.isEnabled = false
            pauseBtn.alpha = 0
            
            // All above needs to happen immediately without delay
            layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           animations: { [weak self] in
                            self?.title.alpha = 0.5
                            self?.canvasView.alpha = 0.5
                            
                }, completion: { [weak self] _ in
                    self?.startBtn.isEnabled = true
                    self?.pauseBtn.isEnabled = true
            })
            
            resumeBtn.trailingAnchor == canvasView.trailingAnchor
            stopBtn.leadingAnchor == canvasView.leadingAnchor
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: { [weak self] in
                            self?.layoutIfNeeded()
                }, completion: {[weak self] _ in
                    self?.resumeBtn.isEnabled = true
                    self?.stopBtn.isEnabled = true
            })
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !UIDebug {
            title.backgroundColor = UIColor.clear
            timerLabel.backgroundColor = UIColor.clear
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // TODO
    }
    
    func loadData() {
        self.title.text = activity?.name
        
        // TODO: since autolayout is not completed yet, so everything here will be based on 159x159 cell, Jing, 9/12/19
        //        title.setFontToFitHeight()
        //        timerLabel.text = elapsedTime.toDisplayTime()
        //        timerLabel.setFontToFitHeight()
        //        timerLabel.setKernSpacing()
        //        timerLabel.setFontToFit()
        
        
        startBtn.backgroundColor = activity?.bgColor ?? .darkGray
        startBtn.borderColor = activity?.bgColor ?? .lightGray
        canvasView.borderColor = activity?.bgColor ?? .lightGray
        title.textColor = activity?.bgColor ?? .white
        timerLabel.isHidden = true
        
    }
    
    //
    //    func updateUI() {
    //        startStopBtn.setTitle(elapsedTime.toDisplayTime(), for: .normal)
    //    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        // TODO: Alternative, what is the diff between masksToBounds and clipsToBounds
        //        contentView.roundedCourner(radius: 5)
    }
    
}


extension ActivityCell: Listner {
    func onEvent(_ event: Event, userInfo: Any) {
        elapsedTime += 1
        //        startBtn.setTitle(elapsedTime.toDisplayTime(), for: .normal, animated: false)
        timerLabel.text = elapsedTime.toDisplayTime()
    }
}
