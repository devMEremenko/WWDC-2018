//
//  Controller+Reloading.swift
//  Listable
//
//  Created by Maxim Eremenko on 3/25/18.
//  Copyright © 2018 Maxim Eremenko. All rights reserved.
//

import UIKit

extension BaseListController {
    
    /// Reload data for section with given identifier
    ///
    /// - Parameters:
    ///   - id: identifier of the section
    ///   - animation: animation to use
    public func reload(sectionWithID id: String, animation: UITableViewRowAnimation? = nil) {
        self.section(forID: id)?.reload(animation)
    }
    
    
    /// Reload data for sections with given identifiers. Non existing section are ignored.
    ///
    /// - Parameters:
    ///   - ids: identifier of the sections to reload
    ///   - animation: animation to use
    public func reload(sectionsWithIDs ids: [String],  animation: UITableViewRowAnimation? = nil) {
        var indexes: IndexSet = IndexSet()
        self.sections.enumerated().forEach { idx,item in
            if let id = item.identifier, ids.contains(id) {
                indexes.insert(idx)
            }
        }
        guard indexes.count > 0 else { return }
        listView?.reload(sections: indexes)
    }
    
    /// Reload data for given sections.
    ///
    /// - Parameters:
    ///   - sections: sections to reload
    ///   - animation: animation
    public func reload(sections: [Section], animation: UITableViewRowAnimation? = nil) {
        var indexes: IndexSet = IndexSet()
        self.sections.enumerated().forEach { idx,item in
            if sections.contains(item) {
                indexes.insert(idx)
            }
        }
        guard indexes.count > 0 else { return }
        listView?.reload(sections: indexes)
    }
    
    public func reload(paths: [IndexPath], animation: UITableViewRowAnimation? = nil) {
        listView?.reload(rows: paths, animation: animation)
    }
}
