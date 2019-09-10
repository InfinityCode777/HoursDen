//
//  ExtUILabel.swift
//  Hour
//
//  Created by Jing Wang on 8/26/19.
//  Copyright © 2019 Jackalope. All rights reserved.
// Reference:
// https://stackoverflow.com/questions/8812192/how-to-set-font-size-to-fill-uilabel-height/17622215#17622215
// Look for answers provided by Joel Fischer and Antoine
// https://stackoverflow.com/questions/8812192/how-to-set-font-size-to-fill-uilabel-height/37277874#37277874
// Look for answers provided by backslash-f

import UIKit


extension UILabel {
    // Returns an UIFont that fits the new label's height.
    //    public func fontToFitHeight() -> UIFont {
    public func setFontToFitHeight() {
        
        var minFontSize: CGFloat = 1
        var maxFontSize: CGFloat = 200
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        
        var labelHeight: CGFloat = 0
        var testStringHeight: CGFloat = 0
        
        
        while (minFontSize <= maxFontSize) {
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            if let labelText: NSString = text as NSString? {
                
                // Original code, leave this for two weeks, by Jing, 8/26/19
                //                let labelHeight = frame.size.height
                
                //                let testStringHeight = labelText.size(
                //                    withAttributes: [NSAttributedString.Key.font: font.withSize(fontSizeAverage)]
                //                    ).height
                
                // Abort if text happens to be nil
                guard let charaCount = text?.count, charaCount > 0 else {
                    break
                }
                
                labelHeight = frame.size.height
                testStringHeight = labelText.size(
                    withAttributes: [NSAttributedString.Key.font: font.withSize(fontSizeAverage)]
                    ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                // Use to watch how font is converged
                JLog.debug("Adjusting font (min/max) >> \(minFontSize)/\(maxFontSize) -> \(fontSizeAverage)", isShortMsg: true)
                JLog.debug("Adjusting height (label/font) >> \(labelHeight)/\(testStringHeight)", isShortMsg: true)
                
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        self.font = font.withSize(fontSizeAverage - 1)
                        JLog.debug("Break 1", isShortMsg: true)
                        break
                    }
                    self.font = font.withSize(fontSizeAverage)
                    #if DEBUG
                    JLog.debug("Break 2", isShortMsg: true)
                    #endif
                    break
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                }
                else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                }
                else {
                    self.font = font.withSize(fontSizeAverage)
                    JLog.debug("Break 3", isShortMsg: true)
                    break
                }
            }
        }
        // By Jing, 8/26/19, it makes me uncomfortable to use fraction as font size
        self.font = font.withSize(fontSizeAverage.rounded(.down))
//        self.font = font.withSize(fontSizeAverage)
        
        JLog.debug("Final font (min/max) >> \(minFontSize)/\(maxFontSize) -> \(fontSizeAverage)", isShortMsg: true)
        JLog.debug("Adjusting height (label/font) >> \(labelHeight)/\(testStringHeight)", isShortMsg: true)
        JLog.debug("Break 4", isShortMsg: true)
        
    }
    
    
    //    // If needed
    //    @IBDesignable class TIFFitToHeightLabel: UILabel {
    //
    //        @IBInspectable var minFontSize:CGFloat = 12 {
    //            didSet {
    //                font = fontToFitHeight()
    //            }
    //        }
    //
    //        @IBInspectable var maxFontSize:CGFloat = 30 {
    //            didSet {
    //                font = fontToFitHeight()
    //            }
    //        }
    //       }
    
    
    // And little bit fancier
    //    class LabelWithAdaptiveTextHeight: UILabel {
    //
    //        override func layoutSubviews() {
    //            super.layoutSubviews()
    //            font = fontToFitHeight()
    //        }
    //       }
    
    
    public func setFontToFit() {
        
        var minFontSize: CGFloat = 1
        var maxFontSize: CGFloat = 200
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        var textAndLabelWidthDiff: CGFloat = 0

        
        var labelHeight: CGFloat = 0
        var labelWidth: CGFloat = 0
        var testStringHeight: CGFloat = 0
        var testStringWidth: CGFloat = 0

        
        while (minFontSize <= maxFontSize) {
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            if let labelText: NSString = text as NSString? {
                
                // Original code, leave this for two weeks, by Jing, 8/26/19
                //                let labelHeight = frame.size.height
                
                //                let testStringHeight = labelText.size(
                //                    withAttributes: [NSAttributedString.Key.font: font.withSize(fontSizeAverage)]
                //                    ).height
                
                // Abort if text happens to be nil
                guard let charaCount = text?.count, charaCount > 0 else {
                    break
                }
                
                //TODO: Should this be the bounds rather than frame, by Jing, 9/11/19
                labelHeight = frame.size.height
                labelWidth = frame.size.width
                
                testStringHeight = labelText.size(
                    withAttributes: [NSAttributedString.Key.font: font.withSize(fontSizeAverage)]
                    ).height
                testStringWidth = labelText.size(
                    withAttributes: [NSAttributedString.Key.font: font.withSize(fontSizeAverage)]
                    ).width

                textAndLabelHeightDiff = labelHeight - testStringHeight
                textAndLabelWidthDiff = labelWidth - testStringWidth

                // Use to watch how font is converged
                JLog.debug("Adjusting font (min/max) >> \(minFontSize)/\(maxFontSize) -> \(fontSizeAverage)", isShortMsg: true)
                JLog.debug("Adjusting height (label/font) >> \(labelHeight)/\(testStringHeight)", isShortMsg: true)
                
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) || (textAndLabelWidthDiff < 0)  {
                        self.font = font.withSize(fontSizeAverage - 1)
                        JLog.debug("Break 1", isShortMsg: true)
                        break
                    }
                    self.font = font.withSize(fontSizeAverage.rounded(.down))
                    #if DEBUG
                    JLog.debug("Break 2", isShortMsg: true)
                    #endif
                    break
                }
                
                if (textAndLabelHeightDiff < 0) || (textAndLabelWidthDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                }
                else if (textAndLabelHeightDiff > 0) || (textAndLabelWidthDiff > 0)  {
                    minFontSize = fontSizeAverage + 1
                }
                else {
                    self.font = font.withSize(fontSizeAverage.rounded(.down))
                    JLog.debug("Break 3", isShortMsg: true)
                    break
                }
            }
        }
        // By Jing, 8/26/19, it makes me uncomfortable to use fraction as font size
        self.font = font.withSize((fontSizeAverage*0.9).rounded(.down))
        //        self.font = font.withSize(fontSizeAverage)
        
        JLog.debug("Final font (min/max) >> \(minFontSize)/\(maxFontSize) -> \(fontSizeAverage)", isShortMsg: true)
        JLog.debug("Adjusting height (label/font) >> \(labelHeight)/\(testStringHeight)", isShortMsg: true)
        JLog.debug("Break 4", isShortMsg: true)
        
    }
    

        
        func setKernSpacing(kernSpacing: CGFloat = 0.0) {
            
            guard let labelText = text else { return }
            
            let attributedString: NSMutableAttributedString
            if let labelAttributedText = attributedText {
                attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
            } else {
                attributedString = NSMutableAttributedString(string: labelText)
            }
            
            // Character spacing attribute
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernSpacing, range: NSMakeRange(0, attributedString.length))
            
            attributedText = attributedString
        }
        
    
}
