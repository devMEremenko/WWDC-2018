//
//	TableController.swift
//	A declarative approach to UITableView management
//	------------------------------------------------
//	Created by:	Daniele Margutti
//				hello@danielemargutti.com
//				http://www.danielemargutti.com
//
//	Twitter:	@danielemargutti
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

import Foundation
import UIKit

/// TableManager is the class which manage the content and events of a `UITableView`.
/// You need to allocate this class with a valid table instance to manage.
/// Then you can use public funcs to add, remove or move rows.
open class TableController: BaseListController, UITableViewDataSource, UITableViewDelegate {
    
	/// Default height of the header/footer with plain style
	private static let HEADERFOOTER_HEIGHT: CGFloat = 44.0
	
	/// Indexes of the table
	private var sectionsIndexes: [Int]? = nil
	
	/// Indexes's titles of the table
	private var sectionsIndexesTitles: [String]? = nil
	
	/// Cached heights
	private var cachedRowHeights: [Int: CGFloat] = [:]
	
	/// Cell prototypes's cache
	private var prototypesCells: [String: UITableViewCell] = [:]
	
	/// If `true` the manager attempt to evaluate the size of the row automatically.
	/// The process maybe expensive (but cached); you should use it only if needed. If you can
	/// provide the height of a row easily you should do it.
	/// The process attempt to initialize a new instance of required cell, then layout subviews
	/// and uses `systemLayoutSizeFitting()` on cell's `contentView` to calculate the size.
	/// If zero value is returned it uses the cell's `contentView` bounds.
	private var estimateRowSizeAutomatically: Bool = true
	
	/// Initialize a new manager for a specific `UITableView` instance
	///
	/// - Parameter table: table instance to manage
	public init(table: UITableView, estimateRowHeight: Bool = true) {
        super.init(listView: table, estimateRowHeight: estimateRowHeight)
		table.delegate = self
		table.dataSource = self
	}
	
	/// Perform a non-animated reload of the data
	/// If you don't use `update` func you should call it when an operation on
	/// sections or rows in section in order to reflect changes on UI.
    open override func reloadData() {
		self.clearHeightCache()
		super.reloadData()
	}
    
	//MARK: DataSource
	
	/// Number of section in table
	///
	/// - Parameter tableView: target table
	/// - Returns: number of sections
	open func numberOfSections(in tableView: UITableView) -> Int {
		return self.sections.count
	}
	
