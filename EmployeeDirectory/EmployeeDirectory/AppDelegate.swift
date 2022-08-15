//
//  AppDelegate.swift
//  Employee Directory
//
//  Created by Akshay Bhandary on 8/13/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let repository = EmployeeRepository(networkLoader: EmployeeNetworkLoader())
    let viewModel = EmployeeListViewModel(repository:repository)
    let tableViewController = EmployeeListViewController(viewModel: viewModel, assetStore: AssetStore())
    let navController =  ListNavigationController()
    navController.viewControllers = [tableViewController]
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
    return true
  }
}

