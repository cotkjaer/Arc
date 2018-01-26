//
//  SolidArcView.swift
//  Arc
//
//  Created by Christian Otkjær on 12/01/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit
import Graphics

/**
 View containing an animatable solid arc (one color, no border)
 */
@IBDesignable
open class SolidArcView: UIView
{
    private var arcLayer : SolidArcLayer? { return layer as? SolidArcLayer }
    
    /**
     Arcs ends are capped in the style given. 
     - note: not animatable
     */
    open var arcCap: ArcCap
        {
        set { arcLayer?.arcCap = newValue }
        get { return arcLayer?.arcCap ?? .butt }
    }
    
    /**
     Arcs starting angle in radians 
     - note: any value is allowed, but do not change it by more than 2π at a time
     */
    @IBInspectable
    open var arcAngle: CGFloat
        {
        set { arcLayer?.arcAngle = newValue }
        get { return arcLayer?.arcAngle ?? 0 }
    }
    
    /**
     Arcs angle-span in radians
     - note: values in the interval [0;2π] are allowed. Setting any value outside this will result in it being clamped to the interval
     */
    @IBInspectable
    open var arcSpan: CGFloat
        {
        set { arcLayer?.arcSpan = newValue }
        get { return arcLayer?.arcSpan ?? 0 }
    }
    
    /**
     The width of the arc in points
     */
    @IBInspectable
    open var arcWidth: CGFloat
        {
        set { arcLayer?.arcWidth = newValue }
        get { return arcLayer?.arcWidth ?? 0 }
    }
    
    /**
     The color of the arc
     */
    @IBInspectable
    open var arcColor: UIColor?
        {
        set { arcLayer?.arcColor = newValue?.cgColor }
        get { return arcLayer?.arcColor?.uiColor }
    }
    
    override open class var layerClass : AnyClass
    {
        return SolidArcLayer.self
    }
    
    public var arcPath: UIBezierPath?
    {
        return arcLayer?.arcPath
    }
    
    // MARK: - Hit testing
    
    open func gestureTouchesArcTrack(gesture: UIGestureRecognizer) -> Bool
    {
        return distanceToArcTrack(point: gesture.location(in: self)) < arcWidth / 2
    }
    
    open func gestureTouchesArc(gesture: UIGestureRecognizer) -> Bool
    {
        return distanceToArcTrack(point: gesture.location(in: self)) < arcWidth / 2
    }
    
    
    private func distanceToArcTrack(point: CGPoint) -> CGFloat
    {
        let radius = min(bounds.width, bounds.height) / 2
        
        let realArcWidth = min(radius, max(1, abs(arcWidth)))
        
        let arcRadius = max(0, radius - realArcWidth / 2)
        
        let distance = abs(arcRadius - Graphics.distance(bounds.center, point))
        
        return distance
    }
}
