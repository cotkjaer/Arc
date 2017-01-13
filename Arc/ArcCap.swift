//
//  ArcCap.swift
//  Arc
//
//  Created by Christian Otkjær on 12/01/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import Foundation

/**
 Enum for defining the ends of an arc
 - note: translates directly to lineCapStyle in CAShapeLayer
 */
public enum ArcCap
{
    case butt, round, square
    
    init(lineCap: String?)
    {
        if lineCap == kCALineCapButt { self = .butt }
        else if lineCap == kCALineCapRound { self = .round }
        else if lineCap == kCALineCapSquare { self = .square }
        else { self = .butt }
    }
    
    init(lineCapStyle: CGLineCap?)
    {
        if lineCapStyle == .butt { self = .butt }
        else if lineCapStyle == .round { self = .round }
        else if lineCapStyle == .square { self = .square }
        else { self = .butt }
    }
    
    public var lineCapStyle: CGLineCap
    {
        switch self
        {
        case .butt:
            return .butt
            
        case .round:
            return .round
            
        case .square:
            return .square
        }
    }
    
    internal var lineEndCap: String
    {
        switch self
        {
        case .butt:
            return kCALineCapButt
            
        case .round:
            return kCALineCapRound
            
        case .square:
            return kCALineCapSquare
        }
    }
    
    public static var all: [ArcCap] { return [.butt, .round, .square] }
}