	/// Number of rows in a particular section of the table
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section to get the number of elements
	/// - Returns: number of rows for this section
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.sections[section]).countRows
	}
	
	/// Tells the delegate that the specified cell was removed from the table.
	///
	/// - Parameters:
	///   - tableView: target table
	///   - cell: cell instance
	///   - indexPath: index path of the cell
	open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let hashedRow = cell.hashValue
		guard let row = self._removedRows[hashedRow] else {
			return
		}
		// let cell = tableView.cellForRow(at: indexPath) // instance of the cell
		// row.onDidEndDisplay?((cell,indexPath)) // send any message
		row.onDidEndDisplay?(row)
		// free removed rows instances
		self._removedRows.removeValue(forKey: hashedRow)
	}
	
	/// Cell for a particular `indexPath` in target table
	///
	/// - Parameters:
	///   - tableView: target table
	///   - indexPath: index path for the cell
	/// - Returns: a dequeued cell
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// Identify the row to allocate
		var row = self.sections[indexPath.section].rows[indexPath.row]
		
		// Allocate the class
		let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
		self.adjustLayout(forCell: cell) // adjust width of the cell if necessary
		
		// configure the cell
		row.configure(cell, path: indexPath)
		
		// dispatch dequeue event
		//row.onDequeue?((cell,indexPath))
		row.onDequeue?(row)
		
		return cell
	}
	
	
	/// Asks the delegate for the estimated height of a row in a specified location.
	///
	/// - Parameters:
	///   - tableView: The table-view object requesting this information.
	///   - indexPath: An index path that locates a row in tableView.
	/// - Returns: A nonnegative floating-point value that estimates the height (in points) that row should be.
	open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let row = self.sections[indexPath.section].rows[indexPath.row]
		let height = self.rowHeight(forRow: row, at: indexPath)
		return height
	}
    
    fileprivate func adjustLayout(forCell cell: UIView) {
        guard cell.frame.size.width != listView!.frame.size.width else {
            return
        }
        cell.frame = CGRect(x: 0, y: 0, width: listView!.frame.size.width, height: cell.frame.size.height)
        cell.layoutIfNeeded()
    }
	
	
	/// Asks the delegate for the estimated height of a row in a specified location.
	///
	/// - Parameters:
	///   - tableView: The table-view object requesting this information.
	///   - indexPath: An index path that locates a row in tableView.
	/// - Returns: A nonnegative floating-point value that estimates the height (in points) that row should be
	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		let row = self.sections[indexPath.section].rows[indexPath.row]
		return self.rowHeight(forRow: row, at: indexPath, estimate: true)
	}
	
	/// Tells the delegate that a header view is about to be displayed for the specified section.
	///
	/// - Parameters:
	///   - tableView: target tableview
	///   - view: view of the header
	///   - section: section
	public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let sectionView = self.sections[section].headerView else {
			return
		}
		sectionView.onWillDisplay?((view as? UITableViewHeaderFooterView,.header,section))
	}
	
	/// Tells the delegate that the specified header view was removed from the table.
	///
	/// - Parameters:
	///   - tableView: target tableview
	///   - view: view of the header
	///   - section: section
	public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		self.onRemoveHeaderFooterView(view, at: section)
	}
	
	///MARK: Footer
	
	/// Tells the delegate that the specified footer view was removed from the table.
	///
	/// - Parameters:
	///   - tableView: target tableview
	///   - view: view of the footer
	///   - section: section
	public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		self.onRemoveHeaderFooterView(view, at: section)
		
	}
	
	/// This method is called when an header/footer is removed from the table.
	/// It check if we have registered a callback for `didEndDisplaying` event.
	///
	/// - Parameters:
	///   - view: view removed (header or footer)
	///   - section: section
	private func onRemoveHeaderFooterView(_ view: UIView, at section: Int) {
		let key = view.hashValue
		guard let sectionView = self._removedHeaderFooterViews[key] else {
			return
		}
		self._removedHeaderFooterViews.removeValue(forKey: key)
		sectionView.didEndDisplaying?((view as? UITableViewHeaderFooterView,.header,section))
	}
	
	/// Simple header string
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section
	/// - Returns: header string if present, `nil` otherwise
	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return (self.sections[section]).headerTitle
	}
	
	/// Custom view to represent the header of a section
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section
	/// - Returns: header view to use (it overrides header string if set)
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return self.registerAndDequeueSection(at: section, .header)
	}
	
	/// Asks the delegate for the estimated height of the header of a particular section.
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section
	/// - Returns: the estimated height of the header instance
	public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		return self.sectionHeight(at: section, estimated: false, .header)
	}
	
	/// Height of the header for a section. It will be used only for header's custom view
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section
	/// - Returns: the height of the header
	open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return self.sectionHeight(at: section, estimated: false, .header)
	}
	
	///MARK: Footer
	
	/// Simple footer string
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section
	/// - Returns: footer string if present, `nil` otherwise
	open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return (self.sections[section]).footerTitle
	}
	
	/// Custom view to represent the footer of a section
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section
	/// - Returns: footer view to use (it overrides footer string if set)
	open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return self.registerAndDequeueSection(at: section, .footer)
	}
	
	/// Height of the footer for a section. It will be used only for footer's custom view
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section
	/// - Returns: the height of the footer instance
	open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return self.sectionHeight(at: section, estimated: false, .footer)
	}
	
	/// Asks the delegate for the estimated height of the footer of a particular section.
	///
	/// - Parameters:
	///   - tableView: target table
	///   - section: section
	/// - Returns: the estimated height of the footer instance
	open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		return self.sectionHeight(at: section, estimated: true, .footer)
	}
	
	/// Tells the delegate that a footer view is about to be displayed for the specified section.
	///
	/// - Parameters:
	///   - tableView: target tableview
	///   - view: view of the header
	///   - section: section
	open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		guard let sectionView = self.sections[section].footerView else {
			return
		}
		sectionView.onWillDisplay?((view as? UITableViewHeaderFooterView,.footer,section))
	}
	
	/// Support to show right side index like in the address book
	///
	/// - Parameter tableView: target table
	/// - Returns: strings to show for each section of the table
	open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return self.sectionsIndexesTitles
	}
	
	/// Asks the data source to return the index of the section having the given
	/// title and section title index.
	///
	/// - Parameters:
	///   - tableView: tableview
	///   - title:	The title as displayed in the section index of tableView.
	///   - index:	An index number identifying a section title in the array returned
	///				by `sectionIndexTitles(for:)`.
	/// - Returns: An index number identifying a section.
	open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return (self.sectionsIndexes?[index] ?? 0)
	}
	
	
	/// Tells the delegate that a specified row is about to be selected.
	///
	/// - Parameters:
	///   - tableView: A table-view object informing the delegate about the impending selection.
	///   - indexPath: An index path locating the row in tableView.
	/// - Returns:	An index-path object that confirms or alters the selected row.
	///				Return an NSIndexPath object other than indexPath if you want another cell
	///				to be selected. Return nil if you don't want the row selected.
	open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		//let cell = tableView.cellForRow(at: indexPath) // instance of the cell
		let row = self.sections[indexPath.section].rows[indexPath.row]
		
		if let onWillSelect = row.onWillSelect {
			//return onWillSelect((cell,indexPath))
			return onWillSelect(row)
		} else {
			return indexPath // not implemented
		}
	}
	
	/// Called to let you know that the user selected a row in the table.
	///
	/// - Parameters:
	///   - tableView: target table
	///   - indexPath: An index path locating the new selected row in tableView.
	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//let cell = tableView.cellForRow(at: indexPath) // instance of the cell
		let row = self.sections[indexPath.section].rows[indexPath.row]
		
		//let select_behaviour = row.onTap?((cell,indexPath)) ?? .deselect(true)
		let select_behaviour = row.onTap?(row) ?? .deselect(true)
		switch select_behaviour {
		case .deselect(let animated):
			// remove selection, is a temporary tap selection
			tableView.deselectRow(at: indexPath, animated: animated)
		case .keepSelection:
			//row.onSelect?((cell,indexPath)) // dispatch selection change event
			row.onSelect?(row) // dispatch selection change event
		}
	}
	
	/// Tells the delegate that the specified row is now deselected.
	///
	/// - Parameters:
	///   - tableView: target table
	///   - indexPath: An index path locating the deselected row in tableView.
	open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		// Dispatch on de-select event to the represented model of the row
		//let cell = tableView.cellForRow(at: indexPath)
		let row = self.sections[indexPath.section].rows[indexPath.row]
		//row.onDeselect?((cell,indexPath))
		row.onDeselect?(row)
	}
	
	
	/// Tells the delegate that the table view will display the specified cell at the
	/// specified row and column.
	///
	/// - Parameters:
	///   - tableView: The table view that sent the message.
	///   - cell: The cell to be displayed.
	///   - indexPath: An index path locating the row in tableView
	open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		// Dispatch display event for a particular cell to its represented model
		//let cell = tableView.cellForRow(at: indexPath)
		let row = self.sections[indexPath.section].rows[indexPath.row]
		//row.onWillDisplay?((cell,indexPath))
		row.onWillDisplay?(row)
	}
	
	
	/// Asks the delegate if the specified row should be highlighted
	///
	/// - Parameters:
	///   - tableView: The table-view object that is making this request.
	///   - indexPath: The index path of the row being highlighted.
	/// - Returns: `true` or `false`.
	open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		let row = self.sections[indexPath.section].rows[indexPath.row]
		// If static cell implements a valid value for `shouldHightlight`
		if let shouldHighlight = row._shouldHighlight {
			return shouldHighlight
		}
		if let instanceHighlight = row.shouldHighlight {
			return instanceHighlight
		}
		return row.onShouldHighlight?(row) ?? true
	}
	
	
	/// Asks the data source to verify that the given row is editable.
	///
	/// - Parameters:
	///   - tableView: The table-view object requesting this information.
	///   - indexPath: An index path locating a row in tableView.
	/// - Returns: true if the row indicated by indexPath is editable; otherwise, false.
	open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		let row = self.sections[indexPath.section].rows[indexPath.row]
		// If no actions are definined cell is not editable
		//return row.onEdit?((cell,indexPath))?.count ?? 0 > 0
		return row.onEdit?(row)?.count ?? 0 > 0
	}
	
	
	/// Asks the delegate for the actions to display in response to a swipe in the specified row.
	///
	/// - Parameters:
	///   - tableView: The table view object requesting this information.
	///   - indexPath: The index path of the row.
	/// - Returns: An array of UITableViewRowAction objects representing the actions
	///            for the row. Each action you provide is used to create a button that the user can tap.
	open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let row = self.sections[indexPath.section].rows[indexPath.row]
		return row.onEdit?(row) ?? nil
	}
	
	
	/// Asks the delegate for the editing style of a row at a particular location in a table view.
	///
	/// - Parameters:
	///   - tableView: The table-view object requesting this information.
	///   - indexPath: An index path locating a row in tableView.
	/// - Returns: The editing style of the cell for the row identified by indexPath.
	open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		let row = self.sections[indexPath.section].rows[indexPath.row]
		row.onDelete?(row)
	}
	
	
	/// Asks the data source whether a given row can be moved to another location in the table view.
	///
	/// - Parameters:
	///   - tableView: The table-view object requesting this information.
	///   - indexPath: An index path locating a row in tableView.
	/// - Returns: boolean
	open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		let row = self.sections[indexPath.section].rows[indexPath.row]
		return row.canMove?(row) ?? false
	}
	
	/// Asks the delegate whether the background of the specified row should be indented
	/// while the table view is in editing mode.
	///
	/// - Parameters:
	///   - tableView: The table-view object requesting this information.
	///   - indexPath: An index-path object locating the row in its section.
	/// - Returns: boolean
	open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		let row = self.sections[indexPath.section].rows[indexPath.row]
		return row.shouldIndentOnEditing?(row) ?? true
	}
	
	///MARK: Private Helper Methods
	
	/// This function evaluate the height of a section.
	/// Height is evaluated in this order:
	/// -	if the instance provide an implementation of `evaluateViewHeight()`/`evaluateEstimatedHeight` then use it
	///		if return a non `nil` value
	/// -	if the static var `defaultHeight`/`estimatedHeight` of the view's class return a non `nil` value use it
	/// -	return `UITableViewAutomaticDimension`
	///
	/// - Parameters:
	///   - index: section index
	///   - type: type of view (`header` or `footer`)
	/// - Returns: height of the section
	private func sectionHeight(at index: Int, estimated: Bool, _ type: SectionType) -> CGFloat {
		let section = self.sections[index]
		// get the view
		guard let sectionView = section.view(forType: type) else {
			// no custom view, check if it's the standard string header/footer
			if section.sectionTitle(forType: type)?.isEmpty ?? true {
				return 0 // no default title is set
			}
			return TableController.HEADERFOOTER_HEIGHT // default one, with default height
		}
		
		// Custom header/footer view, evaluating height
		// Has the user provided an evaluation function for view's height? If yes we can realy to it
		if estimated == false {
			if sectionView.evaluateViewHeight != nil {
				if let height = sectionView.evaluateViewHeight!(type) {
					return height
				}
			}
			
			// Had the user provided a static function which return the height of the view inside the view's class?
			if let static_height = sectionView.defaultHeight {
				return static_height
			}
			
		} else {
			if sectionView.evaluateEstimatedHeight != nil {
				if let height = sectionView.evaluateEstimatedHeight!(type) {
					return height
				}
			}
			
			// Had the user provided a static function which return the height of the view inside the view's class?
			if let static_height = sectionView.estimatedHeight {
				return static_height
			}
		}
		
		
		// If no other function are provided we can return the the automatic dimension
		return UITableViewAutomaticDimension
	}
	
	/// This function is responsibile to register (if necessary) and header/footer section view and return a new instance
	/// for a given section.
	///
	/// - Parameter index: index of the section
	/// - Returns: defined header/footer instance
	private func registerAndDequeueSection(at index: Int, _ type: SectionType) -> UIView? {
		// Was the section's header customized with a view?
		let section = self.sections[index]
		guard let sectionView = section.view(forType: type) else {
			return nil
		}
        
		// instantiate custom section
        let id = sectionView.reuseIdentifier
		guard let header = listView?.dequeueHeaderFooter(id: id, nil, nil) else {
			return nil
		}
		// give a chance to configure the header
		sectionView.configure(header, type: type, section: index)
		
		// call the on dequeue function
		sectionView.onDequeue?((header, type, index))
		
		return header
	}
	
	/// This function regenerate the indexes for each section in table
	///
	/// - Returns: return filled indexes and titles for each section
	private func regenerateSectionIndexes() -> (indexes: [Int]?, titles: [String]?) {
		var titles: [String] = []
		var indexes: [Int] = []
		
		self.sections.enumerated().forEach { idx,section in
			if let title = section.indexTitle {
				indexes.append(idx)
				titles.append(title)
			}
		}
		
		return ((indexes.isEmpty == false ? indexes : nil), titles)
	}
		
	private func rowHeight(forRow row: RowProtocol, at indexPath: IndexPath, estimate: Bool = false) -> CGFloat {
		let row = self.sections[indexPath.section].rows[indexPath.row]
		
		if let instanceHeight = row.rowHeight {
			return instanceHeight
		}
		
		/// User provided a function to evaluate the height of the table
		if row.evaluateRowHeight != nil {
			if let height = row.evaluateRowHeight!() {
				return height
			}
		}
		
		/// User provided the height of the table at class level (static based)
		if let static_height = row._defaultHeight {
			return static_height
		}
		
		/// Attempt to estimate the height of the row automatically
		if self.estimateRowSizeAutomatically == true && estimate == true {
			return self.estimatedHeight(forRow: row, at: indexPath)
		}
		
		// universal fallback to automatic dimension
		return UITableViewAutomaticDimension
	}
	
	/// This function attempt to evaluate the height of a cell
	///
	/// - Parameters:
	///   - row: the row to evaluate
	///   - indexPath: path of the row
	/// - Returns: the evaluated height
	private func height(forRow row: RowProtocol, at indexPath: IndexPath) -> CGFloat {
		if let height = self.cachedRowHeights[row.hashValue] {
			return height
		}
		
		var prototype_instance = self.prototypesCells[row.reuseIdentifier]
		if prototype_instance == nil {
            let cell = listView?.dequeueCell(identifier: row.identifier ?? "", indexPath: indexPath)
            prototype_instance = cell as? UITableViewCell //TODO:
			self.prototypesCells[row.reuseIdentifier] = prototype_instance
		}
		
		guard let cell = prototype_instance else { return 0 }
		
		cell.prepareForReuse()
		row.configure(cell, path: indexPath)
		cell.bounds = CGRect(x: 0, y: 0, width: listView!.bounds.size.width, height: cell.bounds.size.height)
		cell.layoutSubviews()
		
		// Determines the best size of the view considering all constraints it holds
		// and those of its subviews.
		var height = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
		if height == 0 {
			height = cell.bounds.size.height // zero result, uses cell's bounds
		}
		let separator = 1 / UIScreen.main.scale
		height += (listView!.separatorStyle != .none ? separator : 0)
		
		// Cache value
		cachedRowHeights[row.hashValue] = height
		
		return height
	}
	
	
	/// Attempt to provide an estimate of the row's height automatically.
	///
	/// - Parameters:
	///   - row: the row to evaluate
	///   - indexPath: path of the row
	/// - Returns: estimated height
	private func estimatedHeight(forRow row: RowProtocol, at indexPath: IndexPath) -> CGFloat {
		if let height = self.cachedRowHeights[row.hashValue] {
			return height
		}
		
		if let estimatedHeight = row._estimatedHeight , estimatedHeight > 0 {
			return estimatedHeight
		}
		
		return listView!.estimatedRowHeight
	}
	
	/// Clear cache's height
	private func clearHeightCache() {
		self.cachedRowHeights.removeAll()
		self.prototypesCells.removeAll()
	}
}
