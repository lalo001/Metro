//
//  ScanBorder.swift
//  QR Scanner
//
//  Created by Eduardo Valencia on 2/13/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class ScanBorder: UIView {
    
    var borderLayer: CAShapeLayer?
    var scanState: ScannerState?
    var isFull: Bool = false
    var borderColor: CGColor {
        guard let scanState = scanState else {
            return UIColor.init(white: 1, alpha: 0.8).cgColor
        }
        switch scanState {
        case .none:
            return UIColor.init(white: 1, alpha: 0.8).cgColor
        case .success:
            return Tools.colorPicker(21, alpha: 1).cgColor
        case .error:
            return Tools.colorPicker(20, alpha: 1).cgColor
        }
    }
    
    convenience init(scanState: ScannerState, isFull: Bool) {
        self.init(frame: CGRect.zero)
        self.scanState = scanState
        self.isFull = isFull
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        borderLayer?.removeFromSuperlayer()
        self.contentMode = .redraw
        UIGraphicsBeginImageContext(rect.size)
        let radius: CGFloat = 28
        let rectangleRect = CGRect(x: 0, y: 0, width: 180, height: 180)
        borderLayer = CAShapeLayer()
        borderLayer?.position = self.center
        borderLayer?.bounds = rectangleRect
        borderLayer?.fillColor = borderColor
        borderLayer?.path = isFull ? drawScannerSquare(rect: rectangleRect, radius: radius, borderWidth: 5.5, sideLength: 60): drawScannerBorder(rect: rectangleRect, radius: radius, borderWidth: 5.5, sideLength: 60)
        UIGraphicsEndImageContext()
        guard borderLayer != nil else {
            return
        }
        self.layer.addSublayer(borderLayer!)
    }
    
    func drawScannerBorder(rect: CGRect, radius: CGFloat, borderWidth: CGFloat, sideLength: CGFloat) -> CGMutablePath {
        
        let innerArcRadius = radius - (borderWidth/2) * 2
        
        let path = CGMutablePath()
        let innerRect = rect.insetBy(dx: radius, dy: radius)
        let insideRight = innerRect.origin.x + innerRect.size.width
        let outsideRight = rect.origin.x + rect.size.width
        let insideBottom = innerRect.origin.y + innerRect.size.height
        let outsideBottom = rect.origin.y + rect.size.height
        let insideTop = innerRect.origin.y
        let outsideTop = rect.origin.y
        let outsideLeft = rect.origin.x
        let insideLeft = innerRect.origin.x
        
        let rightFirstXCoordinate = outsideRight - sideLength
        let rightTopLowestYCoordinate = outsideTop + sideLength
        let rightTopLowestXCoordinate = outsideRight - borderWidth
        let rightTopLowestArcYCoordinate = insideTop + borderWidth
        let rightTopLowestArcXCoordinate = insideRight - borderWidth
        let rightTopHighestArcYCoordinate = outsideTop + borderWidth
        
        let bottomHighestYCoordinate = outsideBottom - sideLength
        
        let rightBottomLowestArcYCoordinate = outsideBottom - borderWidth
        let rightBottomLowestArcXCoordinate = insideRight - borderWidth
        
        let leftFirstXCoordinate = outsideLeft + sideLength
        let leftBottomLowestXCoordinate = outsideLeft + borderWidth
        let leftBottomHighestArcYCoordinate = insideBottom - borderWidth
        let leftBottomLowestArcYCoordinate = outsideBottom - borderWidth
        let leftBottomLowestArcXCoordinate = insideLeft + borderWidth
        
        path.move(to: CGPoint(x: rightFirstXCoordinate, y: outsideTop))
        path.addLine(to: CGPoint(x: insideRight, y: outsideTop))
        path.addArc(tangent1End: CGPoint(x: outsideRight, y: outsideTop), tangent2End: CGPoint(x: outsideRight, y: insideTop), radius: radius)
        path.addLine(to: CGPoint(x: outsideRight, y: rightTopLowestYCoordinate))
        path.addLine(to: CGPoint(x: rightTopLowestXCoordinate, y: rightTopLowestYCoordinate))
        path.addLine(to: CGPoint(x: rightTopLowestXCoordinate, y: rightTopLowestArcYCoordinate))
        path.addArc(tangent1End: CGPoint(x: rightTopLowestXCoordinate, y: rightTopHighestArcYCoordinate), tangent2End: CGPoint(x: rightTopLowestArcXCoordinate, y: rightTopHighestArcYCoordinate), radius: innerArcRadius)
        path.addLine(to: CGPoint(x: rightFirstXCoordinate, y: rightTopHighestArcYCoordinate))
        path.closeSubpath()
        
        path.move(to: CGPoint(x: outsideRight, y: bottomHighestYCoordinate))
        path.addLine(to: CGPoint(x: outsideRight, y: insideBottom))
        path.addArc(tangent1End: CGPoint(x: outsideRight, y: outsideBottom), tangent2End: CGPoint(x: insideRight, y: outsideBottom), radius: radius)
        path.addLine(to: CGPoint(x: rightFirstXCoordinate, y: outsideBottom))
        path.addLine(to: CGPoint(x: rightFirstXCoordinate, y: rightBottomLowestArcYCoordinate))
        path.addLine(to: CGPoint(x: rightBottomLowestArcXCoordinate, y: rightBottomLowestArcYCoordinate))
        path.addArc(tangent1End: CGPoint(x: rightTopLowestXCoordinate, y: rightBottomLowestArcYCoordinate), tangent2End: CGPoint(x: rightTopLowestXCoordinate, y: bottomHighestYCoordinate), radius: innerArcRadius)
        path.addLine(to: CGPoint(x: rightTopLowestXCoordinate, y: bottomHighestYCoordinate))
        path.closeSubpath()
        
        path.move(to: CGPoint(x: leftFirstXCoordinate, y: outsideBottom))
        path.addLine(to: CGPoint(x: insideLeft, y: outsideBottom))
        path.addArc(tangent1End: CGPoint(x: outsideLeft, y: outsideBottom), tangent2End: CGPoint(x: outsideLeft, y: bottomHighestYCoordinate), radius: radius)
        path.addLine(to: CGPoint(x: outsideLeft, y: bottomHighestYCoordinate))
        path.addLine(to: CGPoint(x: leftBottomLowestXCoordinate, y: bottomHighestYCoordinate))
        path.addLine(to: CGPoint(x: leftBottomLowestXCoordinate, y: leftBottomHighestArcYCoordinate))
        path.addArc(tangent1End: CGPoint(x: leftBottomLowestXCoordinate, y: leftBottomLowestArcYCoordinate), tangent2End: CGPoint(x: leftBottomLowestArcXCoordinate, y: leftBottomLowestArcYCoordinate), radius: innerArcRadius)
        path.addLine(to: CGPoint(x: leftFirstXCoordinate, y: leftBottomLowestArcYCoordinate))
        path.closeSubpath()
        
        path.move(to: CGPoint(x: outsideLeft, y: rightTopLowestYCoordinate))
        path.addLine(to: CGPoint(x: outsideLeft, y: insideTop))
        path.addArc(tangent1End: CGPoint(x: outsideLeft, y: outsideTop), tangent2End: CGPoint(x: insideLeft, y: outsideTop), radius: radius)
        path.addLine(to: CGPoint(x: leftFirstXCoordinate, y: outsideTop))
        path.addLine(to: CGPoint(x: leftFirstXCoordinate, y: rightTopHighestArcYCoordinate))
        path.addLine(to: CGPoint(x: leftBottomLowestArcXCoordinate, y: rightTopHighestArcYCoordinate))
        path.addArc(tangent1End: CGPoint(x: leftBottomLowestXCoordinate, y: rightTopHighestArcYCoordinate), tangent2End: CGPoint(x: leftBottomLowestXCoordinate, y:rightTopLowestArcYCoordinate), radius: innerArcRadius)
        path.addLine(to: CGPoint(x: leftBottomLowestXCoordinate, y: rightTopLowestYCoordinate))
        path.closeSubpath()
        return path
    }
    
    func drawScannerSquare(rect: CGRect, radius: CGFloat, borderWidth: CGFloat, sideLength: CGFloat) -> CGMutablePath {
        
        let innerArcRadius = radius - (borderWidth/2) * 2
        
        let path = CGMutablePath()
        let innerRect = rect.insetBy(dx: radius, dy: radius)
        let insideRight = innerRect.origin.x + innerRect.size.width
        let outsideRight = rect.origin.x + rect.size.width
        let insideBottom = innerRect.origin.y + innerRect.size.height
        let outsideBottom = rect.origin.y + rect.size.height
        let insideTop = innerRect.origin.y
        let outsideTop = rect.origin.y
        let outsideLeft = rect.origin.x
        let insideLeft = innerRect.origin.x
        
        let rightFirstXCoordinate = outsideRight - sideLength
        let rightTopLowestXCoordinate = outsideRight - borderWidth
        let rightTopLowestArcYCoordinate = insideTop + borderWidth
        let rightTopLowestArcXCoordinate = insideRight - borderWidth
        let rightTopHighestArcYCoordinate = outsideTop + borderWidth
        
        let leftBottomLowestXCoordinate = outsideLeft + borderWidth
        let leftBottomHighestArcYCoordinate = insideBottom - borderWidth
        let leftBottomLowestArcYCoordinate = outsideBottom - borderWidth
        let leftBottomLowestArcXCoordinate = insideLeft + borderWidth
        
        path.move(to: CGPoint(x: rightFirstXCoordinate, y: outsideTop))
        path.addLine(to: CGPoint(x: insideLeft, y: outsideTop))
        path.addArc(tangent1End: CGPoint(x: outsideLeft, y: outsideTop), tangent2End: CGPoint(x: outsideLeft, y: insideTop), radius: radius)
        path.addLine(to: CGPoint(x: outsideLeft, y: insideBottom))
        path.addArc(tangent1End: CGPoint(x: outsideLeft, y: outsideBottom), tangent2End: CGPoint(x: insideLeft, y: outsideBottom), radius: radius)
        path.addLine(to: CGPoint(x: insideRight, y: outsideBottom))
        path.addArc(tangent1End: CGPoint(x: outsideRight, y: outsideBottom), tangent2End: CGPoint(x: outsideRight, y: insideBottom), radius: radius)
        path.addLine(to: CGPoint(x: outsideRight, y: insideTop))
        path.addArc(tangent1End: CGPoint(x: outsideRight, y: outsideTop), tangent2End: CGPoint(x: insideRight, y: outsideTop), radius: radius)
        path.addLine(to: CGPoint(x: rightFirstXCoordinate, y: outsideTop))
        
        path.move(to: CGPoint(x: rightFirstXCoordinate, y: rightTopHighestArcYCoordinate))
        path.addLine(to: CGPoint(x: rightTopLowestArcXCoordinate, y: rightTopHighestArcYCoordinate))
        path.addArc(tangent1End: CGPoint(x: rightTopLowestXCoordinate, y: rightTopHighestArcYCoordinate), tangent2End: CGPoint(x: rightTopLowestXCoordinate, y: rightTopLowestArcYCoordinate), radius: innerArcRadius)
        path.addLine(to: CGPoint(x: rightTopLowestXCoordinate, y: leftBottomHighestArcYCoordinate))
        path.addArc(tangent1End: CGPoint(x: rightTopLowestXCoordinate, y: leftBottomLowestArcYCoordinate), tangent2End: CGPoint(x: rightTopLowestArcXCoordinate, y: leftBottomLowestArcYCoordinate), radius: innerArcRadius)
        path.addLine(to: CGPoint(x: leftBottomLowestArcXCoordinate, y: leftBottomLowestArcYCoordinate))
        path.addArc(tangent1End: CGPoint(x: leftBottomLowestXCoordinate, y: leftBottomLowestArcYCoordinate), tangent2End: CGPoint(x: leftBottomLowestXCoordinate, y: leftBottomHighestArcYCoordinate), radius: innerArcRadius)
        path.addLine(to: CGPoint(x: leftBottomLowestXCoordinate, y: rightTopLowestArcYCoordinate))
        path.addArc(tangent1End: CGPoint(x: leftBottomLowestXCoordinate, y:rightTopHighestArcYCoordinate), tangent2End: CGPoint(x: leftBottomLowestArcXCoordinate, y: rightTopHighestArcYCoordinate), radius: innerArcRadius)
        path.addLine(to: CGPoint(x: rightFirstXCoordinate, y: rightTopHighestArcYCoordinate))
        path.closeSubpath()
        
        return path
        
    }

}
