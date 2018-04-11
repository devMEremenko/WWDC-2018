//
//  String+Localization.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

extension String {
    
    static func loc(_ key: String, _ comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
}
