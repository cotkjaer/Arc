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
        let factor = CGFloat(arc4random_uniform(1000000)) / 1000000
        
        return lower * factor + upper * (1 - factor)
//        
//        return abs(CGFloat(arc4random()).remainder(dividingBy: upper))
    }
}

let π2 = CGFloat.pi * 2

class DrawnViewController: UIViewController
{
    @IBOutlet weak var arcView: ShapeArcView?
    
    @IBAction func handleButton()
    {
        guard let arcView = arcView else { return }
        
        let startAngle = CGFloat.random(upper: π2)
        let endAngle = startAngle + CGFloat.random(upper: π2 - startAngle)
        
        let color = UIColor(hue: (endAngle - startAngle)/π2, saturation: 0.8, brightness: 0.8, alpha: 0.8)

        let width = CGFloat.random(lower: arcView.bounds.width / 4, upper: arcView.bounds.width / 2)
        
        let strokeColor = UIColor(hue: CGFloat.random(upper: 1), saturation: 0.8, brightness: 0.8, alpha: 1)
        let strokeWidth = CGFloat.random(upper: width / 10) + 1
        
        print("a: \(startAngle), b: \(endAngle)")
        
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
