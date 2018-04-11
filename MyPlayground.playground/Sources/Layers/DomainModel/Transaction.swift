//
//  Operation.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

struct Transaction<T> {
    
    let fromIndex: T
    let toIndex: T
    let value: T?
    
    init(_ fromIndex: T, _ toIndex: T, _ value: T? = nil) {
        
        self.fromIndex = fromIndex
        self.toIndex = toIndex
        self.value = value
    }
    
    var reverted: Transaction<T> {
        return Transaction<T>(toIndex, fromIndex)
    }
}

class TransactionFactory {
    
    static func changes(from: Int,
                        to: Int,
                        range: Range<Int>) -> [Transaction<Int>] {
        
        guard from != to else { return [] }
        
        let min = range.lowerBound
        let max = range.upperBound
        
        var correctedFrom = from < to ? to - 1 : to + 1
        correctedFrom = correctedFrom > min ? correctedFrom : min
        correctedFrom = correctedFrom < max ? correctedFrom : max
        
        var results = [Transaction(from, to)]
        if correctedFrom != from {
            results.append(Transaction(correctedFrom, from))
        }
        
        return results
    }
}
