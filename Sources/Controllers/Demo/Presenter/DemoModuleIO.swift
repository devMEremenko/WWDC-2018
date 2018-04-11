//
//  DemoModuleIO.h
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

protocol DemoModuleInput: class {
    
    func viewDidSetup()
}

protocol DemoModuleOutput: class {}
