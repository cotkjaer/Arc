//
//  DrawnViewController.swift
//  Arc
//
//  Created by Christian Otkjær on 22/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Arc

// MARK: - Random

extension CGFloat
{
    static func random(lower: CGFloat = 0, upper: CGFloat) -> CGFloat
    {
//        let factor = CGFloat(arc4random_uniform(10000000)) / 10000000
        let factor = CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max)
        
        return lower * factor + upper * (1 - factor)
    }
}

let π2: CGFloat = .pi + .pi

class DrawnViewController: UIViewController
{
    @IBOutlet weak var arcView: ShapeArcView?
    
    @IBAction func handleButton()
    {
        guard let arcView = arcView else { return }
        
        let startAngle = CGFloat.random(upper: π2)
        let endAngle = startAngle + CGFloat.random(upper: π2 - startAngle)
        
        let color = UIColor(hue: (endAngle - startAngle) / π2, saturation: 0.8, brightness: 0.8, alpha: 0.8)

        let width = CGFloat.random(lower: arcView.bounds.width / 4, upper: arcView.bounds.width / 2)
        
        let strokeColor = UIColor(hue: CGFloat.random(upper: 1), saturation: 0.8, brightness: 0.8, alpha: 1)
        let strokeWidth = CGFloat.random(upper: width / 10) + 1
        
        debugPrint("a: \(startAngle), b: \(endAngle)")
        
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: -1,
            options: [.beginFromCurrentState, .allowUserInteraction], animations:
            {
                arcView.clockwise = true
                arcView.startAngle = startAngle
                arcView.endAngle = endAngle
                
                arcView.fillColor = color
                arcView.width = width
                arcView.strokeWidth = strokeWidth
                arcView.strokeColor = strokeColor
        }
            , completion: nil)
        
    }
}
