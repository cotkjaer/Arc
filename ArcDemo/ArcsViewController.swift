//
//  ArcsViewController.swift
//  Arc
//
//  Created by Christian Otkjær on 22/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Arc
import Arithmetic

class ArcsViewController: UIViewController
{
    var arcViews : [DrawnArcView] { return view.subviews.flatMap({ $0 as? DrawnArcView }) }
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func step(_ sender: UIStepper)
    {
        let count = Int(sender.value)
        let bounds = view.bounds
        
        while arcViews.count < count
        {
            let arc = DrawnArcView(frame: bounds)
            arc.backgroundColor = .clear
            arc.tag = Int(arc4random_uniform(5) + 1)
            arc.startAngle = 0
            arc.endAngle = 0     
            view.insertSubview(arc, belowSubview: stepper)
        }
        
        while arcViews.count > count
        {
            arcViews.last?.removeFromSuperview()
        }
        
        
        let arcs = arcViews.reversed()
        let total = CGFloat(arcs.map({$0.tag}).sum())
        
        let π2 = 2 * CGFloat.pi
        var startAngle : CGFloat = 0
        
        UIView.animate(withDuration: 3, animations: {
            
            for (i, arc) in arcs.enumerated()
            {
                arc.frame = bounds
                
                let v = CGFloat(arc.tag) / total
                let angle = v * π2
                    
                    arc.clockwise = true
                    arc.fillColor = UIColor(hue:CGFloat(arcs.count - i) / arcs.count, saturation:0.75, brightness:0.75, alpha:1)
                    arc.startAngle = startAngle
                    arc.endAngle = startAngle + angle
                    arc.width = min(bounds.width, bounds.height) / 7
                    startAngle += angle
                }
        })

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
