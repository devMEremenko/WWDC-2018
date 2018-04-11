//
//  DemoPresenter.h
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

class DemoPresenter {
    
    var interactor: DemoInteractorInput?
    var wireframe: DemoWireframe?
    weak var userInterface: DemoUserInterfaceInput?
    weak var moduleOutput: DemoModuleOutput?
}

extension DemoPresenter: DemoInteractorOutput {
    
    func loaded(type: AlgorithmType, queue: TransactionQueue<Int>) {
        DispatchQueue.toMain {
            self.userInterface?.display(queue: queue, type: type)
        }
    }
}

extension DemoPresenter: DemoModuleInput {
    
    func viewDidSetup() {
        DispatchQueue.toBackground {
            self.interactor?.loadAlgorithm(type: AlgorithmType.quick)
            self.interactor?.loadAlgorithm(type: AlgorithmType.insertion)
            self.interactor?.loadAlgorithm(type: AlgorithmType.bubble)
        }
    }
}
