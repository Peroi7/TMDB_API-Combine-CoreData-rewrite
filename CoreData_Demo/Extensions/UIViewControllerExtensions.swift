//
//  UIViewControllerExtensions.swift
//  CoreData_Demo
//
//  Created by SMBA on 24.05.2022..
//

import UIKit

extension UIViewController {
    
    //MARK: - NavigationController

    func embedInNavController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}
