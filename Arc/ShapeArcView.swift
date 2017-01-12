//
//  ShapeArcView.swift
//  Arc
//
//  Created by Christian Otkjær on 12/01/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit

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
