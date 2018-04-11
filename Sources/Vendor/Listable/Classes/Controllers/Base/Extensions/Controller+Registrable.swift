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

public protocol Registrable {
    
    func register(cell: AnyClass, identifier: String)
    
    func register(nib: UINib, identifier: String)
}

public protocol TableRegistrable: Registrable {
    
    func register(headerFooter: AnyClass, identifier: String)
    
    func register(headerFooterNib: UINib, identifier: String)
}

public protocol CollectionRegistrable: Registrable {
    
    func register(headerFooter: AnyClass, identifier: String, kind: String?)
    
    func register(headerFooterNib: UINib, identifier: String, kind: String?)
}

extension TableController: TableRegistrable {
    
    public func register(cell: AnyClass, identifier: String) {
        listView?.register(cell: cell, identifier: identifier)
    }
    
    public func register(nib: UINib, identifier: String) {
        listView?.register(nib: nib, identifier: identifier)
    }
    
    public func register(headerFooter: AnyClass, identifier: String) {
        listView?.register(headerFooter: headerFooter, identifier: identifier, kind: nil)
    }
    
    public func register(headerFooterNib: UINib, identifier: String) {
        listView?.register(headerFooterNib: headerFooterNib, identifier: identifier, kind: nil)
    }
}

extension CollectionController: CollectionRegistrable {
    
    public func register(cell: AnyClass, identifier: String) {
        listView?.register(cell: cell, identifier: identifier)
    }
    
    public func register(nib: UINib, identifier: String) {
        listView?.register(nib: nib, identifier: identifier)
    }
    
    public func register(headerFooter: AnyClass, identifier: String, kind: String?) {
        listView?.register(headerFooter: headerFooter, identifier: identifier, kind: kind)
    }
    
    public func register(headerFooterNib: UINib, identifier: String, kind: String?) {
        listView?.register(headerFooterNib: headerFooterNib, identifier: identifier, kind: kind)
    }
}
