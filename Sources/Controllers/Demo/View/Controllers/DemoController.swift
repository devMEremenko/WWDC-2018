//
//  DemoController.swift
//  WWDC
//
//  Created by Maxim Eremenko on 3/31/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

class DemoController: CollectionController {
    
    fileprivate var queue: TransactionQueue<Int>?
    
    override init(collection: UICollectionView, estimateRowHeight: Bool = true) {
        super.init(collection: collection, estimateRowHeight: estimateRowHeight)
        register(cell: DemoCell.self, identifier: String(describing: DemoCell.self))
    }
    
    var sortCompletion: Empty?
}

extension DemoController {
    
    func update(with queue: TransactionQueue<Int>) {
        self.queue = queue
        display(sourceValues: queue.sourceValues)
    }
    
    func showNext() {
        guard let next = queue?.next else { sortCompletion?(); return }
        moveItem(with: next)
    }
    
    func showPrevious() {
        guard let previous = queue?.previous else { return }
        moveItem(with: previous)
    }
    
    func reset() {
        guard let queue = self.queue else { return }
        queue.reset()
        update(with: queue)
    }
    
    private func moveItem(with transaction: Transaction<Int>) {
        
        update(animation: .automatic) {
            let from = IndexPath(row: transaction.fromIndex, section: 0)
            let to = IndexPath(row: transaction.toIndex, section: 0)
            self.move(row: from, to: to)
            
            guard let row = self.row(at: 0, row: from.row) as? Row<DemoCell> else {
                return
            }
            row.cell?.animate()
        }
    }
}

private extension DemoController {
    
    func display(sourceValues: [Transaction<Int>]) {
        update(animation: .automatic, {
            self.removeAll()
        })
        
        let colors = [Colors.orange, Colors.sky, Colors.green,
                      Colors.red, Colors.blue, Colors.yellow]
        
        let viewModels = sourceValues.enumerated().map({
            DemoCellModel<Int>($0.element, colors[$0.offset])
        })
        
        let rows = Row<DemoCell>.create(viewModels)
        update {
            self.add(rows: rows)
        }
    }
}
