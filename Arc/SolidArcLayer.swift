//
//  SolidArcLayer.swift
//  Arc
//
//  Created by Christian Otkjær on 11/01/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit
import Graphics
import Arithmetic
import Animation

open class SolidArcLayer: CAShapeLayer
{
    open var arcCap: ArcCap
        {
        get { return ArcCap(lineCap: lineCap) }
        set { lineCap = newValue.lineEndCap }
    }
    
    /**
     The angle where the arc begins
     */
    open var arcAnchorAngle: CGFloat = -.pi/2
        {
        didSet { updatePath() }
    }
    
    private var _angle: CGFloat = 0
    
    /**
     The angle to the start of the arc.
     */
    open var arcAngle: CGFloat
    {
        get { return _angle }
        set { normalizeStroke(); updateStroke(newValue) }
    }
    
    /**
     The span of the arc. keeps in [0;2π]
     */
    open var arcSpan : CGFloat
        {
        get { return (strokeEnd - strokeStart) * π6 }
        set { strokeEnd = min(π2, max(0, newValue)) / π6 + strokeStart }
    }
    
    open var arcWidth : CGFloat
        {
        get { return lineWidth }
        set { lineWidth = newValue; updatePath() }
    }
    
    open var arcColor : CGColor?
        {
        get { return strokeColor }
        set { strokeColor = newValue }
    }
    
    // MARK: - Bounds
    
    override open var bounds : CGRect
        {
        didSet { updatePath(oldValue != bounds) }
    }
    
    // MARK: - Init
    
    override public init()
    {
        super.init()
        initialSetup()
    }
    
    override public init(layer: Any)
    {
        super.init(layer: layer)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    func initialSetup()
    {
        strokeStart = oneThird
        strokeEnd = twoThird
        
        fillColor = nil
        updatePath()
        normalizeStroke()
    }
    
    // MARK: - Current
    
    var currentStrokeSpan: (start: CGFloat, end: CGFloat)
    {
        let current = presentation() ?? self
        
        return (current.strokeStart, current.strokeEnd)
    }
    
    // MARK: - Normalize
    
    private func normalizeStroke()
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let current = currentStrokeSpan
        
        var start = currentStrokeSpan.start
        
        while start > twoThird { start -= oneThird }
        while start < oneThird { start += oneThird }
        
        strokeStart = start
        strokeEnd = start + (current.end - current.start)
        
        CATransaction.commit()
    }
    
    private func updateStroke(_ newAngle: CGFloat)
    {
        let current = currentStrokeSpan

        let span = current.end - current.start

        let delta = (newAngle - _angle) / π6
        
        strokeStart += delta
        strokeEnd = strokeStart + span
        _angle = newAngle
    }
    
    // MARK: - Path
    
    private func createPath(atCenter center: CGPoint? = nil, forSize size: CGSize? = nil, arcWidth: CGFloat? = nil) -> UIBezierPath?
    {
        let arcWidth = abs(arcWidth ?? self.arcWidth)
        let size = size ?? bounds.size
        let center = center ?? bounds.center
        
        let radius = floor((min(size.width, size.height) - arcWidth) / 2)
        
        guard radius > 0 else { return nil }
        
        let threeLoops = UIBezierPath(arcCenter: center, radius: radius, startAngle: arcAnchorAngle, endAngle: π6 + arcAnchorAngle, clockwise: true)
        
        return threeLoops
    }
    
    /**
     The path of the Arc (in the ArcLayers geometry)
 */
    public var arcPath: UIBezierPath?
    {
        let size = bounds.size
        
        let radius = floor((min(size.width, size.height) - arcWidth) / 2)
        
        guard radius > 0 else { return nil }
        
        let startAngle = arcAnchorAngle + arcAngle
        let endAngle = startAngle + arcSpan
        
        let arcPath = UIBezierPath(arcCenter: bounds.center,
                                   radius: radius,
                                   startAngle: startAngle,
                                   endAngle: endAngle,
                                   clockwise: true)
        
        arcPath.lineWidth = arcWidth
        arcPath.lineCapStyle = arcCap.lineCapStyle
        
        return arcPath
    }
    

    // MARK: Update

    private func updatePath(_ needed: Bool = true)
    {
        guard needed else { return }
        path = createPath()?.cgPath
    }
    
    // MARK: - Actions
    
    private func isUnderlyingArcKey(_ key: String) -> Bool
    {
        switch key
        {
        case #keyPath(CAShapeLayer.strokeStart),
             #keyPath(CAShapeLayer.strokeEnd),
             #keyPath(CAShapeLayer.lineWidth),
             #keyPath(CAShapeLayer.strokeColor),
//             #keyPath(CAShapeLayer.lineCap),
             #keyPath(CAShapeLayer.path):
            return true
            
        default:
            return false
        }
    }
    
    //    override open class func needsDisplay(forKey key: String) -> Bool
    //    {
    //        return isUnderlyingArcKey(key) || super.needsDisplay(forKey: key)
    //    }
    
    override open func action(forKey key: String) -> CAAction?
    {
        guard isUnderlyingArcKey(key) else { return super.action(forKey: key) }
        
        // Get a fully configured animation if we are animating in a UIView.animate closure
        guard let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation else { setNeedsDisplay(); return nil }
        
        animation.fromValue = presentation()?.value(forKey: key)
        animation.keyPath = key
        animation.toValue = nil
        
        return animation
    }
    
}

// MARK: - <#comment#>

extension UIBezierPath
{
    // MARK: - Hittesting
    
    var strokePath: UIBezierPath?
    {
        if let strokePath = CGPath(__byStroking: self.cgPath, transform: nil, lineWidth: lineWidth, lineCap: lineCapStyle, lineJoin: lineJoinStyle, miterLimit: miterLimit)
        {
            return UIBezierPath(cgPath: strokePath)
        }
        
         return nil
    }
}

