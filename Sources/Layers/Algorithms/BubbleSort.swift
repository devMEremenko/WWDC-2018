//
//  HeapSort.swift
//  WWDC
//
//  Created by Maxim Eremenko on 4/1/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class BubbleSort: Algorithm {
    
    func run(with values: [Int]) -> TransactionQueue<Int> {
        let sorted = bubbleSort(values)
        return TransactionQueue(sorted, sourceValues: values)
    }
    
    func bubbleSort(_ array: [Int]) -> [Transaction<Int>] {
        
        var transactions = [Transaction<Int>]()
        var arr = array
        let range = Range<Int>(uncheckedBounds: (0, array.count - 1))
        
        for _ in 0...arr.count {
            for value in 1...arr.count - 1 {
                
                if arr[value - 1] > arr[value] {
                    let largerValue = arr[value - 1]
                    arr[value - 1] = arr[value]
                    arr[value] = largerValue
                    
                    let changes = TransactionFactory.changes(from: value,
                                                             to: value - 1,
                                                             range: range)
                    transactions.append(contentsOf: changes)
                }
            }
        }
        
        return transactions
    }
}
