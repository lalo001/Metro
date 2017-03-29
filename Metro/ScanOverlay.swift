//
//  ScanOverlay.swift
//  QR Scanner
//
//  Created by Eduardo Valencia on 2/13/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class ScanOverlay: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentMode = .redraw
        
        // Drawing code
        let radius: CGFloat = 28
        let context = UIGraphicsGetCurrentContext()
        let bezierPath = UIBezierPath(rect: rect)
        let rectangleRect = CGRect(x: self.center.x - 90, y: self.center.y - 90, width: 180, height: 180)
        let roundedRectanglePath: CGMutablePath = drawRoundedRectangle(rect: rectangleRect, radius: radius)
        bezierPath.append(UIBezierPath(cgPath: roundedRectanglePath))
        let layer = CAShapeLayer()
        layer.fillRule = kCAFillRuleEvenOdd
        layer.path = bezierPath.cgPath
        layer.fillColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1).cgColor
        context?.saveGState()
        self.layer.mask = layer
        self.alpha = 0.9
    }
    
    func drawRoundedRectangle(rect: CGRect, radius: CGFloat) -> CGMutablePath {
        let retPath = CGMutablePath()
        let innerRect = rect.insetBy(dx: radius, dy: radius)
        let insideRight = innerRect.origin.x + innerRect.size.width
        let outsideRight = rect.origin.x + rect.size.width
        let insideBottom = innerRect.origin.y + innerRect.size.height
        let outsideBottom = rect.origin.y + rect.size.height
        let insideTop = innerRect.origin.y
        let outsideTop = rect.origin.y
        let outsideLeft = rect.origin.x
        
        retPath.move(to: CGPoint(x: innerRect.origin.x, y: outsideTop))
        retPath.addLine(to: CGPoint(x: insideRight, y: outsideTop))
        retPath.addArc(tangent1End: CGPoint(x: outsideRight, y: outsideTop), tangent2End: CGPoint(x: outsideRight, y: insideTop), radius: radius)
        retPath.addLine(to: CGPoint(x: outsideRight, y: insideBottom))
        retPath.addArc(tangent1End: CGPoint(x: outsideRight, y: outsideBottom), tangent2End: CGPoint(x: insideRight, y: outsideBottom), radius: radius)
        retPath.addLine(to: CGPoint(x: innerRect.origin.x, y: outsideBottom))
        retPath.addArc(tangent1End: CGPoint(x: outsideLeft, y: outsideBottom), tangent2End: CGPoint(x: outsideLeft, y: insideBottom), radius: radius)
        retPath.addLine(to: CGPoint(x: outsideLeft, y: insideTop))
        retPath.addArc(tangent1End: CGPoint(x: outsideLeft, y: outsideTop), tangent2End: CGPoint(x: innerRect.origin.x, y: outsideTop), radius: radius)
        
        retPath.closeSubpath()
        return retPath
    }

}
