//
//  ArcLayer.swift
//  Silverback
//
//  Created by Christian Otkjær on 12/12/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit
import Geometry
import Graphics
import Animation

private let π = CGFloat.π
private let π2 = CGFloat.π2
private let π4 = π2 * 2
private let π6 = π2 + π4
private let oneThird : CGFloat = 1.0/3.0
private let twoThird : CGFloat = 2.0/3.0

public class ArcLayer: CAShapeLayer
{
    private func normalizeAngleTo6π(angle: CGFloat) -> CGFloat
    {
        var angle = angle
        
        while angle > π6
        {
            angle -= π6
        }
        
        while angle < 0
        {
            angle += π6
        }
    
        return angle
    }
    
    private func strokeForAngle(angle: CGFloat) -> CGFloat
    {
        return normalizeAngleTo6π(angle) / π6
    }
    
    public var arcStartAngle : CGFloat = 0
        {
        willSet
        {
            adjustStartAndEndStroke(deltaStartAngle: newValue - arcStartAngle)
        }
    }
    
    public var arcEndAngle : CGFloat = π
        {
        willSet
        {
            adjustStartAndEndStroke(deltaEndAngle: newValue - arcEndAngle)
        }
    }
    
    public var arcWidth : CGFloat
        {
        set
        {
            if lineWidth != newValue
            {
                lineWidth = newValue
                updatePath()
            }

        }
        get { return lineWidth }
    }
    
    override public var lineWidth : CGFloat { didSet { updatePath() } }
    
    public var arcClockwise : Bool = true
        {
        didSet { adjustStartAndEndStroke() }
    }
    
    public var arcColor : CGColor
        {
        set { strokeColor = newValue }
        get { return strokeColor ?? UIColor.clearColor().CGColor }
    }

    // MARK: - Bounds
    
    override public var bounds : CGRect { didSet { updatePath() } }
    
    // MARK: - Init
    
    override public init()
    {
        super.init()
        setup()
    }
    
    override public init(layer: AnyObject)
    {
        super.init(layer: layer)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup()
    {
        fillColor = UIColor.clearColor().CGColor
        updatePath()
    }
    
    // MARK: - Update
    
    // MARK: start- and end-stroke
    
    private func strokeToAngle(stroke: CGFloat) -> CGFloat
    {
        return normalizeAngle(stroke * π4, π)
    }
    
    private func findAngles() -> (CGFloat, CGFloat)
    {
        var realStartAngle = arcStartAngle
        var realEndAngle = arcEndAngle
        
        if !arcClockwise
        {
            swap(&realStartAngle, &realEndAngle)
        }

        while realStartAngle < π2 { realStartAngle += π2; realEndAngle += π2 }
        while realEndAngle >= π4 { realStartAngle -= π2; realEndAngle -= π2 }

        while realEndAngle < realStartAngle { realEndAngle += π2 }

        let realStrokeStart = strokeForAngle(realStartAngle)
        let realStrokeEnd = strokeForAngle(realEndAngle)
        
        return (realStrokeStart, realStrokeEnd)
    }
    
    private func adjustStartAndEndStroke(duration: Double = 0.1,
        deltaStartAngle: CGFloat? = nil,
        deltaEndAngle: CGFloat? = nil
        )
    {
        let (realStrokeStart, realStrokeEnd) = findAngles()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        (strokeStart, strokeEnd) = (realStrokeStart, realStrokeEnd)
        
        CATransaction.commit()
        
        if let delta = deltaStartAngle
        {
            animate(realStrokeStart + delta / π6, duration: duration, keyPath: "strokeStart")
        }
        
        if let delta = deltaEndAngle
        {
            animate(realStrokeEnd + delta / π6, duration: duration, keyPath: "strokeEnd")
        }
    }
    
    // MARK: Path
    
    private func updatePath(duration: Double = 0.1)
    {
        let radius = floor((min(bounds.width, bounds.height) - arcWidth) / 2)
        
        let threeLoops = UIBezierPath(arcCenter: bounds.center, radius: radius, startAngle: 0, endAngle: π2, clockwise: true)

        threeLoops.addArcWithCenter(bounds.center, radius: radius, startAngle: 0, endAngle: π2, clockwise: true)

        threeLoops.addArcWithCenter(bounds.center, radius: radius, startAngle: 0, endAngle: π2, clockwise: true)
        
        animate(threeLoops.CGPath, duration: duration, keyPath: "path")
    }
}

// MARK: - Layer

class AArcLayer: CAShapeLayer
{
    var arcStartAngle : CGFloat
        {
        set { rotation = newValue }//setValue(newValue, forKeyPath: "transform.rotation.z") }
        get { return rotation }//valueForKeyPath("transform.rotation.z") as! CGFloat }
    }
    
