//
//  ContainerConstants.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © Maxim Eremenko. All rights reserved.
//

import UIKit

struct ContainerConstants {
    
    static let collectionSize = CGSize(width: ScreenConstant.screenFrame.width,
                                       height: 240)
    
    static let childFrame = CGRect(x: 0,
                                   y: ContainerConstants.collectionSize.height,
                                   width: ScreenConstant.screenWidth,
                                   height: ScreenConstant.screenHeight - ContainerConstants.collectionSize.height)
}

struct CellIdentifiers {
    static let photo = NSStringFromClass(PhotoCell.self)
}
