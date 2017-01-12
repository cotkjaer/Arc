//
//  ShapeArcLayer.swift
//  Arc
//
//  Created by Christian Otkjær on 12/01/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit

open class ShapeArcLayer: CAShapeLayer
{
    private var startAngle : CGFloat = 0
    
    open var arcStartAngle : CGFloat
        {
        set { startAngle = newValue; path = createPath()}
        get { return startAngle }
    }
    
    private var endAngle : CGFloat = 0
    
    open var arcEndAngle : CGFloat
        {
        set { endAngle = newValue; path = createPath()}
        get { return endAngle }
    }
    
    private var width : CGFloat = 0
    
    open var arcWidth : CGFloat
        {
        set { width = newValue; path = createPath()}
        get { return width }
    }
    
    open var arcClockwise : Bool = true
        { didSet { path = createPath() } }
    
    //    @NSManaged
    //    open var arcFillColor : CGColor?
    //
    //    @NSManaged
    //    open var arcStrokeColor : CGColor?
    
    func createPath() -> CGPath
    {
        let outerRadius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let innerRadius = max(0, outerRadius - arcWidth)
        
        let path = UIBezierPath(arcCenter: bounds.center, radius: innerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: arcClockwise)
        
        path.addArc(withCenter: bounds.center, radius: outerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: !arcClockwise)
        
        path.close()
        
        return path.cgPath
    }
    
    override init()
    {
        super.init()
    }
    
    override init(layer: Any)
    {
        super.init(layer: layer)
        
        guard let aLayer = layer as? DrawnArcLayer else { return }
        
        arcStartAngle = aLayer.arcStartAngle
        arcEndAngle = aLayer.arcEndAngle
        //        arcFillColor = aLayer.arcFillColor
        //        arcStrokeColor = aLayer.arcStrokeColor
        arcWidth = aLayer.arcWidth
        arcClockwise = aLayer.arcClockwise
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    private class func isCustomKey(_ key: String) -> Bool
    {
        switch key
        {
        case ArcWidthKey, ArcStartAngleKey, ArcEndAngleKey, ArcClockwiseKey, ArcFillColorKey, ArcStrokeColorKey:
            return true
            
        default:
            return false
        }
    }
    
    override open class func needsDisplay(forKey key: String) -> Bool
    {
        return isCustomKey(key) || super.needsDisplay(forKey: key)
    }
    
    override open func action(forKey key: String) -> CAAction?
    {
        guard isCustomKey(key) else { return super.action(forKey: key) }
        
        // Get a fully configured animation if we are animating in a UIView.animate
        guard let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation else { setNeedsDisplay(); return nil }
        
        animation.fromValue = presentation()?.value(forKey: key)
        animation.keyPath = key
        animation.toValue = nil
        
        return animation
    }
}
