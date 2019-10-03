//
//  ActivityCell.swift
//  Hour
//
//  Created by Jing Wang on 8/21/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit
import Anchorage

enum TimerStatus {
    case started
    case resumed
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
    
    @IBOutlet private weak var resumeBtnTrailingContraint: NSLayoutConstraint!
    @IBOutlet private weak var stopBtnLeadingContraint: NSLayoutConstraint!
    
    private var utilBtnGroup = [UIButton]()
    
    // Elapsed time in second
    private var elapsedTime: TimeInterval = 0
    
    private var timerStatus: TimerStatus = .stopped { didSet {
        onTimerStatusChanged()
        }}
    
    private var UIDebug: Bool = false
    
    //TOTO we need to fnd way to link model with view/cell
    public var activity: ActivityModel? { didSet {
        loadData()
        }}
    
    private lazy var backdropView: UIView = {
        let view = UIView(frame: canvasView.frame)
        view.frame.size = CGSize(width: 10, height: 10)
        //        view.layer.cornerRadius = 5
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return view
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !UIDebug {
            title.backgroundColor = UIColor.clear
            timerLabel.backgroundColor = UIColor.clear
        }
        
        utilBtnGroup.append(startBtn)
        utilBtnGroup.append(pauseBtn)
        utilBtnGroup.append(resumeBtn)
        utilBtnGroup.append(stopBtn)
        
        initUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // TODO
        initUI()
    }
    
    
    //    public func resetTimer() {
    //    }
    //
    //    public func startTimer() {
    //        timerStatus = .started
    //        timerLabel.isHidden = false
    //        canvasView.backgroundColor = activity?.bgColor ?? .black
    //        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.65)
    //        //        startStopBtn.isHidden = true
    //        PubSub.shared.register(.UpdateTimer, listner: self)
    //    }
    //
    //    public func pauseTimer() {
    //        timerStatus = .paused
    //    }
    //
    //    public func stopTimer() {
    //        timerStatus = .stopped
    ////        timerLabel.isHidden = true
    //        canvasView.backgroundColor = .black
    //        title.textColor = activity?.bgColor ?? .lightGray
    //        //        startStopBtn.isHidden = false
    //        PubSub.shared.unregister(.UpdateTimer, listner: self)
    //    }
    
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
        timerStatus = .resumed
    }
    
    @IBAction func onStopBtnTapped(_ sender: UIButton) {
        //        self.startButtonTappedHandler?(self)
        timerStatus = .stopped
    }
    
    
    func onTimerStatusChanged(){
        switch timerStatus {
        case .started:
            PubSub.shared.register(.UpdateTimer, listner: self)
            title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.65)
            enableButton(utilBtnGroup, with: getArray(of: false, count: utilBtnGroup.count))
            backdropView.backgroundColor = activity?.bgColor ?? .black
            //            // DEBUG
            //            backdropView.backgroundColor = .white
            
            //            backdropView.center = canvasView.center
            
            // Add the backdrop for animation
            canvasView.insertSubview(backdropView, at: 0)
            backdropView.center = canvasView.center
            
            // All above needs to happen immediately without delay
            layoutIfNeeded()
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: [.curveEaseOut],
                           animations: { [weak self] in
                            self?.backdropView.alpha = 1
                            self?.timerLabel.transform = .identity
                            self?.timerLabel.alpha = 1

                            // Start button disappears
                            self?.startBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                            self?.startBtn.alpha = 0
                            
                            self?.backdropView.bounds.size = self?.canvasView.bounds.size.scaleBy(sx: 1.0, sy: 1.0) ?? CGSize(width: 0.1, height: 0.1)
                            self?.layoutIfNeeded()
                            
                            //                            self?.backdropView.layer.cornerRadius = 5
                            
                            //                            let sx = ( self?.canvasView.bounds.size.width ?? 0 )/(self?.backdropView.bounds.width ?? 1)*1.2
                            //                            let sy = ( self?.canvasView.bounds.size.height ?? 0 )/(self?.backdropView.bounds.height ?? 1)*1.2
                            //                            self?.backdropView.transform = CGAffineTransform(scaleX: sx, y: sy)
                            
                }, completion: { [weak self] _ in
                    self?.startBtn.isEnabled = true
                    self?.pauseBtn.isEnabled = true
                    self?.pauseBtn.alpha = 1
                    //                    self?.startBtn.transform = .identity
                    self?.canvasView.backgroundColor = self?.activity?.bgColor
                    
                    self?.backdropView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    self?.backdropView.bounds.size = CGSize(width: 0.1, height: 0.1)
                    self?.backdropView.removeFromSuperview()
                    self?.canvasView.borderWidth = 0
                    //                    self?.backdropView.transform = .identity
            })
        case .stopped:
            PubSub.shared.unregister(.UpdateTimer, listner: self)
            canvasView.backgroundColor = .black
            title.textColor = activity?.bgColor ?? .lightGray
            layoutIfNeeded()
            
            // Disable all button after tapping
            enableButton(utilBtnGroup, with: getArray(of: false, count: utilBtnGroup.count))
            
            
            canvasView.insertSubview(backdropView, at: 0)
            backdropView.bounds = canvasView.bounds
            backdropView.backgroundColor = activity?.bgColor
            
                resumeBtnTrailingContraint.constant = 0
                stopBtnLeadingContraint.constant = 0
            
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
//                            self.layoutIfNeeded()
                            self.backdropView.bounds.size = CGSize(width: 0.1, height: 0.1)
                            self.backdropView.alpha = 0
                            self.startBtn.transform = .identity
                            self.startBtn.alpha = 1
                            //                                self.canvasView.alpha = 1
