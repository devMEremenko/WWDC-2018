//
//  DemoTimer.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

typealias DemoTimerTick = (AlgorithmType, DemoAction) -> ()

class DemoTimer {
    
    typealias StorageItme = (AlgorithmType, DemoAction)
    
    private var timer: Timer?
    
    var ticks = [AlgorithmType : (DemoTimerTick, DemoAction)]()
    
    init() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true)
        { [weak self] _ in
            
            self?.ticks.forEach({ algorithm, value in
                let handler = value.0
                let action = value.1
                handler(algorithm, action)
            })
        }
    }
}

extension DemoTimer {
    
    func start(action: DemoAction,
               for type: AlgorithmType,
               _ handler: @escaping DemoTimerTick) {
        
        ticks.updateValue((handler, action), forKey: type)
    }
    
    func stop(type: AlgorithmType) {
        ticks.removeValue(forKey: type)
    }
}
