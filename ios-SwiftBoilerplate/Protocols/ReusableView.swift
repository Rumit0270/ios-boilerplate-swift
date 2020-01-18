//
//  ReusableView.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
