//
//  SearchRouteViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/20/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreData

class SearchRouteViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var fromButtonContainer: UIView!
    var toButtonContainer: UIView!
    var searchButton: UIButton!
    var currentFromStation: Station?
    var currentToStation: Station?
    
    var originLabel: UILabel!
    var destinationLabel: UILabel!
    var container: UIView!
    var invertIconButton: UIButton!
    
    override func loadView() {
        super.loadView()
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        if self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) ?? false {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        
        // Create titleLabel
        let titleLabel = UIObjects.createLabel(text: NSLocalizedString(NSLocalizedString("metro", comment: "").uppercased(), comment: "").uppercased(), textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 17, weight: UIFontWeightSemibold))
        self.view.addSubview(titleLabel)
        
        // Add titleLabel Constraints
        let titleLabelCenterX = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let titleLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-topConstant-[titleLabel]", options: NSLayoutFormatOptions(), metrics: ["topConstant" : Constant.Labels.titleTopConstantSeparation], views: ["titleLabel" : titleLabel])
        self.view.addConstraint(titleLabelCenterX)
        self.view.addConstraints(titleLabelVerticalConstraints)
        
        // Create container
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(container)
        
        // Add container Constraints
        let containerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[container]-rightMargin-|", options: NSLayoutFormatOptions(), metrics: ["leftMargin" : Constant.StationPicker.leftMarginSeparation, "rightMargin" : Constant.StationPicker.rightMarginSeparation], views: ["container" : container])
        let containerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel]-topMargin-[container]", options: NSLayoutFormatOptions(), metrics: ["topMargin" : Constant.StationPicker.topMarginSeparation], views: ["titleLabel" : titleLabel, "container" : container])
        self.view.addConstraints(containerHorizontalConstraints)
        self.view.addConstraints(containerVerticalConstraints)
        
        container.layoutIfNeeded()
        
        // Create originLabel
        originLabel = UIObjects.createLabel(text: NSLocalizedString("leavingFrom", comment: "").uppercased(), textAlignment: .left, textColor: Constant.StationPicker.pickerTitleColor, font: Constant.StationPicker.pickerTitleFont)
        container.addSubview(originLabel)
        
        // Add originLabel Constraints
        let originLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        let originLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        container.addConstraints(originLabelHorizontalConstraints)
        container.addConstraints(originLabelVerticalConstraints)
    
        let lastSessionStations = CoreDataTools.getLastSessionFromToStations()
        let fromStation = lastSessionStations.0
        let toStation = lastSessionStations.1
        currentFromStation = fromStation
        currentToStation = toStation
        
        // Create fromButtonContainer
        fromButtonContainer = UIObjects.createPickerButton(for: fromStation, inside: container, with: 5, to: originLabel, target: self, action: #selector(self.stationButtonTouched(_:)), direction: .from)
        
        // Create destinationLabel
        destinationLabel = UIObjects.createLabel(text: NSLocalizedString("destination", comment: "").uppercased(), textAlignment: .left, textColor: Constant.StationPicker.pickerTitleColor, font: Constant.StationPicker.pickerTitleFont)
        container.addSubview(destinationLabel)
        
        // Add destinationLabel Constraints
        let destinationLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[fromButtonContainer]-30-[destinationLabel]", options: .alignAllLeft, metrics: nil, views: ["fromButtonContainer" : fromButtonContainer, "destinationLabel" : destinationLabel])
        container.addConstraints(destinationLabelVerticalConstraints)
        
        // Create toButtonContainer
        toButtonContainer = UIObjects.createPickerButton(for: toStation, inside: container, with: 5, to: destinationLabel, target: self, action: #selector(self.stationButtonTouched(_:)), direction: .to)
        
        // Add bottomContainerConstraints
        let bottomContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[toButtonContainer]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["toButtonContainer" : toButtonContainer])
        container.addConstraints(bottomContainerConstraints)
    
        Graphics.createRouteIcon(in: self.view, from: originLabel, to: destinationLabel)
        invertIconButton = Graphics.createInvertIconButton(in: self.view, with: container, from: fromButtonContainer, to: destinationLabel, target: self, action: #selector(self.invertStationsButtonTouched(_:)))
        searchButton = UIObjects.createRoundedButton(with: NSLocalizedString("searchRoute", comment: ""), in: self.view, target: self, action: #selector(self.searchRouteButtonTouched(_:)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Store.shared.needsUpdate {
            Store.shared.needsUpdate = false
            if let currentStation = Store.shared.station {
                if Store.shared.direction == .from {
                    let fromStation = currentStation
                    currentFromStation = fromStation
                    self.updatePickers(newFromStation: fromStation, newToStation: currentToStation)
                } else if Store.shared.direction == .to {
                    let toStation = currentStation
                    currentToStation = toStation
                    self.updatePickers(newFromStation: currentFromStation, newToStation: toStation)
                }
                if let direction = Store.shared.direction {
                    CoreDataTools.addToRecentStations(station: currentStation, with: direction)
                }
                Store.shared.station = nil
                Store.shared.direction = nil
            }
        }
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
    
    // MARK: - Custom Functions
    
    func updatePickers(newFromStation: Station?, newToStation: Station?) {
        DispatchQueue.main.async {
            self.fromButtonContainer.removeFromSuperview()
            self.toButtonContainer.removeFromSuperview()
            self.invertIconButton.removeFromSuperview()
            
            // Create fromButtonContainerr
            self.fromButtonContainer = UIObjects.createPickerButton(for: newFromStation, inside: self.container, with: 5, to: self.originLabel, target: self, action: #selector(self.stationButtonTouched(_:)), direction: .from)
            
            // Create toButtonContainer
            self.toButtonContainer = UIObjects.createPickerButton(for: newToStation, inside: self.container, with: 5, to: self.destinationLabel, target: self, action: #selector(self.stationButtonTouched(_:)), direction: .to)
            
            // Add destinationLabel Constraints
            let destinationLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[fromButtonContainer]-30-[destinationLabel]", options: .alignAllLeft, metrics: nil, views: ["fromButtonContainer" : self.fromButtonContainer, "destinationLabel" : self.destinationLabel])
            self.container.addConstraints(destinationLabelVerticalConstraints)
            
            // Add bottomContainerConstraints
            let bottomContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[toButtonContainer]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["toButtonContainer" : self.toButtonContainer])
            self.container.addConstraints(bottomContainerConstraints)
            
            self.invertIconButton = Graphics.createInvertIconButton(in: self.view, with: self.container, from: self.fromButtonContainer, to: self.destinationLabel, target: self, action: #selector(self.invertStationsButtonTouched(_:)))
            
        }
        DispatchQueue.global(qos: .background).async {
            CoreDataTools.updateSession(lastUpdateDate: nil, fromStation: newFromStation, toStation: newToStation)
            self.currentFromStation = newFromStation
            self.currentToStation = newToStation
        }
    }
    
    func stationButtonTouched(_ sender: PickerButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputStation") as? InputStationViewController else {
            return
        }
        var fallbackPlaceholder: String = ""
        var currentStation: Station?
        if sender.direction == .from {
            vc.title = "leavingFrom"
            fallbackPlaceholder = NSLocalizedString("origin", comment: "")
            currentStation = currentFromStation
        } else if sender.direction == .to {
            vc.title = "destination"
            fallbackPlaceholder = NSLocalizedString("destination", comment: "")
            currentStation = currentToStation
        }
        vc.placeholderText = currentStation != nil ? sender.titleLabel?.text : fallbackPlaceholder
        vc.direction = sender.direction
        self.present(vc, animated: true, completion: nil)
    }
    
    func invertStationsButtonTouched(_ sender: UIButton) {
        guard let currentToStation = currentToStation, let currentFromStation = currentFromStation else {
            return
        }
        updatePickers(newFromStation: currentToStation, newToStation: currentFromStation)
    }
    
    func searchRouteButtonTouched(_ sender: UIButton) {
        print("Search Route.")
        guard let firstStationName = currentFromStation?.name?.capitalized, let secondStationName = currentToStation?.name?.capitalized else {
            Tools.showNoRouteFoundAlert(self)
            return
        }
        guard let route = Dijkstra.prepareDijkstra(firstStation: firstStationName, secondStation: secondStationName) else {
            Tools.showNoRouteFoundAlert(self)
            return
        }
        let vc = RouteViewController()
        vc.route = route
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UIGestureRecognizerDelegate Functions
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
