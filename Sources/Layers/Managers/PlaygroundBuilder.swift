//
//  PlaygroundBuilder.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/30/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

struct ScreenConstant {
    
    static var screenFrame: CGRect { return CGRect(origin: .zero, size: screenSize) }
    static var screenSize: CGSize { return CGSize(width: 768, height: 768) }
    static var screenWidth: CGFloat { return screenSize.width }
    static var screenHeight: CGFloat { return screenSize.height }
}

open class PlaygroundBuilder {
    
    open static func createInteractiveScene() -> UIWindow {
        
        UIFont.setupFonts()
        
        let window = UIWindow(frame: ScreenConstant.screenFrame)
        window.rootViewController = SceneManager.shared.scene
        window.makeKeyAndVisible()
        
        return window
    }
}
