//
//  MainTabBarController.swift
//  CoreData_Demo
//
//  Created by SMBA on 19.05.2022..
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        customizeTabBarItems()
        setupTabBarAppearance()
                
    }
    
    fileprivate func setupControllers() {
        setViewControllers([MoviesOverViewViewController().embedInNavController(), MovieSearchViewController().embedInNavController(), FavoritesViewController().embedInNavController()], animated: true)
    }
    
    fileprivate func customizeTabBarItems() {
        guard let uTabBarItems = tabBar.items else { return }
        uTabBarItems.forEach {
            guard let uIndex = uTabBarItems.firstIndex(of: $0) else { return }
            $0.image = UIImage(named: TabBarItemIcons.allCases[uIndex].rawValue)?.withRenderingMode(.alwaysTemplate)
            $0.imageInsets = UIEdgeInsets(top: Constants.paddingSmall, left: 0, bottom: -Constants.paddingSmall, right: 0)
        }
    }
    
}

// MARK: - TabBarAppearance

extension MainTabBarController {
    
    fileprivate func setupTabBarAppearance() {
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = Colors.separatorBackground
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
}

// MARK: - TabBarItemIcons

extension MainTabBarController {
    
    fileprivate enum TabBarItemIcons: String, CaseIterable {
        case albumsOverView = "icLastfm"
        case search = "icSearch"
        case favorites = "icAddToFavorite"
    }
    
}

