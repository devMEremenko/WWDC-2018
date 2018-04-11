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

public protocol ListView: class {
    
    //TODO: toMain
    //TODO: add animations
    func reload(sections: IndexSet)
    
    func reload(rows: [IndexPath], animation: UITableViewRowAnimation?)
    
    func reloadData()
    
    
    func delete(sections: IndexSet)
    
    func delete(rows: [IndexPath])
    
    
    func insert(sections: IndexSet)
    
    func insert(rows: [IndexPath])
    
    
    
    func beginUpdates(_ handler: Empty)
    
    func endUpdates(_ handler: Empty?)
    
    
    //TODO: UIView
    func dequeueCell(identifier: String, indexPath: IndexPath) -> UIView?
    
    func dequeueHeaderFooter(id: String, _ kind: String?, _ path: IndexPath?) -> UIView?
    
    
    func register(nib: UINib, identifier: String)
    
    func register(cell: AnyClass, identifier: String)
    
    func register(headerFooter: AnyClass, identifier: String, kind: String?)
    
    func register(headerFooterNib: UINib, identifier: String, kind: String?)
    
    
    var frame: CGRect { get }
    
    var bounds: CGRect { get }
    
    var separatorStyle: UITableViewCellSeparatorStyle { get }
    
    var estimatedRowHeight: CGFloat { get }
}
