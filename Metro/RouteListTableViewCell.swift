//
//  RouteListTableViewCell.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/8/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class RouteListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    convenience init(station: Station?, isLast: Bool) {
        self.init(style: .default, reuseIdentifier: "reuseIdentifier")

        self.backgroundColor = .clear
        
        // Create nameLabel
        let nameLabelText = station?.name?.capitalized(with: Locale(identifier: NSLocalizedString("locale", comment: ""))) ?? ""
        let nameLabel = UIObjects.createLabel(text: nameLabelText, textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 17, weight: UIFontWeightRegular))
        nameLabel.numberOfLines = 0
        self.contentView.addSubview(nameLabel)
        
        // Add nameLabel Constraints
        let nameLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[nameLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["nameLabel" : nameLabel])
        let nameLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[nameLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["nameLabel" : nameLabel])
        self.contentView.addConstraints(nameLabelHorizontalConstraints)
        self.contentView.addConstraints(nameLabelVerticalConstraints)
        
        // Create linesContainer
        let linesContainer = UIObjects.createCircles(for: (station?.lines?.array ?? []) as? [Line] ?? [], in: self.contentView, with: 10, to: nameLabel, with: 50, to: nil)
        
        // Create bigCircle
        let bigCircle = UIObjects.createCircle(with: 20, in: self.contentView, color: Tools.colorPicker(3, alpha: 1))
        
        if isLast, let bigCircle = bigCircle {
            
            // Add linesContainer Constraints
            let linesContainerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[linesContainer]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["linesContainer" : linesContainer])
            self.contentView.addConstraints(linesContainerVerticalConstraints)
            
            // Add bigCircle Constraints
            let bigCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[bigCircle]", options: NSLayoutFormatOptions(), metrics: nil, views: ["bigCircle" : bigCircle])
            let bigCircleCenterY = NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: bigCircle, attribute: .centerY, multiplier: 1, constant: 0)
            self.contentView.addConstraints(bigCircleHorizontalConstraints)
            self.contentView.addConstraint(bigCircleCenterY)
            
        } else {
            
            // Add linesContainer Constraints
            let linesContainerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[linesContainer]", options: NSLayoutFormatOptions(), metrics: nil, views: ["linesContainer" : linesContainer])
            self.contentView.addConstraints(linesContainerVerticalConstraints)
            
            // Create middleCircle
            let middleCircle = UIObjects.createCircle(with: 10, in: self.contentView, color: Tools.colorPicker(1, alpha: 1))
            
            // Create lowerCircle
            let lowerCircle = UIObjects.createCircle(with: 10, in: self.contentView, color: Tools.colorPicker(1, alpha: 1))
            
            if let bigCircle = bigCircle, let middleCircle = middleCircle, let lowerCircle = lowerCircle {
                
                // Add bigCircle Constraints
                let bigCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[bigCircle]", options: NSLayoutFormatOptions(), metrics: nil, views: ["bigCircle" : bigCircle])
                let bigCircleCenterY = NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: bigCircle, attribute: .centerY, multiplier: 1, constant: 0)
                self.contentView.addConstraints(bigCircleHorizontalConstraints)
                self.contentView.addConstraint(bigCircleCenterY)
                
                // Add middleCircle Constraints
                let middleCircleVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[bigCircle]-15-[middleCircle]", options: .alignAllCenterX, metrics: nil, views: ["bigCircle" : bigCircle, "middleCircle" : middleCircle])
                self.contentView.addConstraints(middleCircleVerticalConstraints)
                
                // Add lowerCircle Constraints
                let lowerCircleVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[middleCircle]-15-[lowerCircle]|", options: .alignAllCenterX, metrics: nil, views: ["middleCircle" : middleCircle, "lowerCircle" : lowerCircle])
                self.contentView.addConstraints(lowerCircleVerticalConstraints)
            }
        }
    }

}
