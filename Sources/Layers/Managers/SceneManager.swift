//
//  SceneManager.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/30/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class SceneManager {
    
    static var shared = SceneManager()
    
    private lazy var rootWireframe = RootWireframe()
    
    var scene: UIViewController { return rootWireframe }
}

extension SceneManager {
    
    func presentDemoScreen() {
        rootWireframe.presentDemoScreen()
    }
    
    func presentProfile() {
        rootWireframe.presentProfile()
    }
    
    func backToProfile() {
        rootWireframe.backToProfile()
    }
}
