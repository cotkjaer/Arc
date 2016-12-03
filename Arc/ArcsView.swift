//
//  ArcsView.swift
//  Arc
//
//  Created by Christian Otkjær on 22/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

open class ArcsView: UIView
{
    open var values = Array<CGFloat>()
        {
        didSet { updateNormalizedValues() }
    }
    
    private var normalizedValues = Array<CGFloat>()
            
    private let containerLayer = CALayer()

    // MARK: - Init
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    public convenience init<S>(sliceValues: S) where S : Sequence, S.Iterator.Element == CGFloat
    {
        self.init(frame: .zero)

        values = sliceValues.map({$0})
    }
    
    override open func awakeFromNib()
    {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup()
    {
        layer.addSublayer(containerLayer)
        updateNormalizedValues()
    }
    
    // MARK: - Update
    
    private func updateNormalizedValues()
    {
        let total = values.sum()
        
        guard total > 0 else { return }
        
        normalizedValues = values.map({ $0 / total })
    }
    
    func createArcLayer() -> DrawnArcLayer
    {
        let arc =  DrawnArcLayer()
        
        arc.arcStrokeColor = UIColor.orange.cgColor
        arc.arcStrokeWidth = 0.5
        
        return arc
    }
    
    var arcLayers : [DrawnArcLayer] { return containerLayer.sublayers?.flatMap{ $0 as? DrawnArcLayer } ?? [] }
    
    public func updateArcs()
    {
        containerLayer.frame = bounds
        
        let layersCount = arcLayers.endIndex
        let valuesCount = normalizedValues.endIndex
        
        if layersCount > valuesCount
        {
            arcLayers[valuesCount..<layersCount].forEach{ $0.removeFromSuperlayer() }
        }
        if layersCount < valuesCount
        {
            (layersCount..<valuesCount).forEach({ _ in containerLayer.addSublayer(createArcLayer())})
        }
        
        let layers = self.arcLayers
        let π2 = 2 * CGFloat.pi
        var startAngle : CGFloat = 0
        
        for (i, v) in normalizedValues.enumerated()
        {
            let arc = layers[i]
            arc.frame = bounds
            
            let angle = v * π2
            
            arc.arcClockwise = true
            arc.arcFillColor = UIColor(hue:startAngle / π2, saturation:0.75, brightness:0.75, alpha:1).cgColor
            arc.arcStartAngle = startAngle
            arc.arcEndAngle = startAngle + angle
            arc.arcWidth = min(bounds.width, bounds.height) / 7
            startAngle += angle
        }
    }
}