//                            self.title.alpha = 1
                            self.timerLabel.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//                            self.timerLabel.text = "00:00"
                            self.timerLabel.alpha = 0
                            self.canvasView.borderWidth = 3
                            
                            self.layoutIfNeeded()

                            
                }, completion: {_ in
                    self.startBtn.isEnabled = true
                    self.elapsedTime = 0
//                    self.timerLabel.text = "00:00"


            })
            
        case .resumed:
            // Subscribe to timer
            PubSub.shared.register(.UpdateTimer, listner: self)
            // Disable all button after tapping
            enableButton(utilBtnGroup, with: getArray(of: false, count: utilBtnGroup.count))
            
            // // TODO:
            // Need to synchronize with this animation
            //            animateResumeStop(status: timerStatus){ _ in
            //                self.enableButton(self.utilBtnGroup, with: self.getArray(of: true, count: self.utilBtnGroup.count))
            //                self.title.alpha = 1
            //            }
            
            resumeBtnTrailingContraint.constant = 0
            stopBtnLeadingContraint.constant = 0
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: { [weak self] in
                            self?.timerLabel.alpha = 1
                            self?.timerLabel.transform = .identity
                            self?.layoutIfNeeded()
                }, completion: {_ in
                    self.enableButton(self.utilBtnGroup, with: self.getArray(of: true, count: self.utilBtnGroup.count))
            })
        case .paused:
            // Unsubscribe from timer
            PubSub.shared.unregister(.UpdateTimer, listner: self)
            // Disable all button after tapping
            enableButton(utilBtnGroup, with: getArray(of: false, count: utilBtnGroup.count))
            
            // All above needs to happen immediately without delay
            layoutIfNeeded()
            
            
            UIView.animate(withDuration: 0.2,
                           delay: 0,options: [.curveEaseIn],
                           animations: { [weak self] in
//                            self?.title.alpha = 0.8
                            self?.timerLabel.alpha = 0
                            self?.timerLabel.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                            
                }, completion: { _ in
                    self.enableButton(self.utilBtnGroup, with: [false, false, true, true])
            })
            
            //            resumeBtnTrailingContraint.constant = resumeBtn.bounds.width
            //            stopBtnLeadingContraint.constant = -stopBtn.bounds.width
            //
            //            UIView.animate(withDuration: 0.3,
            //                           delay: 0,
            //                           options: [.curveEaseOut],
            //                           animations: { [weak self] in
            //                            self?.layoutIfNeeded()
            //                }, completion: {[weak self] _ in
            //                    self?.resumeBtn.isEnabled = true
            //                    self?.stopBtn.isEnabled = true
            //            })
            
            enableButton(utilBtnGroup, with: getArray(of: false, count: utilBtnGroup.count))
            animateResumeStop(status: timerStatus){[weak self] _ in
                self?.resumeBtn.isEnabled = true
                self?.stopBtn.isEnabled = true
            }
        }
        
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
        resumeBtn.setTitleColor(activity?.bgColor, for: .normal)
        timerLabel.alpha = 0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // RWL solution, which also makes sense, in case we change the static part accidentally, but I assume this will be a rare case and comment them out for now, by Jing, 09/20/19
        //        contentView.layer.cornerRadius = 5
        //        contentView.layer.masksToBounds = true
        
        // TODO: This works but it is so stupid and so inefficient, the app need to update the font millions of times as long as the timer kicks
        title.setFontToFit(scaleFactor: 1)
        timerLabel.setFontToFit(scaleFactor: 0.95)
        
        //        print("Trying to layout subviews!")
        
        // TODO: Alternative, what is the diff between masksToBounds and clipsToBounds
        //        contentView.roundedCourner(radius: 5)
        
    }
    
    func initUI() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        //        resumeBtn.setTitleColor(activity?.bgColor, for: .normal)
        //        stopBtn.backgroundColor = activity?.bgColor
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print("Frame >> \(self.frame)")
    }
    
    
}


