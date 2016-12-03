//
//  ArcView.swift
//  Silverback
//
//  Created by Christian Otkjær on 09/12/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit
import Graphics

@IBDesignable
open class ArcView: UIView
{
    @IBInspectable
    open var width : CGFloat
        {
        set { arcLayer.arcWidth = newValue }
        get { return arcLayer.arcWidth }
    }
    
    @IBInspectable
    open var startDegrees: CGFloat
        {
        set { startAngle = newValue.asRadians }
        get { return startAngle.asDegrees }
    }
    
    open var startAngle: CGFloat
        {
        set { if clockwise { arcLayer.arcStartAngle = newValue } else { arcLayer.arcEndAngle = newValue } }
        get { return clockwise ? arcLayer.arcStartAngle : arcLayer.arcEndAngle }
    }
    
    @IBInspectable
    open var endDegrees: CGFloat
        {
        set { endAngle = newValue.asRadians }
        get { return endAngle.asDegrees }
    }

    open var endAngle: CGFloat
    {
        set { if !clockwise { arcLayer.arcStartAngle = newValue } else { arcLayer.arcEndAngle = newValue } }
        get { return !clockwise ? arcLayer.arcStartAngle : arcLayer.arcEndAngle }
    }

    @IBInspectable
    open var clockwise: Bool = true
        {
        didSet
        {
            if clockwise != oldValue
            {
                swap(&arcLayer.arcStartAngle, &arcLayer.arcEndAngle)
            }
        }
    }
    
    @IBInspectable
    open var color: UIColor = UIColor.black
        {
        didSet { arcLayer.arcColor = color.cgColor }
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        
        updateArc()
    }
    
    open override func layoutSublayers(of layer: CALayer)
    {
        super.layoutSublayers(of: layer)
        
        if layer == self.layer
        {
            updateArc()
        }
    }
    
    // MARK: - Init
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup()
    {
        layer.addSublayer(arcLayer)
        arcLayer.arcColor = color.cgColor
        updateArc()
    }
    
    override open var bounds : CGRect { didSet { updateArc() } }
    override open var frame : CGRect { didSet { updateArc() } }
    
    // MARK: - Arc
    
    fileprivate let arcLayer = ArcLayer()

    func updateArc()
    {
        arcLayer.frame = bounds
    }
}

//// MARK: - UIColor
//
//extension CGColor
//{
//    var uiColor: UIColor { return UIColor(cgColor: self) }
//}
//

@IBDesignable
open class DrawnArcView: UIView
{    
    private var arcLayer : DrawnArcLayer? { return layer as? DrawnArcLayer }
    
//    func setupRasterize()
//    {
//        let scale = window?.screen.scale ?? UIScreen.main.scale
//        
//        arcLayer?.shouldRasterize = true
//        arcLayer?.rasterizationScale = scale
//        arcLayer?.contentsScale = scale
//    }
    
    @IBInspectable
    open var startAngle: CGFloat
        {
        set { arcLayer?.arcStartAngle = newValue }
        get { return arcLayer?.arcStartAngle ?? 0 }
    }
    
    @IBInspectable
    open var endAngle: CGFloat
        {
        set { arcLayer?.arcEndAngle = newValue }
        get { return arcLayer?.arcEndAngle ?? 0 }
    }

    @IBInspectable
    open var width: CGFloat
        {
        set { arcLayer?.arcWidth = newValue }
        get { return arcLayer?.arcWidth ?? 0 }
    }

    @IBInspectable
    open var clockwise: Bool
        {
        set { arcLayer?.arcClockwise = newValue }
        get { return arcLayer?.arcClockwise ?? true }
    }
    
    @IBInspectable
    open var fillColor: UIColor?
        {
        set { arcLayer?.arcFillColor = newValue?.cgColor }
        get { return arcLayer?.arcFillColor?.uiColor }
    }

    @IBInspectable
    open var strokeColor: UIColor?
        {
        set { arcLayer?.arcStrokeColor = newValue?.cgColor }
        get { return arcLayer?.arcStrokeColor?.uiColor }
    }
        
    @IBInspectable
    open var strokeWidth: CGFloat
        {
        set { arcLayer?.arcStrokeWidth = newValue }
        get { return arcLayer?.arcStrokeWidth ?? 0 }
    }

    override open class var layerClass : AnyClass
    {
        return DrawnArcLayer.self
    }
}

// MARK: - Shape

@IBDesignable
open class ShapeArcView: UIView
{
    private var arcLayer : ShapeArcLayer? { return layer as? ShapeArcLayer }
    
    @IBInspectable
    open var startAngle: CGFloat
        {
        set { arcLayer?.arcStartAngle = newValue }
        get { return arcLayer?.arcStartAngle ?? 0 }
    }
    
    @IBInspectable
    open var endAngle: CGFloat
        {
        set { arcLayer?.arcEndAngle = newValue }
        get { return arcLayer?.arcEndAngle ?? 0 }
    }
    
    @IBInspectable
    open var width: CGFloat
        {
        set { arcLayer?.arcWidth = newValue }
        get { return arcLayer?.arcWidth ?? 0 }
    }
    
    @IBInspectable
    open var clockwise: Bool
        {
        set { arcLayer?.arcClockwise = newValue }
        get { return arcLayer?.arcClockwise ?? true }
    }
    
    @IBInspectable
    open var fillColor: UIColor?
        {
        set { arcLayer?.fillColor = newValue?.cgColor }
        get { return arcLayer?.fillColor?.uiColor }
    }
    
    @IBInspectable
    open var strokeColor: UIColor?
        {
        set { arcLayer?.strokeColor = newValue?.cgColor }
        get { return arcLayer?.strokeColor?.uiColor }
    }
    
    @IBInspectable
    open var strokeWidth: CGFloat
        {
        set { arcLayer?.lineWidth = newValue }
        get { return arcLayer?.lineWidth ?? 0 }
    }
    
    override open class var layerClass : AnyClass
    {
        return ShapeArcLayer.self
    }
}


// MARK: - CustomDebugStringConvertible

extension ArcView 
{
    override open var debugDescription : String { return super.debugDescription + "<startDegrees = \(startDegrees), endDegrees = \(endDegrees), clockwise = \(clockwise), width = \(width)>" }
}
