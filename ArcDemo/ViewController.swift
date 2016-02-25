//
//  ViewController.swift
//  ArcDemo
//
//  Created by Christian Otkjær on 24/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Arc

class ViewController: UIViewController {

    @IBOutlet weak var arcView: ArcView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        arcView.width = 20
        arcView.color = view.tintColor
        arcView.startDegrees = 90
        arcView.endDegrees = 200
    }
    
    var end = true
    
    @IBAction func updateArc()
    {
        if end
        {
        arcView.endDegrees = arcView.endDegrees + 30
        }
        else
        {
        arcView.startDegrees = arcView.startDegrees + 30
        }
        end = !end
    }
}

