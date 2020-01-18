//
//  ViewController.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/2/20.
//

import UIKit

/// Root tabbar controller.
class MainTabBarController: UITabBarController {
    
    enum TabbarItems: Int {
        case first = 1
        case second
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = ColorConstants.tabBarBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assignTabBarItems()
    }
    
    private func assignTabBarItems() {
        
        let mainStoryboard = R.storyboard.main()
        
        guard let userNavVC = mainStoryboard.instantiateViewController(withIdentifier: "NavUserViewController") as? UINavigationController else { return }
        let userVCTabBarItem = UITabBarItem(title: "Users", image: nil, tag: TabbarItems.first.rawValue)
        userNavVC.tabBarItem = userVCTabBarItem
        
        guard let moreNavVC = mainStoryboard.instantiateViewController(withIdentifier: "NavMoreViewController") as? UINavigationController else { return }
        let moreVCTabBarItem = UITabBarItem(title: "More", image: nil, tag: TabbarItems.second.rawValue)
        moreNavVC.tabBarItem = moreVCTabBarItem
        
        mainQueue {
            self.viewControllers = [userNavVC, moreNavVC]
        }
        
    }
}
