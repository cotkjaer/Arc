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

private let π = CGFloat.π
private let π2 = CGFloat.π2
private let π4 = π2 * 2
private let π6 = π2 + π4
private let oneThird : CGFloat = 1.0/3.0
private let twoThird : CGFloat = 2.0/3.0

open class ArcLayer: CAShapeLayer
{
    fileprivate func normalizeAngleTo6π(_ angle: CGFloat) -> CGFloat
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
    
    fileprivate func strokeForAngle(_ angle: CGFloat) -> CGFloat
    {
        return normalizeAngleTo6π(angle) / π6
    }
    
    open var arcStartAngle : CGFloat = 0
        {
        willSet
        {
            adjustStartAndEndStroke(deltaStartAngle: newValue - arcStartAngle)
        }
    }
    
    open var arcEndAngle : CGFloat = π
        {
        willSet
        {
            adjustStartAndEndStroke(deltaEndAngle: newValue - arcEndAngle)
        }
    }
    
    open var arcWidth : CGFloat
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
    
    override open var lineWidth : CGFloat { didSet { updatePath() } }
    
    open var arcClockwise : Bool = true
        {
        didSet { adjustStartAndEndStroke() }
    }
    
    open var arcColor : CGColor
        {
        set { strokeColor = newValue }
        get { return strokeColor ?? UIColor.clear.cgColor }
    }

    // MARK: - Bounds
    
    override open var bounds : CGRect { didSet { updatePath() } }
    
    // MARK: - Init
    
    override public init()
    {
        super.init()
        setup()
    }
    
    override public init(layer: Any)
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
        fillColor = UIColor.clear.cgColor
        updatePath()
    }
    
    // MARK: - Update
    
    // MARK: start- and end-stroke
    
    fileprivate func strokeToAngle(_ stroke: CGFloat) -> CGFloat
    {
        return (stroke * π4).normalized(φ: π)
    }
    
    fileprivate func findAngles() -> (CGFloat, CGFloat)
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
    
    fileprivate func adjustStartAndEndStroke(_ duration: Double = 0.1,
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
            animate(NSNumber(value: Float(realStrokeStart + delta / π6)), duration: duration, keyPath: "strokeStart")
        }
        
        if let delta = deltaEndAngle
        {
            animate(NSNumber(value: Float(realStrokeEnd + delta / π6)), duration: duration, keyPath: "strokeEnd")
        }
    }
    
    // MARK: Path
    
    fileprivate func updatePath(_ duration: Double = 0.1)
    {
        let radius = floor((min(bounds.width, bounds.height) - arcWidth) / 2)
        
        let threeLoops = UIBezierPath(arcCenter: bounds.center, radius: radius, startAngle: 0, endAngle: π2, clockwise: true)

        threeLoops.addArc(withCenter: bounds.center, radius: radius, startAngle: 0, endAngle: π2, clockwise: true)

        threeLoops.addArc(withCenter: bounds.center, radius: radius, startAngle: 0, endAngle: π2, clockwise: true)
        
        animate(threeLoops.cgPath, duration: duration, keyPath: "path")
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
        get { return strokeColor ?? UIColor.clear.cgColor }
    }
    
    override var bounds : CGRect { didSet { updatePath() } }
    override var frame : CGRect { didSet { updatePath() } }
    
    // MARK: - Init
    
    override init()
    {
        super.init()
        setup()
    }
    
    override init(layer: Any)
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
        fillColor = UIColor.clear.cgColor
        updatePath()
    }
    
    func updatePath()
    {
        let diameter = floor(min(frame.width, frame.height) - arcWidth)
        
        let circle = UIBezierPath(ovalIn: CGRect(origin: bounds.center, size: CGSize(diameter)))
        
        path = circle.cgPath
    }
}

//    static let ValueKey = "value"
let ArcWidthKey = "arcWidth"
let ArcStartAngleKey = "arcStartAngle"
let ArcEndAngleKey = "arcEndAngle"
let ArcClockwiseKey = "arcClockwise"
let ArcFillColorKey = "arcFillColor"
let ArcStrokeColorKey = "arcStrokeColor"
let ArcStrokeWidthKey = "arcStrokeWidth"

private func isCustomKey(_ key: String) -> Bool
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
//        fatalError("init(coder:) has not been implemented")
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
