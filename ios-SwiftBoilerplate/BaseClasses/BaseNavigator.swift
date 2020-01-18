//
//  BaseNavigator.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/8/20.
//

import Foundation
import UIKit
/**
 The base navigator class implements the navigator protocol
 exposing basic behaviour extensible via inheritance.
 For example, you should subclass if you want to add
 some logic to the initial route by checking something
 stored in your keychain.
 */
class BaseNavigator: Navigator {
    open var rootViewController: BaseNavigationController?
    open var currentViewController: BaseViewController? {
        return
            rootViewController?.visibleViewController as? BaseViewController ??
            rootViewController?.topViewController as? BaseViewController ?? nil
    }
    
    public required init(with route: Route) {
        rootViewController = route.screen.embedInNavigationController()
    }
}
