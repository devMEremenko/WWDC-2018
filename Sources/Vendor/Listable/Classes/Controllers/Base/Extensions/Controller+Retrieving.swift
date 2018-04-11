//
//  Controller+Retrieving.swift
//  Listable
//
//  Created by Maxim Eremenko on 3/25/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

extension BaseListController {
    
    /// Return `true` if associated table does not contains sections or rows
    public var isEmpty: Bool {
        return self.sections.count == 0
    }
    
    /// Return the first row with given identifier inside all sections of the table
    ///
    /// - Parameter identifier: identifier to search
    /// - Returns: found Row, or `nil`
    public func row(forID identifier: String) -> RowProtocol? {
        for section in self.sections {
            if let firstMatch = section.rows.first(where: { $0.identifier == identifier }) {
                return firstMatch
            }
        }
        return nil
    }
    
    /// Return any row in table's section with given identifiers
    ///
    /// - Parameter identifiers: identifiers to search
    /// - Returns: found `[Row]` or empty array
    public func row(forIDs identifiers: [String]) -> [RowProtocol] {
        var list: [RowProtocol] = []
        for section in self.sections {
            list.append(contentsOf: section.rows.filter {
                if let id = $0.identifier {
                    return identifiers.contains(id)
                }
                return false
            })
        }
        return list
    }
    
    /// Return `true` if table contains passed section with given identifier, `false` otherwise
    ///
    /// - Parameter identifier: identifier to search
    /// - Returns: `true` if section is in table, `false` otherwise
    public func hasSection(withID identifier: String) -> Bool {
        let exist = self.section(forID: identifier)
        return exist != nil
    }
    
    /// Return all sections with given identifiers
    ///
    /// - Parameter ids: identifiers to search
    /// - Returns: found sections
    public func sections(forIDs ids: [String]) -> [Section] {
        return self.sections.filter({
            guard let id = $0.identifier else { return false }
            return ids.contains(id)
        })
    }
    
    public func section(atIndex idx: Int) -> Section? {
        guard idx < self.sections.count else { return nil }
        return self.sections[idx]
    }
    
    public func section(forID identifier: String) -> Section? {
        return self.sections.first(where: { $0.identifier == identifier })
    }
    
    public func row(at section: Int, row: Int) -> RowProtocol? {
        guard let found = self.section(atIndex: section) else { return nil }
        return found.row(at: row)
    }
}
