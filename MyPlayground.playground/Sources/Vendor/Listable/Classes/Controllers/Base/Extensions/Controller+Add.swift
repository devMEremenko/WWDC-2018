//
//  Controller+Deletion.swift
//  Listable
//
//  Created by Maxim Eremenko on 3/25/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

extension BaseListController {
    
    /// Add a new section to the table
    ///
    /// - Parameter section: section to add
    /// - Returns: self
    @discardableResult
    public func add(section: Section) -> Self {
        self.sections.append(section)
        section.manager = self
        return self
    }
    
    /// Add a list of sections to the table
    ///
    /// - Parameter sectionsToAdd: sections to add
    /// - Returns: self
    @discardableResult
    public func add(sections sectionsToAdd: [Section]) -> Self {
        self.sections.append(contentsOf: sectionsToAdd)
        sectionsToAdd.forEach { $0.manager = self }
        return self
    }
    
    /// Add rows to a section, if section is `nil` a new section is appened with rows at the end of table
    ///
    /// - Parameters:
    ///   - rows: rows to add
    ///   - section: destination section. If `nil` is passed a new section is append at the end of the table with given rows.
    /// - Returns: self
    @discardableResult
    public func add(rows: [RowProtocol], in section: Section? = nil) -> Self {
        if let section = section {
            section.rows.append(contentsOf: rows)
        } else {
            let newSection = Section(rows: rows)
            newSection.manager = self
            self.sections.append(newSection)
        }
        return self
    }
    
    /// Add rows to a section specified at index
    ///
    /// - Parameters:
    ///   - rows: rows to add
    ///   - index: index of the destination section. If `nil` is passed rows will be added to the last section of the table. If no sections are available, a new section with passed rows will be created automatically.
    /// - Returns: self
    @discardableResult
    public func add(rows: [RowProtocol], inSectionAt index: Int?) -> Self {
        if let index = index { // append to a specific section
            guard index < self.sections.count else { return self } // validate index
            self.sections[index].rows.append(contentsOf: rows)
        } else {
            let destSection = self.sections.last ?? Section() // destination is the last section or a new section
            destSection.manager = self
            destSection.rows.append(contentsOf: rows)
        }
        return self
    }
    
    /// Add a new row into a section; if section is `nil` a new section is created and added at the end
    /// of table.
    ///
    /// - Parameters:
    ///   - row: row to add
    ///   - section: destination section, `nil` create and added a new section at the end of the table
    /// - Returns: self
    @discardableResult
    public func add(row: RowProtocol, in section: Section? = nil) -> Self {
        if let section = section {
            section.rows.append(row)
        } else {
            let newSection = Section(rows: [row])
            newSection.manager = self
            self.sections.append(newSection)
        }
        return self
    }
    
    
    /// Add a new row into specified section.
    ///
    /// - Parameters:
    ///   - row: row to add
    ///   - index: index of the destination section. If `nil` is passed the last section is used as destination.
    ///                if no sections are present into the table a new section with given row is created automatically.
    /// - Returns: self
    @discardableResult
    public func add(row: RowProtocol, inSectionAt index: Int?) -> Self {
        if let index = index { // destination is a specific section
            guard index < self.sections.count else { return self }
            self.sections[index].rows.append(row)
        } else {
            let destSection = self.sections.last ?? Section() // destination is the last section or a new section
            destSection.manager = self
            destSection.rows.append(row)
        }
        return self
    }
}
