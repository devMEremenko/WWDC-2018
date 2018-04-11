//
//  Controller+Insertion.swift
//  Listable
//
//  Created by Maxim Eremenko on 3/25/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

extension BaseListController {
    
    /// Move a row in another position.
    /// This is a composed operation: first of all row is removed from source, then is added to the new path.
    ///
    /// - Parameters:
    ///   - indexPath: source index path
    ///   - destIndexPath: destination index path
    public func move(row indexPath: IndexPath, to destIndexPath: IndexPath) {
        let row = self.section(atIndex: indexPath.section)!.remove(rowAt: indexPath.row)
        self.section(atIndex: destIndexPath.section)!.add(row, at: destIndexPath.row)
    }
    
    /// Insert a section at specified index of the table
    ///
    /// - Parameters:
    ///   - section: section
    ///   - index: index where the new section must be inserted
    /// - Returns: self
    @discardableResult
    public func insert(section: Section, at index: Int) -> Self {
        self.sections.insert(section, at: index)
        section.manager = self
        return self
    }
    
    /// Replace an existing section with the new passed
    ///
    /// - Parameters:
    ///   - index: index of section to replace
    ///   - section: new section to use
    /// - Returns: self
    @discardableResult
    public func replace(sectionAt index: Int, with section: Section) -> Self {
        guard index < self.sections.count else { return self }
        self.keepRemovedRows(Array(self.sections[index].rows))
        self.sections[index].manager = nil
        self.sections[index] = section
        section.manager = self
        return self
    }
}
