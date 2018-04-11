//
//  DemoGuideManager.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

enum DemoGuideState {
    
    case pressPlayButton
    case checkOutOtherAlgorithms
    case checkOutProfile
}

extension DemoGuideState {
    
    var message: String {
        switch self {
        case .pressPlayButton:
            return String.loc("guide.message.press.play.button")
        case .checkOutOtherAlgorithms:
            return String.loc("guide.message.checkout.algorithms")
        case .checkOutProfile:
            return String.loc("guide.message.checkout.profile")
        }
    }
}

class DemoGuideManager {
    
    typealias StateHandler = (DemoGuideState) -> ()
    
    var handler: StateHandler?
    
    private var timer: Timer?
    private var state: DemoGuideState = .pressPlayButton
    
    func nextState(after state: DemoGuideState) {
        
        switch state {
        case .pressPlayButton:
            setupTimer()
        default: break
        }   
    }
    
    private func setupTimer() {
        
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] _ in
            guard let strong = self else { return }
            
            switch strong.state {
            case .pressPlayButton:
                strong.state = .checkOutOtherAlgorithms
            case .checkOutOtherAlgorithms:
                strong.state = .checkOutProfile
            case .checkOutProfile:
                strong.state = .checkOutOtherAlgorithms
            }
            strong.handler?(strong.state)
        })
        
        timer?.fire()
    }
}
