//
//  GraphSeries.swift
//  CocoaSnaps
//
//  Created by Ezekiel Elin on 2/17/17.
//  Copyright © 2017 Ezekiel Elin. All rights reserved.
//

import AppKit

public protocol GraphSeriesProtocol {
    var color: NSColor { get }
    var style: GraphStyle { get }
    var contents: [PlotCoordinate] { get }
    
    var circlePoints: Bool { get }
    var connectPoints: Bool { get }
}

public struct SimpleGraphSeries: GraphSeriesProtocol {
    public var color: NSColor
    public var style: GraphStyle
    public var contents: [PlotCoordinate]
    
    public var circlePoints: Bool = true
    public var connectPoints: Bool = true
    
    public init(color: NSColor, style: GraphStyle, contents: [PlotCoordinate]) {
        self.color = color
        self.style = style
        self.contents = contents
    }
}

public enum GraphStyle {
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
