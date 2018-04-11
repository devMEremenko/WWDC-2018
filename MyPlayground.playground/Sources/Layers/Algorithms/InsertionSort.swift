//
//  InsertionSort.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class InsertionSort: Algorithm {
    
    func run(with values: [Int]) -> TransactionQueue<Int> {
        return TransactionQueue(insertionSort(values), sourceValues: values)
    }
    
    func insertionSort(_ array: [Int]) -> [Transaction<Int>] {
        var a = array
        let range = Range<Int>(uncheckedBounds: (0, array.count - 1))
        var transactions = [Transaction<Int>]()
        for x in 1..<a.count {
            var y = x
            while y > 0 && a[y] < a[y - 1] {
                let changes = TransactionFactory.changes(from: y - 1, to: y,
                                                         range: range)
                transactions.append(contentsOf: changes)
                a.swapAt(y - 1, y)
                y -= 1
            }
        }
        return transactions
    }
}
