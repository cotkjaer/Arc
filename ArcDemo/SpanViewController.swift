//
//  SpanViewController.swift
//  Arc
//
//  Created by Christian Otkjær on 12/01/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit
import Arc

class SpanViewController: UIViewController {

    @IBOutlet weak var arcView: SolidArcView? { didSet { arcView?.arcCap = .round } }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    
    }
    
    @IBAction func handleButton()
    {
        guard let arcView = arcView else { return }
        
        let deltaMax = CGFloat.pi / 3
        let startAngle = CGFloat.random(upper: deltaMax)
        let endAngle = CGFloat.random(upper: deltaMax)
        
        let color = UIColor(hue: (endAngle - startAngle)/π2, saturation: 0.8, brightness: 0.8, alpha: 0.8)
        
        let width = CGFloat.random(lower: arcView.bounds.width / 6, upper: arcView.bounds.width / 4)
        
        debugPrint("a: \(startAngle), b: \(endAngle)")
        
        //        arcCapIndex = abs(arcCapIndex + 1) % ArcCap.all.count
        
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: -1,
            options: [.beginFromCurrentState, .allowUserInteraction], animations:
            {
                //                arcView.cap = ArcCap.all[self.arcCapIndex]
                arcView.arcAngle += startAngle
                arcView.arcSpan = CGFloat.random(upper: deltaMax)
                
                arcView.arcColor = color
                arcView.arcWidth = width
        },
            completion: { (completed) in
                
                let strokePath = arcView.arcPath
                
                
                
                debugPrint(strokePath?.debugDescription ?? "")
                //                if completed
                //                {
                //                    print("arcview start: \(arcView.startAngle), end: \(arcView.endAngle)")
                //
                //                    let π3: CGFloat = .pi + .pi + .pi
                //                    let startNormalized = arcView.startAngle.normalized(φ: π3)
                //                    let endNormalized = arcView.endAngle.normalized(φ: π3)
                //                    let span = abs(startNormalized - endNormalized)
                //                    let centerAngle = (startNormalized + endNormalized) / 2
                //
                //                    arcView.startAngle = centerAngle - span/2
                //                    arcView.endAngle = centerAngle + span/2
                //                    
                //                    print("arcview start: \(arcView.startAngle), end: \(arcView.endAngle)")
                //                }
                
        })
        
    }

}
