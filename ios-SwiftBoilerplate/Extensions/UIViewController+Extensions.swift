//
//  UIViewController+Extensions.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/8/20.
//

import Foundation
import UIKit

// MARK: - Navigator extensions
public extension UIViewController {
    func embedInNavigationController() -> BaseNavigationController {
        if let navigation = self as? BaseNavigationController {
            return navigation
        }
        let navigationController = BaseNavigationController(rootViewController: self)
        navigationController.isNavigationBarHidden = false
        return navigationController
    }
}

// MARK: - Bar button item extensions.
public extension UIViewController {
    
    func barButtonItem(imageName: String) -> UIBarButtonItem? {
        let button: UIButton = UIButton(type: .custom)
        guard let image = UIImage(named: imageName) else {
            return nil
        }
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        return UIBarButtonItem(customView: button)
    }
    
    func barButtonItemWithImageTitle(title: String, color: UIColor? = nil) -> UIBarButtonItem? {
        let button: UIButton = UIButton(type: .custom)
        //button.titleLabel?.font = UIFont.appFont(size: 12)
        button.sizeToFit()
        button.titleLabel?.textColor = color
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        
        return barButtonItem
    }
    
    func backBarButtonItem() -> UIBarButtonItem? {
        return barButtonItem(imageName: "BackBarButtonItem")
    }
    
    func barButtonItemButtonWithBorder(title: String, color: UIColor? = nil, font: UIFont?, border: Bool = true) -> UIBarButtonItem? {
        
        let button: UIButton = UIButton(type: .custom)
        button.titleLabel?.font = font
        button.sizeToFit()
        button.titleLabel?.textColor = color
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        
        //let width: Double = Device.isiPhone5SOrLower() ? 55 : 65
        let width: Double = 65
        button.frame.size = CGSize(width: width, height: 30.0)
        
        if let color = color, border == true {
            button.layer.cornerRadius = button.frame.height * 0.5
            button.layer.borderColor = color.cgColor
            button.layer.borderWidth = 1.0
        }
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
        
    }
    
}

/// Extension to easily add an remove child view controllers.
/// https://www.swiftbysundell.com/basics/child-view-controllers
extension UIViewController {
    
    func addVC(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeVC() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
