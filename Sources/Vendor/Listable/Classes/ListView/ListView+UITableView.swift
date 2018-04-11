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

extension UITableView: ListView {
    
    //TODO: toMain
    public func beginUpdates(_ handler: Empty) {
        self.beginUpdates()
        handler()
    }
    
    public func endUpdates(_ handler: Empty?) {
        self.endUpdates()
        handler?()
    }
    
    public func delete(sections: IndexSet) {
        deleteSections(sections, with: .automatic)
    }
    
    public func insert(sections: IndexSet) {
        insertSections(sections, with: .automatic)
    }
    
    public func insert(rows: [IndexPath]) {
        insertRows(at: rows, with: .automatic)
    }
    
    public func delete(rows: [IndexPath]) {
        deleteRows(at: rows, with: .automatic)
    }
    
    public func reload(sections: IndexSet) {
        reloadSections(sections, with: .automatic)
    }
    
    public func reload(rows: [IndexPath], animation: UITableViewRowAnimation?) {
        reloadRows(at: rows, with: animation ?? .automatic)
    }
    
    public func dequeueCell(identifier: String, indexPath: IndexPath) -> UIView? {
        return dequeueReusableCell(withIdentifier: identifier)
    }
    
    public func dequeueHeaderFooter(id: String, _: String?, _: IndexPath?) -> UIView? {
        return dequeueReusableHeaderFooterView(withIdentifier: id)
    }
    
    public func register(nib: UINib, identifier: String) {
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func register(cell: AnyClass, identifier: String) {
        register(cell, forCellReuseIdentifier: identifier)
    }
    
    public func register(headerFooter: AnyClass, identifier: String, kind: String?) {
        register(headerFooter, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func register(headerFooterNib: UINib, identifier: String, kind: String?) {
        register(headerFooterNib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
