//
//  CGFloat+Ext.swift
//  SybilCatcher
//
//  Created by simakonfeta on 28.04.2024.
//

import CoreGraphics

public let constantPi = CGFloat.pi

extension CGFloat {
    
    func radiansToDegrees() -> CGFloat {
        return self * 180.0 / constantPi
    }
    
    func degreesToRadians() -> CGFloat {
        return self * constantPi / 180.0
    }
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}
