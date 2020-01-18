//
//  MoreViewController.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/8/20.
//

import UIKit

class MoreViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppNavigator.shared.setRootNavController(for: self)
    }
    
}
