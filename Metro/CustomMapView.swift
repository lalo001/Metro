//
//  CustomMapView.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/29/17.
//  Copyright © 2017 Eduardo Valencia Paz. All rights reserved.
//

import UIKit
import MapKit

class CustomMapView: MKMapView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }*/
    
    let compassTop: CGFloat = 130
    let compassSize: CGFloat = 45
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let compassClass: AnyClass = NSClassFromString("MKCompassView") {
            if let compassView = self.subviews.filter({ $0.isKind(of: compassClass) }).first {
                compassView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
                compassView.frame = CGRect(x: self.frame.width - 5 - compassSize, y: self.frame.minY + compassTop, width: compassSize, height: compassSize)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            if let compassClass: AnyClass = NSClassFromString("MKCompassView") {
                if let compassView = object as? UIView {
                    if compassView.isKind(of: compassClass) && compassView.frame.minY != compassTop {
                        compassView.frame = CGRect(x: self.frame.width - 5 - compassSize, y: self.frame.minY + compassTop, width: compassSize, height: compassSize)
                    }
                }
            }
        }
    }
    
}
