//
//  EventDetailViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/8/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var event: MetroEvent?
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create topImageView 
        guard let image = event?.image else {
            return
        }
        let topImageView = UIImageView(image: image)
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topImageView.contentMode = .scaleAspectFill
        topImageView.clipsToBounds = true
        self.view.addSubview(topImageView)
        
        // Add topImageView Constraints
        let imageViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[topImageView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["topImageView" : topImageView])
        let imageViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[topImageView(height)]", options: NSLayoutFormatOptions(), metrics: ["height" : 200], views: ["topImageView" : topImageView])
        self.view.addConstraints(imageViewHorizontalConstraints)
        self.view.addConstraints(imageViewVerticalConstraints)
        
        // Create overlay 
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = Tools.colorPicker(2, alpha: 0.8)
        self.view.addSubview(overlay)
        
        // Create overlay Constraints
        let overlayHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[overlay]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["overlay" : overlay])
        let overlayVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[overlay(height)]", options: NSLayoutFormatOptions(), metrics: ["height" : 200], views: ["overlay" : overlay])
        self.view.addConstraints(overlayHorizontalConstraints)
        self.view.addConstraints(overlayVerticalConstraints)
        
        // Create titleLabel
        let titleLabel = UIObjects.createLabel(text: event?.name ?? "", textAlignment: .justified, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 25, weight: UIFontWeightHeavy))
        self.view.addSubview(titleLabel)
        
        // Add titleLabel Constraints
        let titleLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[titleLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["titleLabel" : titleLabel])
        let titleLabelBottomConstraint = NSLayoutConstraint(item: overlay, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 20)
        self.view.addConstraints(titleLabelHorizontalConstraints)
        self.view.addConstraint(titleLabelBottomConstraint)
    
        // Create stationNameLabel
        let stationNameLabel = UIObjects.createLabel(text: event?.station?.name?.capitalized ?? "", textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 20, weight: UIFontWeightSemibold))
        self.view.addSubview(stationNameLabel)
        
        // Add stationNameLabel Constraints
        let stationNameLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-55-[stationNameLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["stationNameLabel" : stationNameLabel])
        let stationNameLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[stationNameLabel]-5-[titleLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["stationNameLabel" : stationNameLabel, "titleLabel" : titleLabel])
        self.view.addConstraints(stationNameLabelHorizontalConstraints)
        self.view.addConstraints(stationNameLabelVerticalConstraints)
        
        // Create lineCircle
        guard let line = event?.line else {
            return
        }
        guard let lineCircle = UIObjects.createCircle(for: line, with: 25, in: self.view) else {
            return
        }
        self.view.addSubview(lineCircle)
        
        // Add lineCircle Constraints
        let lineCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lineCircle]", options: NSLayoutFormatOptions(), metrics: nil, views: ["lineCircle" : lineCircle])
        let lineCircleCenterY = NSLayoutConstraint(item: stationNameLabel, attribute: .centerY, relatedBy: .equal, toItem: lineCircle, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraints(lineCircleHorizontalConstraints)
        self.view.addConstraint(lineCircleCenterY)
        
        // Create dateLabel
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        var dateText = ""
        if let date = event?.date as Date? {
            dateText = dateFormatter.string(from: date)
        }
        let dateLabel = UIObjects.createLabel(text: dateText, textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 20, weight: UIFontWeightSemibold))
        self.view.addSubview(dateLabel)
        
        // Add dateLabel Constraints
        let dateLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[dateLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["dateLabel" : dateLabel])
        let dateLabelVerticalConstraints  = NSLayoutConstraint.constraints(withVisualFormat: "V:[overlay]-20-[dateLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["overlay" : overlay, "dateLabel" : dateLabel])
        self.view.addConstraints(dateLabelHorizontalConstraints)
        self.view.addConstraints(dateLabelVerticalConstraints)
        
        // Create timeLabel
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        var timeText = ""
        if let startTime = event?.startTime as Date?, let endTime = event?.endTime as Date? {
            let startWithFormat = timeFormatter.string(from: startTime)
            let endWithFormat = timeFormatter.string(from: endTime)
            timeText = "\(startWithFormat) - \(endWithFormat)"
        }
        let timeLabel = UIObjects.createLabel(text: timeText, textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 17, weight: UIFontWeightSemibold))
        self.view.addSubview(timeLabel)
        
        // Add timeLabel Constraints
        let timeLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[timeLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["timeLabel" : timeLabel])
        let timeLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[dateLabel]-10-[timeLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["dateLabel" : dateLabel, "timeLabel" : timeLabel])
        self.view.addConstraints(timeLabelHorizontalConstraints)
        self.view.addConstraints(timeLabelVerticalConstraints)
        
        // Create descriptionTextView
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints =  false
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textAlignment = .justified
        descriptionTextView.text = event?.eventDescription ?? ""
        descriptionTextView.font = .systemFont(ofSize: 17, weight: UIFontWeightRegular)
        descriptionTextView.textColor = Tools.colorPicker(1, alpha: 1)
        descriptionTextView.indicatorStyle = .white
        self.view.addSubview(descriptionTextView)
        
         // Add descriptionTextView Constraints
        let descriptionTextViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[descriptionTextView]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["descriptionTextView" : descriptionTextView])
        let descriptionTextViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[timeLabel]-20-[descriptionTextView]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["timeLabel" : timeLabel, "descriptionTextView" : descriptionTextView])
        self.view.addConstraints(descriptionTextViewHorizontalConstraints)
        self.view.addConstraints(descriptionTextViewVerticalConstraints)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
