//
//  TimeGraph.swift
//  CocoaSnaps
//
//  Created by Ezekiel Elin on 2/16/17.
//  Copyright © 2017 Ezekiel Elin. All rights reserved.
//

import Cocoa

public class TimeGraph: NSView {
    public var topMargin: CGFloat = 20
    public var bottomMargin: CGFloat = 20
    public var leftMargin: CGFloat = 20
    public var rightMargin: CGFloat = 25
    public var labelMargin: CGFloat = 8
    
    public var horizontalLines: Int = 5
    public var verticalLines: Int = 0
    
    public var startColor: NSColor = NSColor(calibratedRed: 0, green: 128, blue: 255, alpha: 1.0)
    public var endColor: NSColor = NSColor(calibratedRed: 0, green: 0, blue: 255, alpha: 1.0)
    public var primaryLineColor: NSColor = NSColor.white
    public var secondaryLineColor: NSColor = NSColor(white: 1.0, alpha: 0.3)
    public var labelColor: NSColor = NSColor.white
    
    public var cumulative: Bool = true
    
    @available(macOS, unavailable, message: "Specificy circled with the series")
    public var circlePoints: Bool = true
    @available(macOS, unavailable, message: "Specificy connectivity with the series")
    public var connectPoints: Bool = true
    
    public var xAxisFormatter: (Double) -> String = { (number) in
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 3
        
        return nf.string(from: NSNumber(value: number)) ?? "?"
    }
    
    public var yAxisFormatter: (Double) -> String = { (number) in
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 3
        
        return nf.string(from: NSNumber(value: number)) ?? "?"
    }
    
    public var graphSeries = Array<GraphSeriesProtocol>() {
        didSet {
            minX = graphSeries.first?.contents.first?.x ?? 0.0
            for series in graphSeries {
                for point in series.contents {
                    minX = min(minX, point.x)
                }
            }
            
            maxX = graphSeries.first?.contents.first?.x ?? 0.0
            for series in graphSeries {
                for point in series.contents {
                    maxX = max(maxX, point.x)
                }
            }
            
            maxY = graphSeries.first?.contents.first?.y ?? 0.0
            for series in graphSeries {
                for point in series.contents {
                    maxY = max(maxY, point.y)
                }
            }
        }
    }
    
    var minX: Double = 0.0
    var maxX: Double = 0.0
    var minY: Double = 0.0
    var maxY: Double = 0.0
    
    override public func draw(_ dirtyRect: NSRect) {
        let context = NSGraphicsContext.current?.cgContext
        
        let totalWidth = dirtyRect.width
        let totalHeight = dirtyRect.height
        
        let leadingEdge = leftMargin
        let topEdge = totalHeight - topMargin
        
        /* Bottom Label Height */
        
        let xtext = xAxisFormatter(0).toNSString()
        let maxLabelHeight: CGFloat = xtext.size(withAttributes: nil).height
        
        /* Trailing, Bottom Edge, Working Height & Width */
        
        let bottomEdge = bottomMargin + maxLabelHeight
        
        let workingHeight = topEdge - bottomEdge
        
        /* Column and Row Sizes */
        
        let rowSize = workingHeight / CGFloat(max(horizontalLines - 1, 1))
        
        /* Right Label Max Width */
        
        var maxLabelWidth: CGFloat = 0.0
        
        for i in 0..<self.horizontalLines {
            let percent = Double(rowSize) * Double(i) / Double(workingHeight)
            let value = (Double(maxY - minY) * percent) + Double(minY)
            let text = xAxisFormatter(value).toNSString()
            
            let textSize = text.size(withAttributes: nil)
            
            maxLabelWidth = max(textSize.width, maxLabelWidth)
        }
        
        let trailingEdge = totalWidth - rightMargin - maxLabelWidth
        let workingWidth = trailingEdge - leadingEdge
        let columnSize = workingWidth / CGFloat(max(verticalLines - 1, 1))
        
        /* Rounded Edges */
        
        let path = NSBezierPath(roundedRect: dirtyRect, xRadius: 8, yRadius: 8)
        path.addClip()
        
        /* Gradient */
        
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations)!
        
        let startPoint = CGPoint(x: 0, y: self.bounds.height)
        let endPoint = CGPoint.zero
        context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        /* Main Line */
        
        for series in graphSeries where series.connectPoints {
            series.color.setFill()
            series.color.setStroke()

            let graphPath = NSBezierPath()
            
            guard let first = series.contents.first else {
                Swift.print("No first...")
                return
            }
            
            let fpoint = first.point(xOffset: leadingEdge, yOffset: bottomEdge, workingWidth: workingWidth, workingHeight: workingHeight, minX: minX, maxX: maxX, minY: minY, maxY: maxY)
            graphPath.move(to: fpoint)
            for point in series.contents.dropFirst() {
                let nspoint = point.point(xOffset: leadingEdge, yOffset: bottomEdge, workingWidth: workingWidth, workingHeight: workingHeight, minX: minX, maxX: maxX, minY: minY, maxY: maxY)
                graphPath.line(to: nspoint)
            }
            
            if series.style != .solid {
                graphPath.setLineDash(series.style.getPattern(), count: series.style.getPattern().count, phase: 0)
            }
            graphPath.lineWidth = 2.0
            graphPath.stroke()
        }
        
        /* Point Circles */
        
        for series in graphSeries where series.circlePoints {
            series.color.setFill()
            series.color.setStroke()

            for point in series.contents {
                var nspoint = point.point(xOffset: leadingEdge, yOffset: bottomEdge, workingWidth: workingWidth, workingHeight: workingHeight, minX: minX, maxX: maxX, minY: minY, maxY: maxY)
                let radius: CGFloat = 2.5
                
                nspoint.x -= radius
                nspoint.y -= radius
                
                let circle = NSBezierPath(ovalIn: CGRect(origin: nspoint, size: CGSize(width: 2 * radius, height: 2 * radius)))
                circle.fill()
            }
        }
        
        /* Horizontal Lines and Labels */
        
        let linePath = NSBezierPath()
        
        for i in 0..<self.horizontalLines {
            let y = bottomEdge + (rowSize * CGFloat(i))
            
            let percent = Double(rowSize) * Double(i) / Double(workingHeight)
            let value = (Double(maxY - minY) * percent) + Double(minY)
            let text = yAxisFormatter(value).toNSString()
            
            let textSize = text.size(withAttributes: nil)
            text.draw(at: NSPoint(x: trailingEdge + labelMargin, y: y - (textSize.height / 2)), withAttributes: [NSAttributedString.Key.foregroundColor: labelColor])
            
            linePath.move(to: NSPoint(x: leadingEdge, y: y))
            linePath.line(to: NSPoint(x: trailingEdge, y: y))
        }
        
        for i in 0..<self.verticalLines {
            let x = leadingEdge + (columnSize * CGFloat(i))
            
            let percent = Double(columnSize) * Double(i) / Double(workingWidth)
            let value = (Double(maxX - minX) * percent) + Double(minX)
            let text = xAxisFormatter(value).toNSString()
            
            let textSize = text.size(withAttributes: nil)
            text.draw(at: NSPoint(x: x - (textSize.width / 2.0), y: bottomEdge - textSize.height - labelMargin), withAttributes: [NSAttributedString.Key.foregroundColor: labelColor])
            
            linePath.move(to: NSPoint(x: x, y: bottomEdge))
            linePath.line(to: NSPoint(x: x, y: topEdge))
        }
        
        let color = secondaryLineColor
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
}
