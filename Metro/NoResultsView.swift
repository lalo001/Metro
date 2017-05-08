//
//  NoResultsView.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/7/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class NoResultsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    convenience init(text: String) {
        self.init()
        self.backgroundColor = .clear
        
        // Create noResultsLabel
        let noResultsLabel = UIObjects.createLabel(text: NSLocalizedString(text, comment: ""), textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 17, weight: UIFontWeightMedium))
        self.addSubview(noResultsLabel)
        
        // Add noResultsLabel Constraints
        let noResultsLabelCenterX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: noResultsLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let noResultsLabelCenterY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: noResultsLabel, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(noResultsLabelCenterX)
        self.addConstraint(noResultsLabelCenterY)
    }
}
