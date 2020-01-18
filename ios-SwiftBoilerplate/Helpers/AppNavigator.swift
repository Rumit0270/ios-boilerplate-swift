//
//  AppNavigator.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/8/20.
//

import Foundation

/**
Main Application Navigator implementing the Navigator protocol.
Try to use the same navigator throughout the application.
 */
class AppNavigator: BaseNavigator {
    static let shared = AppNavigator()
    
    init() {
        let initialRoute: Route = MainTabbarRoutes.userVC
        super.init(with: initialRoute)
    }
    
    required init(with route: Route) {
        super.init(with: route)
    }

}
