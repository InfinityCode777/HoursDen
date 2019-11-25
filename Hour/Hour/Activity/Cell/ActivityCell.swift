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
    private var elapsedTime: TimeInterval = 0 { didSet {timerLabel.text = elapsedTime.toDisplayTime()} }
    
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
        initUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // TODO: ?? Do I need to do anything here?
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
        timerStatus = .resumed
    }
    
    @IBAction func onStopBtnTapped(_ sender: UIButton) {
        //        self.startButtonTappedHandler?(self)
        timerStatus = .stopped
    }
    
    @objc func canvasViewTappedHandler(_ sender: Any) {
        print("Canvas View tapped!")
    }
    
    
    func onTimerStatusChanged(){
        switch timerStatus {
        case .started:
            PubSub.shared.register(.UpdateTimer, listner: self)
            title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.65)
            
            enableButton(utilBtnGroup, with: getArray(of: false, count: utilBtnGroup.count))
            timerLabel.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            
            // Add the backdrop for animation
            canvasView.insertSubview(backdropView, at: 0)
            backdropView.center = canvasView.center
            backdropView.backgroundColor = activity?.bgColor ?? .black
            
            // All above needs to happen immediately without delay
            layoutIfNeeded()
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.65,
                           initialSpringVelocity: 0,
                           options: [.curveEaseOut],
                           animations: {
                            // backdropView appears (small -> big, transparent -> opaque)
                            self.backdropView.alpha = 1
                            self.backdropView.bounds.size = self.canvasView.bounds.size.scaleBy(sx: 1.0, sy: 1.0)
                            // timerLabel appears (small -> big, transparent -> opaque)
                            self.timerLabel.transform = .identity
                            self.timerLabel.alpha = 1
                            // Start button disappears (big -> small,  opaque -> transparent)
                            self.startBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                            self.startBtn.alpha = 0
                            // Animate constraint
                            self.layoutIfNeeded()
                            
            }, completion: { _ in
                // TODO: Is that necessary to use [weak self] in this scenario? Since I want to use enableButton() function to do this job
                // Not really, checkout this post
                // https://stackoverflow.com/questions/27019676/is-it-necessary-to-use-unowned-self-in-closures-of-uiview-animatewithduration
                // Enable pauseBtn after timer starts
                self.pauseBtn.isEnabled = true
                // pauseBtn w/ transparent bgColor appears
                self.pauseBtn.alpha = 1
                // Final state of canvasView
                self.canvasView.backgroundColor = self.activity?.bgColor
                self.canvasView.borderWidth = 0
                // Reset and remove backdropView
                self.backdropView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.backdropView.bounds.size = CGSize(width: 0.1, height: 0.1)
                self.backdropView.removeFromSuperview()
            })
            
        case .stopped:
            // Unsubscribe from timer
            PubSub.shared.unregister(.UpdateTimer, listner: self)
            // Disable all buttons after tapping
            enableButton(utilBtnGroup, with: getArray(of: false, count: utilBtnGroup.count))
            // Final state of canvasView
            canvasView.backgroundColor = .black
            canvasView.borderWidth = 3
            // Reset title text color
            title.textColor = activity?.bgColor ?? .lightGray
            // Animate constraint
            layoutIfNeeded()
            
            // Add backdropView for animation
            canvasView.insertSubview(backdropView, at: 0)
            backdropView.bounds = canvasView.bounds
            backdropView.backgroundColor = activity?.bgColor
            
            resumeBtnTrailingContraint.constant = 0
            stopBtnLeadingContraint.constant = 0
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
                            // backdropView disappears (big -> small,  opaque -> transparent)
                            self.backdropView.bounds.size = CGSize(width: 0.1, height: 0.1)
                            self.backdropView.alpha = 0
                            // startBtn appears (small -> big, transparent -> opaque)
                            self.startBtn.transform = .identity
                            self.startBtn.alpha = 1
                            // timerLabel disappears (big -> small,  opaque -> transparent)
                            self.timerLabel.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                            self.timerLabel.alpha = 0
                            // Animate constraint
                            self.layoutIfNeeded()
            }, completion: {_ in
                self.startBtn.isEnabled = true
                self.elapsedTime = 0
                // TODO, by Jing, 10/10/19,
                // Update the timerLabel.text with "00:00", when you hit "Start" next time you will see timerLabel with smaller font sittng there for about one second, since timer event triggers label update.
                self.timerLabel.text = "00:00"
                self.timerLabel.transform = .identity
                //                self.title.textColor = self.activity?.bgColor ?? .lightGray
                // pauseBtn w/ transparent bgColor disappears
                self.pauseBtn.alpha = 0
            })
            
        case .resumed:
            // Subscribe to timer
            PubSub.shared.register(.UpdateTimer, listner: self)
            // Disable all buttons after tapping
            enableButton(utilBtnGroup, with: getArray(of: false, count: utilBtnGroup.count))
            
            resumeBtnTrailingContraint.constant = 0
            stopBtnLeadingContraint.constant = 0
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
                            // timerLabel appears (small -> big, transparent -> opaque)
                            self.timerLabel.transform = .identity
                            self.timerLabel.alpha = 1
                            // Animate constraint
                            self.layoutIfNeeded()
            }, completion: {_ in
                self.pauseBtn.isEnabled = true
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
                           animations: {
                            self.timerLabel.alpha = 0
                            self.timerLabel.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                            
            }, completion: { _ in
                
            })
            
            resumeBtnTrailingContraint.constant = resumeBtn.bounds.width
            stopBtnLeadingContraint.constant = -stopBtn.bounds.width
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
                            // Animate constraint
                            self.layoutIfNeeded()
            }, completion: { _ in
                self.enableButton(self.utilBtnGroup, with: [false, false, true, true])
            })
        }
    }
    
    
    func loadData() {
        
        var titleText = ""
        
        if let emoji = activity?.emoji {
            titleText += emoji
            startBtn.setTitle(emoji, for: .normal)
            // By Jing, 2019/11/24, Still you should not do this here
            //                        startBtn.titleLabel?.setFontToFit(scaleFactor: 0.8)
            startBtn.setBackgroundImage(nil, for: .normal)
        }
        if let name = activity?.name { titleText += " \(name)" }
        
        self.title.text = titleText
        
        // TODO: since autolayout is not completed yet, so everything here will be based on 159x159 cell, Jing, 9/12/19
        //        title.setFontToFitHeight()
        //        timerLabel.text = elapsedTime.toDisplayTime()
        //        timerLabel.setFontToFitHeight()
        //        timerLabel.setKernSpacing()
        //        timerLabel.setFontToFit()
        
        if let _ = activity?.emoji {
            startBtn.backgroundColor = .clear
                        startBtn.borderColor = .clear
//            startBtn.borderColor = activity?.bgColor ?? .lightGray // DEBUG
        } else {
            startBtn.backgroundColor = activity?.bgColor ?? .darkGray
            startBtn.borderColor = activity?.bgColor ?? .lightGray
        }
        
        //        startBtn.backgroundColor = activity?.bgColor ?? .darkGray
        //        startBtn.borderColor = activity?.bgColor ?? .lightGray
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
        
        
        //        // TODO: This works but it is so stupid and so inefficient, the app need to update the font millions of times as long as the timer kicks
        //        title.setFontToFit(scaleFactor: 0.9)
        //        timerLabel.setFontToFit(scaleFactor: 0.95)
        
        //        startBtn.titleLabel?.setFontToFit(scaleFactor: 0.8)
        
        
        // TODO: Alternative, what is the diff between masksToBounds and clipsToBounds
        //        contentView.roundedCourner(radius: 5)
        
    }
    
    func initUI() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        // TODO, by Jing, 11/02/19, UIGestureRecognizer does not work with the following setup.
        //        canvasViewTappedGesture = UIGestureRecognizer(target: self, action: #selector(canvasViewTappedHandler(_:)))
        //        canvasView.addGestureRecognizer(canvasViewTappedGesture)
        
        // Group all utility button together, so that we can use enableButton() to enable/disable these four buttons easily, a better way of doing may be needed if more 4 util button need to be handled.
        // The order of each button in the array should be [startBtn, pauseBtn, resumeBtn, stopBtn]
        utilBtnGroup.append(startBtn)
        utilBtnGroup.append(pauseBtn)
        utilBtnGroup.append(resumeBtn)
        utilBtnGroup.append(stopBtn)
        
        //        startBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    
    // TODO: This is the function which will be called when autolayout is complete
    override func didMoveToWindow() {
        super.didMoveToWindow()
        //        print("Frame >> \(self.frame)")
        ////        Frame >> (21.0, 0.0, 175.0, 175.0)
        ////        Frame >> (218.0, 0.0, 175.0, 175.0)
        ////        Frame >> (21.0, 196.0, 175.0, 175.0)
        ////        Frame >> (218.0, 196.0, 175.0, 175.0)
        ////        Frame >> (21.0, 392.0, 175.0, 175.0)
        ////        Frame >> (218.0, 392.0, 175.0, 175.0)
        ////        Frame >> (21.0, 588.0, 175.0, 175.0)
        ////        Frame >> (218.0, 588.0, 175.0, 175.0)
        ////        Frame >> (21.0, 784.0, 175.0, 175.0)
        ////        Frame >> (218.0, 784.0, 175.0, 175.0)
        
        title.setFontToFit(scaleFactor: 1.0)
        timerLabel.setFontToFit(scaleFactor: 0.95)
        
        
        startBtn.titleLabel?.setFontToFit(scaleFactor: 0.8)
    }
    
    
}


extension ActivityCell: Listner {
    func onEvent(_ event: Event, userInfo: Any) {
        elapsedTime += 1
        // Delegate the following line as computed part of elapsedTime, hope this will make is safer for race condition
        //        timerLabel.text = elapsedTime.toDisplayTime()
    }
}

// All animations
extension ActivityCell {
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

// TODO: Code trying to animate the radius of backdrop
//                            self?.backdropView.layer.cornerRadius = 5

//                            let sx = ( self?.canvasView.bounds.size.width ?? 0 )/(self?.backdropView.bounds.width ?? 1)*1.2
//                            let sy = ( self?.canvasView.bounds.size.height ?? 0 )/(self?.backdropView.bounds.height ?? 1)*1.2
//                            self?.backdropView.transform = CGAffineTransform(scaleX: sx, y: sy)
