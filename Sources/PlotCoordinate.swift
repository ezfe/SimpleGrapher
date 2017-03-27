//
//  PlotCoordinate.swift
//  CocoaSnaps
//
//  Created by Ezekiel Elin on 2/17/17.
//  Copyright © 2017 Ezekiel Elin. All rights reserved.
//

import Foundation

struct PlotCoordinate {
    var x: Double
    var y: Double
    
    func calculateXPercentage(minX: Double, maxX: Double) -> Double {
        return x / (maxX - minX)
    }
    
    func calculateYPercentage(minY: Double, maxY: Double) -> Double {
        return y / (maxY - minY)
    }
    
    func calculateXLocation(offset: CGFloat, workingWidth: CGFloat, minX: Double, maxX: Double) -> CGFloat {
        return offset + workingWidth * CGFloat(calculateXPercentage(minX: minX, maxX: maxX))
    }
    
    func calculateYLocation(offset: CGFloat, workingHeight: CGFloat, minY: Double, maxY: Double) -> CGFloat {
        return offset + workingHeight * CGFloat(calculateYPercentage(minY: minY, maxY: maxY))
    }
    
    func point(xOffset: CGFloat, yOffset: CGFloat, workingWidth: CGFloat, workingHeight: CGFloat, minX: Double, maxX: Double, minY: Double, maxY: Double) -> NSPoint {
        let xpos = calculateXLocation(offset: xOffset, workingWidth: workingWidth, minX: minX, maxX: maxX)
        let ypos = calculateYLocation(offset: yOffset, workingHeight: workingHeight, minY: minY, maxY: maxY)
        return NSPoint(x: xpos, y: ypos)
    }
}
