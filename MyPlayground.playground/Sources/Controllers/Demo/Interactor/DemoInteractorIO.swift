//
//  DemoInteractorIO.h
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

protocol DemoInteractorInput: class {
    
    func loadAlgorithm(type: AlgorithmType)
}

protocol DemoInteractorOutput: class {
    
    func loaded(type: AlgorithmType, queue: TransactionQueue<Int>)
}
