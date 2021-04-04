//
//  TabBarController.swift
//  MyDocuments
//
//  Created by Егор Никитин on 02.04.2021.
//

import UIKit
import KeychainAccess

final class TabBarViewController: UITabBarController {
    
    // MARK: Properties
    
    let documentsBarItem: UITabBarItem = {
        $0.image = UIImage(systemName: "doc.fill")
        $0.title = "Documents"
        $0.standardAppearance?.selectionIndicatorTintColor = .black
        return $0
    }(UITabBarItem())
    
    let settingsBarItem: UITabBarItem = {
        $0.image = UIImage(systemName: "gearshape.fill")
        $0.title = "Settings"
        $0.standardAppearance?.selectionIndicatorTintColor = .black
        return $0
    }(UITabBarItem())
    
    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentsViewController = UINavigationController(rootViewController: DocumentsViewController())
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        
        documentsViewController.tabBarItem = documentsBarItem
        settingsViewController.tabBarItem = settingsBarItem
        
        self.navigationController?.navigationBar.isHidden = true
        
        let tabBarList = [documentsViewController, settingsViewController]
        
        viewControllers = tabBarList
        self.tabBar.tintColor = .black
    }
    
}
