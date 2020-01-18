//
//  UIFont+Extensions.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/14/20.
//

import Foundation
import UIKit

extension UIFont {
    
    class func appFont(type: AppFont = .regular, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }
}
