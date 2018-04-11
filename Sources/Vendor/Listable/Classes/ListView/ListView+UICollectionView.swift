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

extension UICollectionView: ListView {
    
    public func beginUpdates(_ handler: Empty) {
        performBatchUpdates(handler, completion: nil)
    }
    
    public func endUpdates(_ handler: Empty?) {
        handler?()
    }
    
    public func reload(sections: IndexSet) {
        performBatchUpdates({
            self.reloadSections(sections)
        }, completion: nil)
    }
    
    public func reload(rows: [IndexPath], animation: UITableViewRowAnimation?) {
        performBatchUpdates({
            self.reloadItems(at: rows)
        }, completion: nil)
    }
    
    public func delete(sections: IndexSet) {
        performBatchUpdates({
            self.deleteSections(sections)
        }, completion: nil)
    }
    
    public func insert(sections: IndexSet) {
        performBatchUpdates({
            self.insertSections(sections)
        }, completion: nil)
    }
    
    public func insert(rows: [IndexPath]) {
        performBatchUpdates({
            self.insertItems(at: rows)
        }, completion: nil)
    }
    
    public func delete(rows: [IndexPath]) {
        performBatchUpdates({
            self.deleteItems(at: rows)
        }, completion: nil)
    }
    
    public func dequeueCell(identifier: String, indexPath: IndexPath) -> UIView? {
        
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    public func dequeueHeaderFooter(id: String,
                                    _ kind: String?,
                                    _ path: IndexPath?) -> UIView? {
        guard let unwrappedKind = kind, let unwrappedPath = path else { return nil }
        return dequeueReusableSupplementaryView(ofKind: unwrappedKind,
                                                withReuseIdentifier: id,
                                                for: unwrappedPath)
    }
    
    public func register(nib: UINib, identifier: String) {
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func register(cell: AnyClass, identifier: String) {
        register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    public func register(headerFooter: AnyClass, identifier: String, kind: String?) {
        guard let unwrappedKind = kind else { return }
        register(headerFooter,
                 forSupplementaryViewOfKind: unwrappedKind,
                 withReuseIdentifier: identifier)
    }
    
    public func register(headerFooterNib: UINib, identifier: String, kind: String?) {
        guard let unwrappedKind = kind else { return }
        register(headerFooterNib,
                 forSupplementaryViewOfKind: unwrappedKind,
                 withReuseIdentifier: identifier)
    }
    
    public var separatorStyle: UITableViewCellSeparatorStyle { return .none }
    
    public var estimatedRowHeight: CGFloat { return 44 }
}
