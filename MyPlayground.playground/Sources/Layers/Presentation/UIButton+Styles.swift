//
//  UIButton+Styles.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

extension UIButton {
    
    struct Constant {
        
        static var defaultSize: CGSize { return CGSize(width: 200, height: 44) }
    }
}

extension UIButton {
    
    func applyNativeStyle() {
        backgroundColor = Colors.systemBlue
        titleLabel?.font = UIFont.semibold(size: 18)
        setTitleColor(UIColor.white, for: .normal)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
