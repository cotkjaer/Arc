//
//  ArcLayer.swift
//  Silverback
//
//  Created by Christian Otkjær on 12/12/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit
import Graphics
import Arithmetic
import Animation

let ArcWidthKey = "arcWidth"
let ArcStartAngleKey = "arcStartAngle"
let ArcEndAngleKey = "arcEndAngle"
let ArcClockwiseKey = "arcClockwise"
let ArcFillColorKey = "arcFillColor"
let ArcStrokeColorKey = "arcStrokeColor"
let ArcStrokeWidthKey = "arcStrokeWidth"

internal func isCustomKey(_ key: String) -> Bool
{
    switch key
    {
    case ArcWidthKey, ArcStartAngleKey, ArcEndAngleKey, ArcClockwiseKey, ArcFillColorKey, ArcStrokeColorKey, ArcStrokeWidthKey:
        return true
        
    default:
        return false
    }
}

open class DrawnArcLayer: CALayer
{
    //NB No good for animations if the view is large, but may be extended with start and end cap
    
    @NSManaged
    open var arcStartAngle : CGFloat
    
    @NSManaged
    open var arcEndAngle : CGFloat
    
    @NSManaged
    open var arcWidth : CGFloat
    
    @NSManaged
    open var arcClockwise : Bool
    
    @NSManaged
    open var arcFillColor : CGColor?
    
    @NSManaged
    open var arcStrokeColor : CGColor?
    
    @NSManaged
    open var arcStrokeWidth : CGFloat
    
    override init()
    {
        super.init()
        setupRasterize()
    }
    
    override init(layer: Any)
    {
        super.init(layer: layer)
        setupRasterize()
        
        guard let arcLayer = layer as? DrawnArcLayer else { return }
        
        arcStartAngle = arcLayer.arcStartAngle
        arcEndAngle = arcLayer.arcEndAngle
        arcFillColor = arcLayer.arcFillColor
        arcWidth = arcLayer.arcWidth
        arcClockwise = arcLayer.arcClockwise
        arcStrokeColor = arcLayer.arcStrokeColor
        arcStrokeWidth = arcLayer.arcStrokeWidth
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupRasterize()
    }
    
    private func setupRasterize()
    {
        shouldRasterize = true
        contentsScale = UIScreen.main.scale
        rasterizationScale = UIScreen.main.scale
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
    
    override open func draw(in ctx: CGContext)
    {
        if !shouldRasterize { setupRasterize() }
        
        UIGraphicsPushContext(ctx)
        
        let outerRadius = max(0,(min(bounds.width, bounds.height) - arcStrokeWidth)) / 2
        let innerRadius = max(0, (outerRadius - arcWidth) - arcStrokeWidth/2)
        
        let path = UIBezierPath(arcCenter: bounds.center, radius: innerRadius, startAngle: arcStartAngle, endAngle: arcEndAngle, clockwise: arcClockwise)
        
        path.addArc(withCenter: bounds.center, radius: outerRadius, startAngle: arcEndAngle, endAngle: arcStartAngle, clockwise: !arcClockwise)
        
        path.close()
        
        if let fillColor = self.arcFillColor?.uiColor
        {
            fillColor.setFill()
            
            path.fill()
        }
        
        if let strokeColor = self.arcStrokeColor?.uiColor, arcStrokeWidth > 0
        {
            path.lineWidth = arcStrokeWidth
            strokeColor.setStroke()
            
            path.stroke()
        }
        
        UIGraphicsPopContext()
    }
}

