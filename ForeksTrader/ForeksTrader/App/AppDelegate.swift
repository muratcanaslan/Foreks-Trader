//
//  AppDelegate.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}

