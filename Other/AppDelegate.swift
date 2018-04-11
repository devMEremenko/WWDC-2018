//
//  AppDelegate.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/30/18.
//  Copyright © 2018 Eremenko Maxim. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = PlaygroundBuilder.createInteractiveScene()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