    var arcEndAngle : CGFloat
        {
        set { strokeEnd = (newValue - arcStartAngle) / π2 }
        get { return arcStartAngle + π2 * strokeEnd }
    }
    
    var arcWidth : CGFloat
        {
        set { lineWidth = newValue; updatePath() }
        get { return lineWidth }
    }
    
    var arcClockwise : Bool = true
    
    var arcColor : CGColor
        {
        set { strokeColor = newValue }
        get { return strokeColor ?? UIColor.clearColor().CGColor }
    }
    
    override var bounds : CGRect { didSet { updatePath() } }
    override var frame : CGRect { didSet { updatePath() } }
    
    // MARK: - Init
    
    override init()
    {
        super.init()
        setup()
    }
    
    override init(layer: AnyObject)
    {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup()
    {
        fillColor = UIColor.clearColor().CGColor
        updatePath()
    }
    
    func updatePath()
    {
        let diameter = floor(min(frame.width, frame.height) - arcWidth)
        
        let circle = UIBezierPath(ovalInRect: CGRect(center: bounds.center, size: CGSize(widthAndHeight: diameter)))
        
        path = circle.CGPath
    }
}

//    static let ValueKey = "value"
let ArcWidthKey = "arcWidth"
let ArcStartAngleKey = "arcStartAngle"
let ArcEndAngleKey = "arcEndAngle"
let ArcClockwiseKey = "arcClockwise"
let ArcColorKey = "arcColor"

internal class DrawnArcLayer: CALayer
{
    //NB No good for animations if the view is large, but may be extended with start and end cap
    
    @NSManaged
    var arcStartAngle : CGFloat
    
    @NSManaged
    var arcEndAngle : CGFloat
    
    @NSManaged
    var arcWidth : CGFloat
    
    @NSManaged
    var arcClockwise : Bool
    
    @NSManaged
    var arcColor : CGColor
    
    override class func needsDisplayForKey(key: String) -> Bool
    {
        switch key
        {
        case ArcWidthKey, ArcStartAngleKey, ArcEndAngleKey, ArcClockwiseKey, ArcColorKey:
            return true
            
        default:
            return super.needsDisplayForKey(key)
        }
    }
    
    override func actionForKey(key: String) -> CAAction?
    {
        switch key
        {
        case ArcWidthKey, ArcStartAngleKey, ArcEndAngleKey, ArcClockwiseKey, ArcColorKey:
            let animation = CABasicAnimation(keyPath: key)
            animation.fromValue = presentationLayer()?.valueForKey(key)
            animation.duration = 1
            return animation
            
        default:
            return super.actionForKey(key)
        }
    }
    
    override func drawInContext(ctx: CGContext)
    {
        //            super.drawInContext(ctx)
        
        UIGraphicsPushContext(ctx)
        
        let outerRadius = min(bounds.width, bounds.height) / 2
        let innerRadius = outerRadius - arcWidth
        
        //            let startAngle : CGFloat = 0
        //            let endAngle = π2 * CGFloat(value)
        
        let path = UIBezierPath(arcCenter: bounds.center, radius: innerRadius, startAngle: arcStartAngle, endAngle: arcEndAngle, clockwise: arcClockwise)
        path.addArcWithCenter(bounds.center, radius: outerRadius, startAngle: arcEndAngle, endAngle: arcStartAngle, clockwise: !arcClockwise)
        
        path.closePath()
        
        UIColor(CGColor: arcColor).setFill()
        
        path.fill()
        
        UIGraphicsPopContext()
    }
}

