//
//  SearchRouteViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/20/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class SearchRouteViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        self.title = NSLocalizedString("metro", comment: "")
        self.navigationItem.title = self.title?.uppercased()
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create originLabel
        let originLabel = Tools.createLabel(text: (NSLocalizedString("departingFrom", comment: "")), textAlignment: .left, textColor: Constant.labels.subtitleLabelColor, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium))
        self.view.addSubview(originLabel)
        
        // Add originLabel Constraints
        let originLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        let originLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        self.view.addConstraints(originLabelHorizontalConstraints)
        self.view.addConstraints(originLabelVerticalConstraints)
        
        // Create firstStationLabel
        let firstStationLabel = Tools.createLabel(text: "Tasqueña", textAlignment: .left, textColor: Constant.labels.titleLabelColor, font: UIFont.systemFont(ofSize: 28, weight: UIFontWeightBold))
        firstStationLabel.numberOfLines = 0
        self.view.addSubview(firstStationLabel)
        
        // Add firstStationLabel Constraints
        let firstStationLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[firstStationLabel]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["firstStationLabel" : firstStationLabel])
        let firstStationLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[originLabel][firstStationLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel, "firstStationLabel" : firstStationLabel])
        self.view.addConstraints(firstStationLabelHorizontalConstraints)
        self.view.addConstraints(firstStationLabelVerticalConstraints)
        
        // FIXME: Delete this test station
        /*
        //let testLine = Line(name: "2", serviceType: .subway)
        //let testStation = Station(name: "Tasqueña", status: .open, isLineEnd: false)
        //testLine.addStation(station: testStation)
        
        let circleSize: CGFloat = 25
        // To achieve a circle the cornerRadius must be half of the square size.
        let cornerRadius: CGFloat = circleSize/2
        
        // Create firstStationCircle
        let firstStationCircle = Tools.createStationCircle(station: testStation, cornerRadius: cornerRadius)
        self.view.addSubview(firstStationCircle)
        
        // Add firstStationCircle Constraints
        let firstStationCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[firstStationCircle(circleSize)]", options: NSLayoutFormatOptions(), metrics: ["circleSize" : circleSize], views: ["firstStationCircle" : firstStationCircle])
        let firstStationCircleHeight = NSLayoutConstraint(item: firstStationCircle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: circleSize)
        let firstStationCenterY = NSLayoutConstraint(item: firstStationLabel, attribute: .centerY, relatedBy: .equal, toItem: firstStationCircle, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraints(firstStationCircleHorizontalConstraints)
        self.view.addConstraint(firstStationCircleHeight)
        self.view.addConstraint(firstStationCenterY)
        
        // Create secondLineLabel
        let secondLineLabel = Tools.createLabel(text: "\(NSLocalizedString("line", comment: "")) 1", textAlignment: .left, textColor: Constant.labels.subtitleLabelColor, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium))
        self.view.addSubview(secondLineLabel)
        
        // Add secondLineLabel Constraints
        let secondLineLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[firstStationLabel]-20-[secondLineLabel]", options: .alignAllLeft, metrics: nil, views: ["firstStationLabel" : firstStationLabel, "secondLineLabel" : secondLineLabel])
        self.view.addConstraints(secondLineLabelVerticalConstraints)
        
        // Create secondStationLabel*/
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
