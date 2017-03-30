//
//  LocationButton.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/29/17.
//  Copyright © 2017 Eduardo Valencia Paz. All rights reserved.
//

import UIKit
import MapKit

class LocationButton: UIButton {
    
    var locationState: MKUserTrackingMode = .none {
        didSet {
            switch locationState {
            case .none:
                self.setImage(UIImage(named: "Location Icon No Fill"), for: .normal)
                self.setImage(UIImage(named: "Location Icon No Fill"), for: .highlighted)
            case .follow:
                self.setImage(UIImage(named: "Location Icon"), for: .normal)
                self.setImage(UIImage(named: "Location Icon"), for: .highlighted)
            case .followWithHeading:
                self.setImage(UIImage(named: "Location Icon with Heading"), for: .normal)
                self.setImage(UIImage(named: "Location Icon with Heading"), for: .highlighted)
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
