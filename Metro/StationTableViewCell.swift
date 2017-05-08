//
//  StationTableViewCell.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/6/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
        
        if selected {
            self.alpha = 0.5
        } else {
             self.alpha = 1
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        if highlighted {
            self.alpha = 0.5
        } else {
            self.alpha = 1
        }
    }
    
    convenience init(station: Station?) {
        self.init(style: .default, reuseIdentifier: "reuseIdentifier")
        
        guard let station = station else {
            return
        }
        
        self.backgroundColor = .clear
        
        // Create nameLabel
        let nameLabel = UIObjects.createLabel(text: station.name?.capitalized(with: Locale(identifier: NSLocalizedString("locale", comment: ""))) ?? "", textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 20, weight: UIFontWeightMedium))
        nameLabel.numberOfLines = 0
        self.contentView.addSubview(nameLabel)
        
        // Add nameLabel Constraints
        let nameLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[nameLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["nameLabel" : nameLabel])
        let nameLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[nameLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["nameLabel" : nameLabel])
        self.contentView.addConstraints(nameLabelHorizontalConstraints)
        self.contentView.addConstraints(nameLabelVerticalConstraints)
        
        // Create linesContainer
        let linesContainer = UIObjects.createCircles(for: (station.lines?.array ?? []) as? [Line] ?? [], in: self.contentView, with: 10, to: nameLabel, with: 20, to: nil)
        
        // Add linesContainer Constraints
        let linesContainerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[linesContainer]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["linesContainer" : linesContainer])
        self.contentView.addConstraints(linesContainerVerticalConstraints)
    }
    
    convenience init(stationTuple: (Station, CGFloat)?) {
        self.init(style: .default, reuseIdentifier: "reuseIdentifier")
        
        guard let stationTuple = stationTuple else {
            return
        }
        let station = stationTuple.0
        let distance = stationTuple.1
        
        self.backgroundColor = .clear
        
        // Create nameLabel
        let distanceText = String(format: "%.2fkm", distance/1000)
        let nameLabelText = "\(station.name?.capitalized(with: Locale(identifier: NSLocalizedString("locale", comment: ""))) ?? "") (\(distanceText))"
        let nameLabel = UIObjects.createLabel(text: nameLabelText, textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 20, weight: UIFontWeightMedium))
        nameLabel.numberOfLines = 0
        self.contentView.addSubview(nameLabel)
        
        // Add nameLabel Constraints
        let nameLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[nameLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["nameLabel" : nameLabel])
        let nameLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[nameLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["nameLabel" : nameLabel])
        self.contentView.addConstraints(nameLabelHorizontalConstraints)
        self.contentView.addConstraints(nameLabelVerticalConstraints)
        
        // Create linesContainer
        let linesContainer = UIObjects.createCircles(for: (station.lines?.array ?? []) as? [Line] ?? [], in: self.contentView, with: 10, to: nameLabel, with: 20, to: nil)
        
        // Add linesContainer Constraints
        let linesContainerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[linesContainer]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["linesContainer" : linesContainer])
        self.contentView.addConstraints(linesContainerVerticalConstraints)
    }

}
