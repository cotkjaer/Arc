//
//  ViewController.swift
//  ArcDemo
//
//  Created by Christian Otkjær on 24/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Arc
import Arithmetic

class ViewController: UIViewController {

    @IBOutlet weak var arcView: SolidArcView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        arcView?.arcWidth = 20
        arcView?.arcColor = view.tintColor
        arcView?.arcAngle = 0
        arcView?.arcSpan = .pi
    }
    
    var end = true
    
    @IBAction func updateArc()
    {
        if end
        {
        arcView?.arcSpan += .pi/4
        }
        else
        {
        arcView?.arcAngle += .pi/4
            arcView?.arcSpan -= .pi/4
        }
        end = !end
    }
}

