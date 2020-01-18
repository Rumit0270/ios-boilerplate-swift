//
//  MainTabbarRoutes.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/8/20.
//

import Foundation
import UIKit

/// Routes accessible through the initial tab bar.
enum MainTabbarRoutes: Route {
    case userVC
    case moreVC
    
    var screen: BaseViewController {
        switch self {
        case .userVC:
            guard let userVC = R.storyboard.main.userViewController() else {
                return BaseViewController()
            }
            return userVC
        case .moreVC:
            guard let moreVC = R.storyboard.main.moreViewController() else {
                return BaseViewController()
            }
            return moreVC
        }
    }
}
