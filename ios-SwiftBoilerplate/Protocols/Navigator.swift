//
//  Navigator.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/8/20.
//

import Foundation
import UIKit

/// Available Transition types for navigation actions.
public enum TransitionType {
    
    /// Presents the screen modally on top of the current ViewController
    case modal
    
    /// Pushes the next screen to the rootViewController navigation Stack.
    case push
    
    /// Resets the rootViewController navitationStack and set's the Route's screen
    /// as the initial view controller of the stack.
    case reset
    
    /// Replaces the key window's Root view controller with the Route's screen.
    case changeRoot
}

/**
 The Navigator is the base of this framework, it handles all
 your application navigation stack.
 It keeps track of your root NavigationController and the
 ViewController that is currently displayed. This way it can
 handle any kind of navigation action that you might want to dispatch.
 */
protocol Navigator: class {
    /// The root navigation controller of your stack.
    var rootViewController: BaseNavigationController? { get set }
    
    /// The currently visible ViewController
    var currentViewController: BaseViewController? { get }
    
    /// Convencience init to set your application starting screen
    init(with route: Route)
    
    /**
     Navigate from your current screen to a new route.
     - Parameters:
     - route: The destination route of your navigation action.
     - transition: The transition type that you want to use.
     - animated: Animate the transition or not.
     - completion: Completion handler.
     */
    func navigate(
        to route: Route, with transition: TransitionType,
        animated: Bool, completion: (() -> Void)?
    )
    
    /**
     Navigate from your current screen to a new entire navigator.
     Can only push a router as a modal.
     Afterwards, other controllers can be pushed inside the presented Navigator.
     - Parameters:
     - Navigator: The destination navigator that you want to navigate to
     - animated: Animate the transition or not.
     - completion: Completion handler.
     */
    func navigate(
        to router: Navigator, animated: Bool, completion: (() -> Void)?
    )
    
    /**
     Handles backwards navigation through the stack.
     */
    func pop(animated: Bool)
    
    /**
     Handles backwards navigation through the stack.
     - Parameters:
     - route: The index of the route of your navigation action.
     - animated: Animate the transition or not.
     */
    func popTo(index: Int, animated: Bool)
    
    /**
     Handles backwards navigation through the stack.
     - Parameters:
     - route: The destination route of your navigation action.
     - animated: Animate the transition or not.
     */
    func popTo(route: Route, animated: Bool)
    
    /**
     Dismiss your current ViewController.
     - Parameters:
     - animated: Animate the transition or not.
     - completion: Completion handler.
     */
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension Navigator {
    
    func navigate(
        to route: Route, with transition: TransitionType,
        animated: Bool = true, completion: (() -> Void)? = nil
        ) {
        let viewController = route.screen
        switch transition {
        case .modal:
            route.transitionConfigurator?(currentViewController, viewController)
            currentViewController?.present(
                viewController, animated: animated, completion: completion
            )
        case .push:
            route.transitionConfigurator?(currentViewController, viewController)
            rootViewController?.pushViewController(viewController, animated: animated)
        case .reset:
            route.transitionConfigurator?(nil, viewController)
            rootViewController?.setViewControllers([viewController], animated: animated)
        case .changeRoot:
            UIView.animate(withDuration: 0.3) { [weak self] in
                let navigation = viewController.embedInNavigationController()
                UIApplication.shared.keyWindow?.rootViewController = navigation
                self?.rootViewController = navigation
            }
        }
    }
    
    func navigate(to router: Navigator, animated: Bool, completion: (() -> Void)?) {
        guard let viewController = router.rootViewController else {
            assert(false, "Navigator does not have a root view controller")
            return
        }
        
        currentViewController?.present(
            viewController, animated: animated, completion: completion
        )
    }
    
    func pop(animated: Bool = true) {
        rootViewController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        rootViewController?.popToRootViewController(animated: animated)
    }
    
    func popTo(index: Int, animated: Bool = true) {
        guard
            let viewControllers = rootViewController?.viewControllers,
            viewControllers.count > index
            else { return }
        let viewController = viewControllers[index]
        rootViewController?.popToViewController(viewController, animated: animated)
    }
    
    func popTo(route: Route, animated: Bool = true) {
        guard
            let viewControllers = rootViewController?.viewControllers,
            let viewController = viewControllers.first(where: {
                type(of: $0) == type(of: route.screen)
            })
            else { return }
        rootViewController?.popToViewController(viewController, animated: true)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        currentViewController?.dismiss(animated: animated, completion: completion)
    }
    
    /// Use to set the UINavigationController instantiated from Storyboard
    /// as the root view controller of the current Navigator.
    func setRootNavController(for viewController: BaseViewController) {
        if let navController = viewController.navigationController as? BaseNavigationController {
            rootViewController = navController
        }
    }

}