extension ActivityCell: Listner {
    func onEvent(_ event: Event, userInfo: Any) {
        elapsedTime += 1
        timerLabel.text = elapsedTime.toDisplayTime()
    }
}

// All animations
extension ActivityCell {
    func animateResumeStop(status: TimerStatus, completion: @escaping (Bool) -> Void ) {
        
        //        utilBtnGroup.forEach( {$0.isEnabled = false} )
        
        if status == .paused {
            resumeBtnTrailingContraint.constant = resumeBtn.bounds.width
            stopBtnLeadingContraint.constant = -stopBtn.bounds.width
        }
        else {
            resumeBtnTrailingContraint.constant = 0
            stopBtnLeadingContraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: { [weak self] in
                        self?.layoutIfNeeded()
            }, completion: {result in
                completion(result)
        })
        
    }
    
    func enableButton(_ buttonGroup: [UIButton], with status: [Bool]) {
        if buttonGroup.count != status.count { return }
        for idx in 0..<buttonGroup.count {
            buttonGroup[idx].isEnabled = status[idx]
        }
    }
    
    func setButtonAlpa(_ buttonGroup: [UIButton], with values: [CGFloat]) {
        if buttonGroup.count != values.count { return }
        for idx in 0..<buttonGroup.count {
            buttonGroup[idx].alpha = values[idx]
        }
        
    }
    
    func getArray<T>(of value: T, count: Int) -> [T] {
        var array = [T]()
        array = Array(repeating: value, count: count)
        return array
    }
    
}

extension CGSize {
    func changeBy(dx: CGFloat, dy: CGFloat) -> CGSize {
        return CGSize(width: self.width + dx, height: self.height + dy)
    }
    
    func scaleBy(sx: CGFloat, sy: CGFloat) -> CGSize {
        guard 0 <= sx && sx <= 1 && 0 <= sy && sy <= 1 else { return self}
        return CGSize(width: self.width*sx, height: self.height*sy)
    }
}



// Code saved for .stopped (in order)


//            animateResumeStop(status: timerStatus, completion: {[weak self]_ in
//                self?.title.alpha = 1
//                self?.canvasView.alpha = 1
//                            self?.timerLabel.text = ""
//                            self?.timerLabel.isHidden = true
//                self?.startBtn.alpha = 1
//                self?.startBtn.isEnabled = true
//                self?.startBtn.transform = .identity
//
//                TODO
//                set the color of content view instead of the canvas view and see what you can get
//
//            })
//            timerLabel.text = "00:00"
//            layoutIfNeeded()



//            animateResumeStop(status: timerStatus, completion: {_ in
//                UIView.animate(withDuration: 0.2,
//                               delay: 0,
//                               options: [.curveEaseOut],
//                               animations: {
//                                self.backdropView.bounds.size = CGSize(width: 0.1, height: 0.1)
//                                self.backdropView.alpha = 0
//                                self.startBtn.transform = .identity
//                                self.startBtn.alpha = 1
//                                //                                self.canvasView.alpha = 1
//                                self.title.alpha = 1
//                                self.timerLabel.text = "00:00"
//                                self.timerLabel.alpha = 0
//                                self.canvasView.borderWidth = 3
//
//                                self.timerLabel.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//                                self.timerLabel.alpha = 0
//                                //                                self.backdropView.layer.cornerRadius = 5
//
//                },
//                               completion:  {_ in
//                                self.startBtn.isEnabled = true
////                                self.timerLabel.alpha = 0
//
//                })
//            })
//            layoutIfNeeded()
