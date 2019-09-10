//
//  ExtUIView.swift
//  Hour
//
//  Created by Jing Wang on 9/10/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//
import UIKit

extension UIView {
    func roundedCourner(radius: CGFloat = 8) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}
