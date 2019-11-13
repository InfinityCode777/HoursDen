//
//  PopAnimator.swift
//  Hour
//
//  Created by Jing Wang on 11/5/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.8
    var isShowingDetail = true
    var originalFrame = CGRect.zero
    
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        // By Jing 2019/11/13
        // It seems that Apple fixed this bug in 13.1 and later
        // https://stackoverflow.com/questions/57802743/uiviewcontroller-custom-transition-stuck-on-ios13
        
        guard let fromView = transitionContext.viewController(forKey: .from)?.view else {
            JLog.debug("Fail to get fromView!")
            return
        }
        
        guard let toView = transitionContext.viewController(forKey: .to)?.view else {
            JLog.debug("Fail to get toView!")
            return
        }
        
        //        guard let fromView = transitionContext.view(forKey: .from) else {
        //            print("Fail to get fromView!")
        //            return
        //        }
        //
        //        guard let toView = transitionContext.view(forKey: .to) else {
        //            print("Fail to get toView!")
        //            return
        //        }
        
        
        let animatedView = isShowingDetail ? toView : fromView
        
        //    // This seems work but there is some off when dismissing the detailed view
        //    let initialFrame = isShowingDetail ? toView.frame : fromView.frame
        //    let finalFrame = isShowingDetail ? fromView.frame : toView.frame
        
        let initialFrame = isShowingDetail ? originalFrame : fromView.frame
        let finalFrame = isShowingDetail ? toView.frame : originalFrame
        
        
        // Preset transforms
        let xScaleFactor = isShowingDetail ? initialFrame.width/finalFrame.width : finalFrame.width/initialFrame.width
        let yScaleFactor = isShowingDetail ? initialFrame.height/finalFrame.height : finalFrame.height/initialFrame.height
        
        let animatedViewTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if isShowingDetail {
            animatedView.transform = animatedViewTransform
            animatedView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            animatedView.clipsToBounds = true
            containerView.addSubview(animatedView)
            containerView.bringSubviewToFront(animatedView)
        }
        
        animatedView.layer.cornerRadius = isShowingDetail ? 20 : 0
        animatedView.layer.masksToBounds = true
        
        // By Jing 2019/11/19
        // Whennever the following line is called, the VC transition will terminate immediately
        // transitionContext.completeTransition(true)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.2,
            animations: {
                animatedView.transform = self.isShowingDetail ? .identity : animatedViewTransform
                animatedView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                animatedView.layer.cornerRadius = self.isShowingDetail ? 0 : 20
        }, completion: { _ in
            if !self.isShowingDetail {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
            
            // By Jing 2019/11/13, suggested from the following post, but it does not solve my problem
            // https://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning/25655575#25655575
            
            // UIApplication.sharedApplication().keyWindow!.addSubview(toView)
            // UIApplication.shared.keyWindow?.addSubview(toView)
            
            //            if let keyWindow = (UIApplication.shared.windows.filter{ $0.isKeyWindow }.first) {
            //                keyWindow.addSubview(toView)
            //            }
            
        })
        
    }
}
