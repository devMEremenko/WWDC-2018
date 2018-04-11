//
//  DemoUserInterfaceIO.h
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

protocol DemoUserInterfaceInput: class {
    
    func display(queue: TransactionQueue<Int>, type: AlgorithmType)
}

protocol DemoUserInterfaceOutput: class {}
