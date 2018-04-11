//
//  QuickSort.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

protocol Algorithm {
    
    func run(with values: [Int]) -> TransactionQueue<Int>
}

class QuickSort: Algorithm {
    
    private(set) var transactions = [Transaction<Int>]()
    
    func run(with values: [Int]) -> TransactionQueue<Int> {
        var toSort = Array(values)
        quicksortLomuto(&toSort, low: 0, high: toSort.count - 1)
        return TransactionQueue(transactions, sourceValues: values)
    }
        
    func quicksortLomuto(_ a: inout [Int], low: Int, high: Int) {
        if low < high {
            let p = partitionLomuto(&a, low: low, high: high)
            quicksortLomuto(&a, low: low, high: p - 1)
            quicksortLomuto(&a, low: p + 1, high: high)
        }
    }
    
    private func partitionLomuto(_ a: inout [Int], low: Int, high: Int) -> Int {

        let pivot = a[high]
        var i = low
        for j in low..<high {
            if a[j] <= pivot {
                
                let range = Range<Int>(uncheckedBounds: (low, high))
                let changes = TransactionFactory.changes(from: i, to: j, range: range)
                transactions.append(contentsOf: changes)
                (a[i], a[j]) = (a[j], a[i])
                i += 1
            }
        }

        let range = Range<Int>(uncheckedBounds: (low, high))
        let changes = TransactionFactory.changes(from: i, to: high, range: range)
        transactions.append(contentsOf: changes)
        
        (a[i], a[high]) = (a[high], a[i])
        
        return i
    }
}
