//
//  BaseNavigationController.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/6/20.
//

import UIKit

/// BaseNavigationController configurations. Override for changing configurations.
public class BaseNavigationController: UINavigationController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = ColorConstants.tabBarBackground
        navigationBar.layer.shadowOpacity = 0.2
        navigationBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        navigationBar.layer.shadowRadius = 2
        navigationBar.layer.masksToBounds = false
    }
}
