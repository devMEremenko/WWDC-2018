//
//  UIImage+Additions.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

extension UIImage {
    
    static var background: UIImage? {
        return UIImage(named: "background_img")
    }
    
    static var play: UIImage? {
        return UIImage(named: "play")
    }
    
    static var pause: UIImage? {
        return UIImage(named: "pause")
    }
    
    static var backward: UIImage? {
        return UIImage(named: "backward")
    }
    
    static var forward: UIImage? {
        return UIImage(named: "forward")
    }
    
    static var reload: UIImage? {
        return UIImage(named: "reload")
    }
}
