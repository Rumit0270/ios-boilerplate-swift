//
//  Route.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/8/20.
//

import Foundation
import UIKit
/**
 Protocol used to define a Route. The route contains
 all the information necessary to instantiate it's screen.
 For example, you could have a LoginRoute, that knows how
 to instantiate it's viewModel, and also forward any
 information that it's passed to the Route.
 */
protocol Route {
    typealias TransitionConfigurator = (
        _ sourceVC: BaseViewController?, _ destinationVC: BaseViewController
        ) -> Void
    
    /// The screen that should be returned for the Route.
    var screen: BaseViewController { get }
    
    /**
     Configuration callback executed just before pushing/presenting modally.
     Use this to set up any custom transition delegate, presentationStyle, etc.
     - Parameters:
     - sourceVc: The currently visible viewController, if any.
     - destinationVc: The (fully intialized) viewController to present.
     */
    var transitionConfigurator: TransitionConfigurator? { get }
}

extension Route {
    // Mark transitionConfigurator as optional
    var transitionConfigurator: TransitionConfigurator? {
        return nil
    }
}
