//
//  NibLoadableView.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import UIKit

protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
}
