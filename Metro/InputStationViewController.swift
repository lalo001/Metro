//
//  InputStationViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/5/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreLocation

class InputStationViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    var direction: PickerButton.Direction?
    var scrollView: UIScrollView!
    var contentView: UIView!
    var searchTextField: UITextField!
    var useLocationButton: UIButton!
    var placeholderText: String?
    var resultsLabel: UILabel!
    var resultStationsTableViewController: ResultStationsTableViewController?
    var shouldShowKeyboardAutomatically: Bool = true
    
    var locationManager: CLLocationManager?
    var locationUpdateCount: Int = 0
    
    override func loadView() {
        super.loadView()
        
        // Set background color
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create tapRecognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        // Create closeButton
        let closeButton = Graphics.createCancelButton(in: self.view, tintColor: Tools.colorPicker(3, alpha: 1), target: self, action: #selector(self.closeButtonPressed(_:)))
        
        // Create titleLabel
        let titleLabel = UIObjects.createLabel(text: NSLocalizedString(self.title ?? "", comment: "").uppercased(), textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 17, weight: UIFontWeightSemibold))
        self.view.addSubview(titleLabel)
        
        // Add titleLabel Constraints
        let titleLabelCenterX = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let titleLabelCenterY = NSLayoutConstraint(item: closeButton, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(titleLabelCenterX)
        self.view.addConstraint(titleLabelCenterY)
        
        // Create scrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        
        // Add scrollView Constraints
        let scrollViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scrollView" : scrollView])
        let scrollViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[closeButton]-separation-[scrollView]|", options: NSLayoutFormatOptions(), metrics: ["separation" : Constant.Buttons.cancelButtonTopConstant/2], views: ["closeButton" : closeButton, "scrollView" : scrollView])
        self.view.addConstraints(scrollViewHorizontalConstraints)
        self.view.addConstraints(scrollViewVerticalConstraints)
        
        // Create contentView
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Add contentView Constraints 
        let contentViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView(width)]|", options: NSLayoutFormatOptions(), metrics: ["width" : self.view.frame.width], views: ["contentView" : contentView])
        let contentViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(height)]|", options: NSLayoutFormatOptions(), metrics: ["height" : self.view.frame.height - 30 - (Constant.Buttons.cancelButtonTopConstant * 1.5)], views: ["contentView" : contentView])
        scrollView.addConstraints(contentViewHorizontalConstraints)
        scrollView.addConstraints(contentViewVerticalConstraints)
        
        // Create searchTextField
        searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.textColor = Tools.colorPicker(1, alpha: 1)
        searchTextField.font = .systemFont(ofSize: 36, weight: UIFontWeightBold)
        searchTextField.tintColor = Tools.colorPicker(3, alpha: 1)
        let attributedSearchTextFieldPlaceHolder = NSAttributedString(string: placeholderText?.capitalized ?? "", attributes: [NSForegroundColorAttributeName : Tools.colorPicker(1, alpha: 0.8)])
        searchTextField.attributedPlaceholder = attributedSearchTextFieldPlaceHolder
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .words
        searchTextField.returnKeyType = .search
        searchTextField.keyboardAppearance = .dark
        searchTextField.adjustsFontSizeToFitWidth = true
        searchTextField.minimumFontSize = 17
        searchTextField.addTarget(self, action: #selector(self.textFieldTextDidChange(_:)), for: .editingChanged)
        contentView.addSubview(searchTextField)
        
        // Add searchTextField Constraints
        let searchTextFieldHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[searchTextField]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["searchTextField" : searchTextField])
        let searchTextFieldVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[searchTextField]", options: NSLayoutFormatOptions(), metrics: nil, views: ["searchTextField" : searchTextField])
        contentView.addConstraints(searchTextFieldVerticalConstraints)
        contentView.addConstraints(searchTextFieldHorizontalConstraints)
        
        // Create separatorLine
        let separatorLine = UIView()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = Tools.colorPicker(1, alpha: 0.8)
        contentView.addSubview(separatorLine)
        
        // Add separatorLine Constraints
        let separatorLineHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorLine]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["separatorLine" : separatorLine])
        let separatorLineVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[searchTextField]-15-[separatorLine(0.5)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["searchTextField" : searchTextField, "separatorLine" : separatorLine])
        contentView.addConstraints(separatorLineHorizontalConstraints)
        contentView.addConstraints(separatorLineVerticalConstraints)
        
        // Create useLocationButton
        useLocationButton = UIButton(type: .system)
        useLocationButton.translatesAutoresizingMaskIntoConstraints = false
        useLocationButton.tintColor = Tools.colorPicker(3, alpha: 1)
        useLocationButton.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFontWeightMedium)
        useLocationButton.setTitle(NSLocalizedString("useNearestStation", comment: ""), for: .normal)
        useLocationButton.contentHorizontalAlignment = .left
        if let currentLocationImage = UIImage(named: "Location Icon") {
            useLocationButton.setImage(currentLocationImage, for: .normal)
            useLocationButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        useLocationButton.setTitleColor(Tools.colorPicker(3, alpha: 1), for: .normal)
        useLocationButton.addTarget(self, action: #selector(self.findNearestStation(_:)), for: .touchUpInside)
        contentView.addSubview(useLocationButton)
        
        // Add useLocationButton Constraints
        let useLocationButtonHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[useLocationButton]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["useLocationButton" : useLocationButton])
        let useLocationButtonVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[separatorLine]-15-[useLocationButton]", options: NSLayoutFormatOptions(), metrics: nil, views: ["separatorLine" : separatorLine, "useLocationButton" : useLocationButton])
        contentView.addConstraints(useLocationButtonHorizontalConstraints)
        contentView.addConstraints(useLocationButtonVerticalConstraints)
        
        // Create resultsLabel
        resultsLabel = UIObjects.createLabel(text: NSLocalizedString("recents", comment: ""), textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 0.8), font: .systemFont(ofSize: 17, weight: UIFontWeightRegular))
        contentView.addSubview(resultsLabel)
        
        // Add resultsLabel Constraints
        let resultsLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[resultsLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["resultsLabel" : resultsLabel])
        let resultsLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[useLocationButton]-15-[resultsLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["useLocationButton" : useLocationButton, "resultsLabel" : resultsLabel])
        contentView.addConstraints(resultsLabelHorizontalConstraints)
        contentView.addConstraints(resultsLabelVerticalConstraints)
        
        // Create resultStationsTableViewController
        resultStationsTableViewController = ResultStationsTableViewController()
        guard let resultStationsTableViewController = resultStationsTableViewController else {
            return
        }
        
        self.addChildViewController(resultStationsTableViewController)
        
        // Create resultsView
        let resultsView = resultStationsTableViewController.view
        resultsView?.translatesAutoresizingMaskIntoConstraints = false
        if let resultsView = resultsView {
            contentView.addSubview(resultsView)
            
            // Add resultsView Constraints
            let resultsViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[resultsView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["resultsView" : resultsView])
            let resultsViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[resultsLabel]-3-[resultsView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["resultsLabel" : resultsLabel, "resultsView" : resultsView])
            contentView.addConstraints(resultsViewHorizontalConstraints)
            contentView.addConstraints(resultsViewVerticalConstraints)
            
            resultStationsTableViewController.didMove(toParentViewController: self)
            
            resultStationsTableViewController.filteredStations = self.filterStations(with: searchTextField.text ?? "")
            DispatchQueue.main.async {
                self.resultStationsTableViewController?.tableView.reloadData()
            }
        }
        
        shouldShowKeyboardAutomatically = true
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldShowKeyboardAutomatically {
            searchTextField.becomeFirstResponder()
        } else {
            shouldShowKeyboardAutomatically = true
        }
        locationUpdateCount = 0
    }
    
    // MARK: - Custom Functions
    
    func closeButtonPressed(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }

    func textFieldTextDidChange(_ textField: UITextField) {
        resultStationsTableViewController?.filteredStations = self.filterStations(with: textField.text ?? "")
        DispatchQueue.main.async {
            self.resultStationsTableViewController?.tableView.reloadData()
        }
    }
    
    func findNearestStation(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        sender.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            self.getUserLocation()
        }
        animateLookingForNearestStation(sender, completion:  { _ in
            self.animateLookingForNearestStation(sender, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 , execute: {
                    UIView.setAnimationsEnabled(false)
                    sender.setTitle(NSLocalizedString("useNearestStation", comment: ""), for: .normal)
                    sender.layoutIfNeeded()
                    sender.isUserInteractionEnabled = true
                    UIView.setAnimationsEnabled(true)
                })
            })
        })
    }
    
    func animateLookingForNearestStation(_ sender: UIButton, completion: (() -> Void)?) {
        UIView.setAnimationsEnabled(false)
        sender.setTitle("Looking for closest station...", for: .normal)
        sender.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 , execute: {
            UIView.setAnimationsEnabled(false)
            sender.setTitle("Looking for closest station..", for: .normal)
            sender.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
            UIView.setAnimationsEnabled(false)
            sender.setTitle("Looking for closest station.", for: .normal)
            sender.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75 , execute: {
            UIView.setAnimationsEnabled(false)
            sender.setTitle("Looking for closest station..", for: .normal)
            sender.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            UIView.setAnimationsEnabled(false)
            sender.setTitle("Looking for closest station...", for: .normal)
            sender.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
            completion?()
        })
    }
    
    func filterStations(with text: String) -> [Station] {
        if text == "" {
            guard let recents = CoreDataTools.getLastSessionRecentStations(for: direction ?? .from) else {
                resultsLabel.text = NSLocalizedString("noRecentStations", comment: "")
                return []
            }
            if recents.count > 0 {
                resultsLabel.text = NSLocalizedString("recents", comment: "")
            } else {
                resultsLabel.text = NSLocalizedString("noRecentStations", comment: "")
            }
            return recents
        }
        guard let storedStations = CoreDataTools.storedStations else {
            return []
        }
        let filteredStations =  storedStations.filter ({
            guard let components = $0.name?.components(separatedBy: .whitespacesAndNewlines) else {
                return false
            }
            for current in  components {
                let currentRange =  current.range(of: text, options: [.caseInsensitive, .diacriticInsensitive], range: nil, locale: nil)
                if currentRange?.isEmpty ?? false {
                    continue
                }
                if currentRange?.contains(current.startIndex) ?? false {
                    return true
                }
            }
            return false
        })
        
        if filteredStations.count > 0 {
            resultsLabel.text = NSLocalizedString("results", comment: "")
        } else if filteredStations.count == 0 {
            resultsLabel.text = NSLocalizedString("noStationsFound", comment: "")
        }
        return filteredStations
    }
    
    func backgroundTapped(_ gestureRecognizer: UIGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    func getUserLocation() {
        if !CLLocationManager.locationServicesEnabled() {
            Tools.showLocationServicesOffAlert(self)
            return
        }
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .notDetermined {
            return
        } else if CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            Tools.showLocationServicesOffAlert(self)
            return
        }
        locationManager?.startUpdatingLocation()
    }
    
    func calculateNearestStations(_ coordinate: CLLocationCoordinate2D?) -> [(Station, CGFloat)]? {
        var nearbyDictionary: [Station : CGFloat]? = [:]
        guard let storedStations = CoreDataTools.storedStationsWithCoordinates, let coordinate = coordinate else {
            return nil
        }
        let userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        for currentStation in storedStations {
            let currentLocation = CLLocation(latitude: CLLocationDegrees(currentStation.latitude), longitude: CLLocationDegrees(currentStation.longitude))
            let distance = userLocation.distance(from: currentLocation)
            nearbyDictionary?[currentStation] = CGFloat(distance)
        }
        let sortedStations = nearbyDictionary?.sorted(by: {
            $0.1 < $1.1
        })
        return sortedStations
    }
    
    // MARK: - CLLocationManagerDelegate Functions
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        Tools.showLocationNotAvailableAlert(self)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Update")
        manager.stopUpdatingLocation()
        if locationUpdateCount == 0 {
            let nearbyStations = calculateNearestStations(locations.last?.coordinate)
            let vc = NearbyStationsViewController()
            vc.nearbyStations = nearbyStations
            self.present(vc, animated: true, completion: nil)
        }
        locationUpdateCount += 1
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        }
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
