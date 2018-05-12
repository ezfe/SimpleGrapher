//
//  GraphSeries.swift
//  CocoaSnaps
//
//  Created by Ezekiel Elin on 2/17/17.
//  Copyright © 2017 Ezekiel Elin. All rights reserved.
//

import AppKit

public class GraphSeries {
    public var color: NSColor = .white
    public var style: Style = .solid
    public var contents: [PlotCoordinate]
    
    init(contents: [PlotCoordinate]) {
        self.contents = contents
    }
    
    init() {
        self.contents = [PlotCoordinate]()
    }
    
    public enum Style {
        case solid
        case dashed
        case dotted
        
        public func getPattern() -> [CGFloat] {
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
