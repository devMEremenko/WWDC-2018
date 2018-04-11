//
//  TransactionQueue.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class TransactionQueue<T> {
    
    let sourceValues: [Transaction<T>]
    let transactions: [Transaction<T>]
    
    private var current = -1
    
    init(_ transactions: [Transaction<T>], sourceValues: [T]) {
        self.transactions = transactions
        self.sourceValues = sourceValues.map({ obj -> Transaction<T> in
            return Transaction<T>(obj, obj, obj)
        })
    }
    
    func reset() {
        current = -1
    }
}

extension TransactionQueue {
    
    var next: Transaction<T>? {
        
        if current == -1 {
            current = 1
            return transactions.first
        }
        
        guard let obj = transactions.obj(at: current) else { return nil }
        current = current + 1
        return obj
    }
    
    var previous: Transaction<T>? {
        
        if current >= transactions.count {
            current = transactions.count - 2
            return transactions.last?.reverted
        }
        
        guard let obj = transactions.obj(at: current) else { return nil }
        current = current - 1
        return obj.reverted
    }
}
