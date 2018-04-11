//
//  DemoInteractor.h
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

enum AlgorithmType {
    
    case quick
    case insertion
    case bubble
}

class DemoInteractor {
    
    weak var output: DemoInteractorOutput?
}

extension DemoInteractor: DemoInteractorInput {
    
    func loadAlgorithm(type: AlgorithmType) {
        
        let values = [6, 5, 4, 3, 2, 1]
        
        let algorithm = self.algorithm(for: type)
        output?.loaded(type: type, queue: algorithm.run(with: values))
    }
    
    private func algorithm(for type: AlgorithmType) -> Algorithm {
        switch type {
        case .quick:
            return QuickSort()
        case .insertion:
            return InsertionSort()
        case .bubble:
            return BubbleSort()
        }
    }
}
