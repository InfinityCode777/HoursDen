//
//  ActivityButton.swift
//  Hour
//
//  Created by Jing Wang on 8/22/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit


@IBDesignable
class ActivityButton: UIButton {
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedCourner(radius: self.bounds.width/2)
//        mask?.frame = self.bounds
    }
}


extension ActivityButton {
    func setTitle(_ title: String?, for state: UIControl.State, animated: Bool = false ) {
        
        //        if !animated {
        //            UIView.setAnimationsEnabled(false)
        //            setTitle(title, for: state)
        //            layoutIfNeeded()
        //            UIView.setAnimationsEnabled(true)
        //        }
        //        else {
        //            setTitle(title, for: state)
        //        }
        if !animated {
            UIView.performWithoutAnimation {
                self.setTitle(title, for: state)
                layoutIfNeeded()
            }
        }
        else {
            setTitle(title, for: state)
        }
        
        
    }
}
