//
//  UILabel+Extensions.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import UIKit

extension UILabel {
    
    /// set lineSpacing property in points
    func setLineHeight(_ lineHeight: Int) {
        let displayText = text ?? ""
        if let attributedString = self.attributedText!.mutableCopy() as?  NSMutableAttributedString {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(lineHeight)
            paragraphStyle.alignment = textAlignment
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, displayText.count))
            attributedText = attributedString
        }
    }
}
