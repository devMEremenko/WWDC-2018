//
//  UIColor+Additions.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func color(_ red: Double, _ green: Double, _ blue: Double, _ alpha: Double) -> UIColor {
        let div = 255.0
        return UIColor(red: CGFloat(red / div),
                       green: CGFloat(green / div),
                       blue: CGFloat(blue / div),
                       alpha: CGFloat(alpha))
    }
    
    static func random() -> UIColor {
        
        let colors = [Colors.blue, Colors.yellow, Colors.red,
                      Colors.sky, Colors.green,  Colors.orange]
        
        return colors[Int(arc4random_uniform(UInt32(colors.count - 1)))]
    }
}
