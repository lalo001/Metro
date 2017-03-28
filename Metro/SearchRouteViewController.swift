//
//  SearchRouteViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/20/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreData

class SearchRouteViewController: UIViewController {
    
    var fromButtonContainer: UIView!
    var toButtonContainer: UIView!
    var searchButton: UIButton!
    
    override func loadView() {
        super.loadView()
        
        self.title = NSLocalizedString("metro", comment: "")
        self.navigationItem.title = self.title?.uppercased()
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(container)
        
        // Add container Constraints
        let containerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[container]-rightMargin-|", options: NSLayoutFormatOptions(), metrics: ["leftMargin" : Constant.StationPicker.leftMarginSeparation, "rightMargin" : Constant.StationPicker.rightMarginSeparation], views: ["container" : container])
        let containerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[container]", options: NSLayoutFormatOptions(), metrics: ["topMargin" : Constant.StationPicker.topMarginSeparation], views: ["container" : container])
        self.view.addConstraints(containerHorizontalConstraints)
        self.view.addConstraints(containerVerticalConstraints)
        
        container.layoutIfNeeded()
        
        // Create originLabel
        let originLabel = UIObjects.createLabel(text: NSLocalizedString("leavingFrom", comment: "").uppercased(), textAlignment: .left, textColor: Constant.StationPicker.pickerTitleColor, font: Constant.StationPicker.pickerTitleFont)
        container.addSubview(originLabel)
        
        // Add originLabel Constraints
        let originLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        let originLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        container.addConstraints(originLabelHorizontalConstraints)
        container.addConstraints(originLabelVerticalConstraints)
        
        // Create fromStation
        var lastSessionStations = CoreDataTools.getLastSessionFromToStations()
        if lastSessionStations.0 == nil || lastSessionStations.1 == nil {
            if let fromStation = CoreDataTools.storedStations?.first, let toStation = CoreDataTools.storedStations?[1] {
                CoreDataTools.updateSession(lastUpdateDate: nil, fromStation: fromStation, toStation: toStation)
            }
        }
        lastSessionStations = CoreDataTools.getLastSessionFromToStations()
        guard let fromStation = lastSessionStations.0, let toStation = lastSessionStations.1 else {
            return
        }
        // Create fromButtonContainerr
        fromButtonContainer = UIObjects.createPickerButton(for: fromStation, inside: container, with: 5, to: originLabel, target: self, action: #selector(self.stationButtonTouched(_:)))
        
        // Create destinationLabel
        let destinationLabel = UIObjects.createLabel(text: NSLocalizedString("destination", comment: "").uppercased(), textAlignment: .left, textColor: Constant.StationPicker.pickerTitleColor, font: Constant.StationPicker.pickerTitleFont)
        container.addSubview(destinationLabel)
        
        // Add destinationLabel Constraints
        let destinationLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[fromButtonContainer]-30-[destinationLabel]", options: .alignAllLeft, metrics: nil, views: ["fromButtonContainer" : fromButtonContainer, "destinationLabel" : destinationLabel])
        container.addConstraints(destinationLabelVerticalConstraints)
        
        // Create toButtonContainer
        toButtonContainer = UIObjects.createPickerButton(for: toStation, inside: container, with: 5, to: destinationLabel, target: self, action: #selector(self.stationButtonTouched(_:)))
        
        // Add bottomContainerConstraints
        let bottomContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[toButtonContainer]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["toButtonContainer" : toButtonContainer])
        container.addConstraints(bottomContainerConstraints)
        
        Graphics.createRouteIcon(in: self.view, from: originLabel, to: destinationLabel)
        Graphics.createInvertIconButton(in: self.view, with: container, from: fromButtonContainer, to: destinationLabel, target: self, action: #selector(self.invertStationsButtonTouched(_:)))
        searchButton = UIObjects.createRoundedButton(with: NSLocalizedString("searchRoute", comment: ""), in: self.view, target: self, action: #selector(self.searchRouteButtonTouched(_:)))
        
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
    
    // MARK: - Custom Functions
    
    func stationButtonTouched(_ sender: PickerButton) {
        print("Station touched.")
    }
    
    func invertStationsButtonTouched(_ sender: UIButton) {
        print("Invert Stations.")
    }
    
    func searchRouteButtonTouched(_ sender: UIButton) {
        print("Search Royte.")
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
