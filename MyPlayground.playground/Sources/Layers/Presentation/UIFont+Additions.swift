//
//  UIFont+Additions.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

public extension UIFont {
    
    static func setupFonts() {
        
        let regularURL = Bundle.main.url(forResource: "OpenSans-Regular", withExtension: "ttf")
        let semiboldURL = Bundle.main.url(forResource: "OpenSans-Semibold", withExtension: "ttf")
        
        if let regularURL = regularURL {
            CTFontManagerRegisterFontsForURL(regularURL as CFURL, CTFontManagerScope.process, nil)
        }
        if let semiboldURL = semiboldURL {
            CTFontManagerRegisterFontsForURL(semiboldURL as CFURL, CTFontManagerScope.process, nil)
        }
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return fontWith(fontName: "OpenSans", size: size)
    }
    
    static func semibold(size: CGFloat) -> UIFont {
        return fontWith(fontName: "OpenSans-Semibold", size: size)
    }
    
    static func fontWith(fontName: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: fontName, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
