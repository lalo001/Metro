//
//  EventCellTableViewCell.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/29/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class EventCellTableViewCell: UITableViewCell {

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
    
    convenience init(event: MetroEvent?) {
        self.init(style: .default, reuseIdentifier: "reuseIdentifier")
        
        self.backgroundColor = .clear
        
        // Create stationNameLabel
        let stationNameLabel = UIObjects.createLabel(text: event?.station?.name?.capitalized ?? "", textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 20, weight: UIFontWeightSemibold))
        self.contentView.addSubview(stationNameLabel)
        
        // Add stationNameLabel Constraints
        let stationNameLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-55-[stationNameLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["stationNameLabel" : stationNameLabel])
        let stationNameLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[stationNameLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["stationNameLabel" : stationNameLabel])
        self.contentView.addConstraints(stationNameLabelHorizontalConstraints)
        self.contentView.addConstraints(stationNameLabelVerticalConstraints)
        
        // Create titleLabel
        let titleLabel = UIObjects.createLabel(text: event?.name ?? "", textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 25, weight: UIFontWeightHeavy))
        self.contentView.addSubview(titleLabel)
        
        // Add titleLabel Constraints
        let titleLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[titleLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["titleLabel" : titleLabel])
        let titleLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[stationNameLabel]-3-[titleLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["stationNameLabel" : stationNameLabel, "titleLabel" : titleLabel])
        self.contentView.addConstraints(titleLabelHorizontalConstraints)
        self.contentView.addConstraints(titleLabelVerticalConstraints)
        
        // Create descriptionLabel
        let descriptionLabel = UIObjects.createLabel(text: event?.eventDescription ?? "", textAlignment: .justified, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 14, weight: UIFontWeightRegular))
        descriptionLabel.numberOfLines = 3
        self.contentView.addSubview(descriptionLabel)
        
        // Add descriptionLabel Constraints
        let descriptionLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[descriptionLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["descriptionLabel" : descriptionLabel])
        let descriptionLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel]-10-[descriptionLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["titleLabel" : titleLabel, "descriptionLabel" : descriptionLabel])
        self.contentView.addConstraints(descriptionLabelHorizontalConstraints)
        self.contentView.addConstraints(descriptionLabelVerticalConstraints)
        
        // Create dateLabel
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        var dateText = ""
        if let date = event?.date as Date? {
            dateText = dateFormatter.string(from: date)
        }
        let dateLabel = UIObjects.createLabel(text: dateText, textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 17, weight: UIFontWeightThin))
        self.contentView.addSubview(dateLabel)
        
        // Add dateLabel Constraints
        let dateLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[dateLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["dateLabel" : dateLabel])
        let dateLabelVerticalConstraints  = NSLayoutConstraint.constraints(withVisualFormat: "V:[descriptionLabel]-10-[dateLabel]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["descriptionLabel" : descriptionLabel, "dateLabel" : dateLabel])
        self.contentView.addConstraints(dateLabelHorizontalConstraints)
        self.contentView.addConstraints(dateLabelVerticalConstraints)
        
        // Create lineCircle
        guard let line = event?.line else {
            return
        }
        guard let lineCircle = UIObjects.createCircle(for: line, with: 25, in: self.contentView) else {
            return
        }
        self.contentView.addSubview(lineCircle)
        
        // Add lineCircle Constraints
        let lineCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lineCircle]", options: NSLayoutFormatOptions(), metrics: nil, views: ["lineCircle" : lineCircle])
        let lineCircleCenterY = NSLayoutConstraint(item: stationNameLabel, attribute: .centerY, relatedBy: .equal, toItem: lineCircle, attribute: .centerY, multiplier: 1, constant: 0)
        self.contentView.addConstraints(lineCircleHorizontalConstraints)
        self.contentView.addConstraint(lineCircleCenterY)
        
    }

}
