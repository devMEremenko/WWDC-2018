//
//  Array+Additions.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import Foundation

extension Array {
    
    func obj(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    func next(after index: Int) -> Element? {
        guard index >= 0, count != 0 else { return nil }
        let next = index + 1
        guard next < count else { return nil }
        return self[next]
    }
    
    func previous(before index: Int) -> Element? {
        guard index < count, count != 0 else { return nil }
        let previous = index - 1
        guard previous >= 0 else { return nil }
        return self[previous]
    }
}
