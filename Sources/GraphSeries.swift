//
//  GraphSeries.swift
//  CocoaSnaps
//
//  Created by Ezekiel Elin on 2/17/17.
//  Copyright © 2017 Ezekiel Elin. All rights reserved.
//

import AppKit

class GraphSeries {
    var color: NSColor = NSColor.white
    var style: Style = .solid
    var contents: [PlotCoordinate]
    
    init(contents: [PlotCoordinate]) {
        self.contents = contents
    }
    
    init() {
        self.contents = [PlotCoordinate]()
    }
    
    enum Style {
        case solid
        case dashed
        case dotted
        
        func getPattern() -> [CGFloat] {
            switch self {
            case .solid:
                return [CGFloat]()
            case .dashed:
                return [5.0, 1.0]
            case .dotted:
                return [2.0, 2.0]
            }
        }
    }

}
