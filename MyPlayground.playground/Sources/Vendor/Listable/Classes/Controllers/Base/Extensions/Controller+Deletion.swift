//
//  Controller+Deletion.swift
//  Listable
//
//  Created by Maxim Eremenko on 3/25/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

extension BaseListController {
    
    /// Remove section with given identifier. If section does not exist nothing is altered.
    ///
    /// - Parameter id: identifier of the section
    /// - Returns: `true` if section exists and it's been removed, `false` otherwise.
    @discardableResult
    public func remove(sectionWithID id: String) -> Bool {
        guard let section = self.section(forID: id) else { return false }
        self.remove(section: section)
        return true
    }
    
    /// Remove an existing section at specified index
    ///
    /// - Parameter index: index of the section to remove
    /// - Returns: self
    @discardableResult
    public func remove(sectionAt index: Int) -> Self {
        guard index < self.sections.count else { return self }
        let removedSection = self.sections.remove(at: index)
        self.keepRemovedSections([removedSection])
        self.keepRemovedRows(Array(removedSection.rows))
        removedSection.manager = nil
        return self
    }
    
    /// Remove section from table
    ///
    /// - Parameter section: section to remove
    /// - Returns: self
    @discardableResult
    public func remove(section: Section?) -> Self {
        guard let section = section else { return self }
        if let idx = self.sections.index(of: section) {
            self.remove(sectionAt: idx)
        }
        return self
    }
    
    /// Remove all sections from the table
    ///
    /// - Returns: self
    @discardableResult
    public func removeAll() -> Self {
        let removedRows = self.sections.flatMap { $0.rows }
        self.keepRemovedRows(removedRows)
        self.keepRemovedSections(Array(self.sections))
        self.sections.forEach { $0.manager = nil }
        self.sections.removeAll()
        return self
    }
}
