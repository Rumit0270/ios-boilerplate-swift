//
//  BaseViewController.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/7/20.
//

import Foundation
import IQKeyboardManagerSwift
import MBProgressHUD

/// BaseViewController to be extended by other ViewControllers.
/// It has all the base configurations Override for changing behaviours.
class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var mainLoader: MBProgressHUD = {
        let mainLoader = MBProgressHUD.showAdded(to: self.view, animated: true)
        mainLoader.mode = MBProgressHUDMode.indeterminate
        mainLoader.dimBackground = true
        return mainLoader
         //Configure additional loader configuration
//        // Partially see-through bezel
//        mainLoader.bezelView.color = .white
//        mainLoader.bezelView.style = .blur
//
//        // Dim background
//        mainLoader.backgroundView.color = .clear
//        mainLoader.backgroundView.style = .blur
//        return mainLoader
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        mainLoader.hide(animated: false)
        enableKeyboardManager()
        reloadNavigationItem()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = ColorConstants.mainBackgroundColor
        view.bringSubviewToFront(mainLoader)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func navigationWithTitle(_ title: String) {
        navigationItem.title = title
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.appFont(type: .bold, size: 14)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

extension BaseViewController {
    
    // MARK: - Loader And Alert Extensions.
    public func showAlert(alertTitle: String,
                          alertMessage: String,
                          alertStyle: UIAlertController.Style,
                          completion: (() -> Void)?) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: alertStyle)
        let action = UIAlertAction(title: localizedString("OK"), style: .default) { (_) in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    public func showLoader(show: Bool, text: String = "", animated: Bool = true) {
        mainLoader.label.text = text
        if mainLoader.superview == nil {
            view.addSubview(mainLoader)
            let mainLoaderFrame = CGRect(x: view.frame.size.width / 2 - mainLoader.frame.size.width / 2,
                                         y: view.frame.size.height / 2 - mainLoader.frame.size.height / 2 - 60,
                                         width: mainLoader.frame.size.width,
                                         height: mainLoader.frame.size.height + 60)
            mainLoader.frame = mainLoaderFrame
        }
        if show {
            mainLoader.show(animated: animated)
        } else {
            mainLoader.hide(animated: animated)
        }
    }
    
    // MARK: - IQKeyboardManagerSwift Helpers.
    func enableKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func disableKeyboardManager() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
    }
}

// MARK: - Bar button items extensions.
extension BaseViewController {
    
    func rightBarButtonItem() -> AnyObject? {
        // For overriding
        return nil
    }
    
    func leftBarButtonItem() -> AnyObject? {
        // For overriding
        return nil
    }
    
    func reloadNavigationItem() {
        let leftBarButtonItem = self.leftBarButtonItem()
        
        if leftBarButtonItem != nil { // testing
            if leftBarButtonItem?.isEqual(NSNull()) == true {
                navigationItem.leftBarButtonItem = nil
                navigationItem.hidesBackButton = true
            } else {
                if let barButtonItem = leftBarButtonItem as? UIBarButtonItem {
                    navigationItem.leftBarButtonItem = barButtonItem
                    navigationItem.hidesBackButton = false
                }
            }
        }
        
        let rightBarButtonItem = self.rightBarButtonItem()
        
        if rightBarButtonItem != nil {
            if rightBarButtonItem?.isEqual(NSNull()) == true {
                navigationItem.rightBarButtonItem = nil
            } else {
                if let barButtonItem = rightBarButtonItem as? UIBarButtonItem {
                    navigationItem.rightBarButtonItem = barButtonItem
                    navigationItem.hidesBackButton = false
                }
            }
        }
        
        if let leftButton = navigationItem.leftBarButtonItem?.customView as? UIControl {
            leftButton.addTarget(self, action: #selector(self.didPressLeftBarButtonItem), for: .touchUpInside)
        } else {
            navigationItem.leftBarButtonItem?.target = self
            navigationItem.leftBarButtonItem?.action = #selector(self.didPressLeftBarButtonItem)
        }
        if let rightButton = navigationItem.rightBarButtonItem?.customView as? UIControl {
            rightButton.addTarget(self, action: #selector(self.didPressRightBarButtonItem), for: .touchUpInside)
        } else {
            navigationItem.rightBarButtonItem?.target = self
            navigationItem.rightBarButtonItem?.action = #selector(self.didPressRightBarButtonItem)
        }
    }
    
    @objc func didPressRightBarButtonItem() {
        // For overriding
    }
    
    @objc func didPressLeftBarButtonItem() {
        // For overriding
    }
    
}
