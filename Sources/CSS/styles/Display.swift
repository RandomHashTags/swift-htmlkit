//
//  Display.swift
//
//
//  Created by Evan Anderson on 1/30/25.
//

import HTMLKitUtilities

extension CSSStyle {
    public enum Display : String, HTMLInitializable {
        /// Displays an element as a block element (like `<p>`). It starts on a new line, and takes up the whole width
        case block

        /// Makes the container disappear, making the child elements children of the element the next level up in the DOM
        case contents

        /// Displays an element as a block-level flex container
        case flex

        /// Displays an element as a block-level grid container
        case grid

        /// Displays an element as an inline element (like `<span>`). Any height and width properties will have no effect. This is default.
        case inline

        /// Displays an element as an inline-level block container. The element itself is formatted as an inline element, but you can apply height and width values
        case inlineBlock

        /// Displays an element as an inline-level flex container
        case inlineFlex

        /// Displays an element as an inline-level grid container
        case inlineGrid
        
        /// The element is displayed as an inline-level table
        case inlineTable 

        /// Inherits this property from its parent element. [Read about _inherit_](https://www.w3schools.com/cssref/css_inherit.php)
        case inherit

        /// Sets this property to its default value. [Read about _initial_](https://www.w3schools.com/cssref/css_initial.php)
        case initial

        /// Let the element behave like a `<li>` element  
        case listItem

        /// The element is completely removed
        case none

        /// Displays an element as either block or inline, depending on context 
        case runIn

        /// Let the element behave like a `<table>` element
        case table

        /// Let the element behave like a `<caption>` element
        case tableCaption

        /// Let the element behave like a `<td>` element
        case tableCell

        /// Let the element behave like a `<col>` element
        case tableColumn

        /// Let the element behave like a `<colgroup>` element
        case tableColumnGroup

        /// Let the element behave like a `<tfoot>` element
        case tableFooterGroup

        /// Let the element behave like a `<thead>` element
        case tableHeaderGroup

        /// Let the element behave like a `<tr>` element
        case tableRow

        /// Let the element behave like a `<tbody>` element
        case tableRowGroup

        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .inlineBlock: return "inline-block"
            case .inlineFlex: return "inline-flex"
            case .inlineGrid: return "inline-grid"
            case .inlineTable: return "inline-table"
            case .listItem: return "list-item"
            case .runIn: return "run-in"
            case .tableCaption: return "table-caption"
            case .tableCell: return "table-cell"
            case .tableColumn: return "table-column"
            case .tableColumnGroup: return "table-column-group"
            case .tableFooterGroup: return "table-footer-group"
            case .tableHeaderGroup: return "table-header-group"
            case .tableRow: return "table-row"
            case .tableRowGroup: return "table-row-group"
            default: return rawValue
            }
        }
    }
}