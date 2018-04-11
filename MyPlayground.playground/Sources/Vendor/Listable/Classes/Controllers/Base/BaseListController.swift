/*
 Copyright (c) 2018 Maxim Eremenko <devmeremenko@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

open class BaseListController: NSObject {
    
    public weak var listView: ListView?
    
    public weak var scrollViewDelegate: UIScrollViewDelegate?
    
    internal var _removedHeaderFooterViews: [Int : SectionProtocol] = [:]
    
    internal var _removedRows: [Int : RowProtocol] = [:]
    
    internal var sections: ObservableArray<Section> = [] {
        
        //TODO: check if it is needed
        didSet {
            let (indexes, titles) = self.regenerateSectionIndexes()
            self.sectionsIndexes = indexes
            self.sectionsIndexesTitles = titles
        }
    }
    
    public init(listView: ListView, estimateRowHeight: Bool = true) {
        super.init()
        self.estimateRowSizeAutomatically = estimateRowHeight
        self.listView = listView
    }
    
    public func reloadData() {
        listView?.reloadData()
    }
    
    /// Perform an update session on the list. You are able to use all funcs to manipulate sections and rows in sections.
    /// You must however pay attention to the order of the operations you want to perform.
    ///
    /// Deletes are processed before inserts in batch operations.
    /// This means the indexes for the deletions are processed relative to the indexes of the collection view’s state
    /// before the batch operation, and the indexes for the insertions are processed relative to the indexes of the
    /// state after all the deletions in the batch operation.
    ///
    /// Morehover, in order to make a correct refresh of the data, insertion must be done in order of the row index.
    ///
    /// - Parameters:
    ///   - animation: animation to perform; if `nil` no animation is performed and a simple `reloadData()` is done instead.
    ///   - block: block with the operation to perform.
    
    public func update(animation: UITableViewRowAnimation? = nil,
                       _ block: Empty) {
        
        guard let animation = animation else {
            block()
            listView?.reloadData()
            return
        }
        
        // Generate a session id for this operation
        // we will register an observer for the table's sections changes
        // and one for every section to observe changes inside the rows.
        // All these observer are the same session ID; data will be grouped to perform
        // animations.
        let sessionUUID = self.generateSessionObservers()
        // Allow user to execute operations
        block()
        // Perform animations
        listView?.beginUpdates {
            // Execute operations on table's data source
            self.commit(updatesForSession: sessionUUID, using: animation)
            listView?.endUpdates(nil)
        }
    }
    
    //MARK: --- Private ---
    
    /// Indexes
    private var sectionsIndexes: [Int]? = nil
    
    /// Indexes's titles
    private var sectionsIndexesTitles: [String]? = nil
    
    //TODO:
    private var estimateRowSizeAutomatically: Bool = true
        
    private func regenerateSectionIndexes() -> (indexes: [Int]?, titles: [String]?) {
        var titles: [String] = []
        var indexes: [Int] = []
        
        self.sections.enumerated().forEach { idx, section in
            if let title = section.indexTitle {
                indexes.append(idx)
                titles.append(title)
            }
        }
        
        return ((indexes.isEmpty == false ? indexes : nil), titles)
    }
}

extension BaseListController {
    
    func keepRemovedSections(_ sections: [Section]) {
        sections.forEach {
            // For each section we want to see if there is an event for header or footer
            // which needs to be tracked on remove.
            
            if $0.headerView?.didEndDisplaying != nil { // header
                self._removedHeaderFooterViews[$0.headerView!.hashValue] = $0.headerView!
            }
            
            if $0.footerView?.didEndDisplaying != nil { // footer
                self._removedHeaderFooterViews[$0.footerView!.hashValue] = $0.footerView!
            }
        }
    }
    
    func keepRemovedRows(_ rows: [RowProtocol]) {
        rows.forEach {
            // Only we want to listen for didEndDisplay message we will keep
            // inside the table manager instance a strong reference to removed row
            // until message will be dispatched
            if $0.onDidEndDisplay != nil, let cell = $0._instance {
                _removedRows[cell.hashValue] = $0
            }
        }
    }
    
    /// This function generate operations to manipulate table using batch of animations
    ///
    /// - Returns: session observer
    func generateSessionObservers() -> String {
        let observerUUID = NSUUID().uuidString
        
        self.sections.observe(ArrayObserver(observerUUID)) // observe section changes
        // observe changes in any section
        self.sections.forEach {
            let observerOfSection = ArrayObserver(observerUUID)
            $0.rows.observe(observerOfSection)
        }
        
        return observerUUID
    }
    
    func commit(updatesForSession UUID: String, using animation: UITableViewRowAnimation = .automatic) {
        self.commit(sectionUpdates: self.sections.observers[UUID]?.events, using: animation)
        
        self.sections.enumerated().forEach { (idx,section) in
            self.commit(rowUpdates: section.rows.observers[UUID]?.events, section: idx, using: animation)
        }
    }
    
    /// Commit actions to manipulate table's section
    ///
    /// - Parameters:
    ///   - updates: updates
    ///   - animation: animation to perform
    private func commit(sectionUpdates updates: [Event]?, using animation: UITableViewRowAnimation) {
        guard let updates = updates else { return }
        updates.forEach {
            switch $0.type {
            case .deleted:
                listView?.delete(sections: IndexSet($0.indexes))
            case .inserted:
                listView?.insert(sections: IndexSet($0.indexes))
            case .updated:
                listView?.reload(sections: IndexSet($0.indexes))
            }
        }
    }
    
    /// Commit actions to manipulate table's rows
    ///
    /// - Parameters:
    ///   - updates: updates
    ///   - section: parent section
    ///   - animation: animation
    private func commit(rowUpdates updates: [Event]?, section: Int, using animation: UITableViewRowAnimation) {
        guard let updates = updates else { return }
        updates.forEach {
            switch $0.type {
            case .deleted:
                let paths: [IndexPath] = $0.indexes.map {
                    return IndexPath(row: $0, section: section)
                }
                listView?.delete(rows: paths)
            case .inserted:
                let paths: [IndexPath] = $0.indexes.map {
                    return IndexPath(row: $0, section: section)
                }
                listView?.insert(rows: paths)
            case .updated:
                let paths = $0.indexes.map { IndexPath(row: $0, section: section) }
                listView?.reload(rows: paths, animation: animation)
            }
        }
    }
}
