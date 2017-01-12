//
//  DrawnArcView.swift
//  Arc
//
//  Created by Christian Otkjær on 12/01/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit

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
