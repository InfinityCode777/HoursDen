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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}


extension ActivityButton {
    func setTitle(_ title: String?, for state: UIControl.State, animated: Bool = false ) {
        
        if !animated {
            UIView.setAnimationsEnabled(false)
            setTitle(title, for: state)
            layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
        } else {
            setTitle(title, for: state)
        }
    }
}
