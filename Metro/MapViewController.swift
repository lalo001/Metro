//
//  MapViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/29/17.
//  Copyright © 2017 Eduardo Valencia Paz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // Slide View Variables
    var slideView: UIView!
    var overlay: UIView!
    var slideViewVisualEffectView: UIVisualEffectView!
    var slideViewBottomConstraint: NSLayoutConstraint?
    var slideViewHeightConstraint: NSLayoutConstraint?
    var topSeparation: CGFloat = 45
    var alwaysVisibleHeight: CGFloat = 65
    var midStateHeight: CGFloat = 0
    let midStateConstant: CGFloat = 70
    let slideViewHeightScale: CGFloat = 1.5
    var mainViewHeight: CGFloat = 0
    var slideViewSideHiddenConstant: CGFloat = 0
    
    // Map Variables
    var mapView: CustomMapView!
    var mapButtonContainer: UIVisualEffectView!
    var locationButton: LocationButton?
    var locationButtonHeight: NSLayoutConstraint?
    var locationButtonCenterY: NSLayoutConstraint?
    var mapButtonContainerTopConstraint: NSLayoutConstraint?
    
    // CLLocationManager Variables
    var locationManager: CLLocationManager!
    var statusView: UIView?
    
    // UIStatusBar Variables
    var statusBarStyle: UIStatusBarStyle = .default
    var statusBarBackgroundView: UIVisualEffectView?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create locationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.setMapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setSlideView()
        self.configureContainer()
        self.setBackgroundForStatusBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            if let statusView = statusView {
                statusView.removeFromSuperview()
            }
            self.addStatusView(status: CLLocationManager.authorizationStatus())
        } else {
            statusBarStyle = .default
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update slideView Constants
        
        self.mainViewHeight = self.view.frame.height
        self.midStateHeight = self.mainViewHeight/2 - self.midStateConstant
        
        // Update slideView Constraints' Constants
        slideView.layer.shadowPath = createShadowPath()
        slideView.layer.shadowOpacity = 0.7
        slideView.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        
        // Update Background for Status Bar
        self.setBackgroundForStatusBar()
        
        self.view.layoutIfNeeded()
        
    }
    
    // MARK: - UIPanGestureRecognizer Functions
    
    func panGestureDetected(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.translation(in: self.view)
        let velocity = gestureRecognizer.velocity(in: self.view)
        let downMaxY = mainViewHeight - alwaysVisibleHeight
        let duration: TimeInterval = 0.15
        let midStateY = mainViewHeight - midStateHeight
        if (velocity.y < 0 && slideView.frame.origin.y > topSeparation) || (velocity.y > 0 && slideView.frame.origin.y < downMaxY) || velocity.y == 0 {
            var futureOriginY = self.slideView.frame.origin.y + location.y
            if velocity.y < 0 && futureOriginY < topSeparation {
                futureOriginY = topSeparation
            } else if velocity.y > 0 && futureOriginY > downMaxY {
                futureOriginY = downMaxY
            }
            slideViewHeightConstraint?.constant = mainViewHeight - futureOriginY
            let slideViewHeight = self.view.frame.height
            let halfSlideView = (slideViewHeight - midStateHeight)/2
            let bottomHalfSlideView = slideViewHeight - halfSlideView/2
            let limitVelocity: CGFloat = 800
            let currentOriginY = slideView.frame.origin.y
            if velocity.y < -limitVelocity && (gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled) {
                // Quick swipe up
                print("Quick up")
                if currentOriginY >= midStateY {
                    slideViewHeightConstraint?.constant = midStateHeight
                } else {
                    slideViewHeightConstraint?.constant = mainViewHeight - topSeparation
                }
                let springVelocity: CGFloat = fabs(velocity.y/150)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else if velocity.y > limitVelocity && (gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled) {
                // Quick swipe down
                print("Quick down")
                if currentOriginY >= halfSlideView {
                    slideViewHeightConstraint?.constant =  alwaysVisibleHeight
                } else {
                    slideViewHeightConstraint?.constant = midStateHeight
                }
                let springVelocity: CGFloat = fabs(velocity.y/150)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: springVelocity, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
                // Move normally
                print("Move to: \(futureOriginY)")
                if futureOriginY >= bottomHalfSlideView {
                    slideViewHeightConstraint?.constant = alwaysVisibleHeight
                } else if futureOriginY >= halfSlideView {
                    slideViewHeightConstraint?.constant = midStateHeight
                } else if futureOriginY < halfSlideView {
                    slideViewHeightConstraint?.constant = mainViewHeight - topSeparation
                }
                UIView.animate(withDuration: duration, animations: {
                    self.view.layoutIfNeeded()
                })
            } else {
                slideViewHeightConstraint?.constant = mainViewHeight - futureOriginY
            }
        }
        let currentYOrigin = slideView.frame.origin.y
        if currentYOrigin < midStateY && currentYOrigin >= topSeparation {
            let distance = abs(midStateY - currentYOrigin)
            let newAlpha = (distance * 0.4)/(midStateY - topSeparation)
            DispatchQueue.main.async {
                let duration = newAlpha >= 1 ? 0.5 : 0.15
                UIView.animate(withDuration: duration, animations: {
                    self.overlay.alpha = newAlpha
                    var mapAlpha = 1 - newAlpha * 10
                    if mapAlpha > 1 {
                        mapAlpha = 1
                    } else if mapAlpha < 0 {
                        mapAlpha = 0
                    }
                    self.mapButtonContainer.alpha = mapAlpha
                })
            }
        } else {
            DispatchQueue.main.async {
                self.overlay.alpha = 0
                self.mapButtonContainer.alpha =  1
                UIView.animate(withDuration: 0.3, animations: {
                    self.overlay.alpha = 0
                    self.mapButtonContainer.alpha =  1
                })
            }
        }
        gestureRecognizer.setTranslation(.zero, in: self.view)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - MKMapViewDelegate Functions
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        locationButton?.locationState = mode
    }
    
    // MARK: - Location Button Functions
    
    func locationButtonTouched(_ sender: LocationButton) {
        switch sender.locationState {
        case .none:
            mapView.setUserTrackingMode(.follow, animated: true)
            sender.locationState = .follow
            locationButtonHeight?.constant = 21
            locationButtonCenterY?.constant = 1
            break
        case .follow:
            mapView.setUserTrackingMode(.followWithHeading, animated: true)
            sender.locationState = .followWithHeading
            locationButtonHeight?.constant = 26
            locationButtonCenterY?.constant = 0.5
        case .followWithHeading:
            mapView.setUserTrackingMode(.none, animated: true)
            sender.locationState = .none
            locationButtonHeight?.constant = 21
            locationButtonCenterY?.constant = 1
        }
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Slide View Functions
    
    func setSlideView() {
        
        if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
            mainViewHeight = self.view.frame.height - tabBarHeight
        }
        midStateHeight = mainViewHeight/2 - midStateConstant
        
        // Create slideView
        slideView = UIView()
        slideView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(slideView)
        
        let slideViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-slideViewHiddenSideConstant-[slideView]-slideViewHiddenSideConstant-|", options: NSLayoutFormatOptions(), metrics: ["slideViewHiddenSideConstant" : slideViewSideHiddenConstant], views: ["slideView" : slideView])
        slideViewHeightConstraint = NSLayoutConstraint(item: slideView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: alwaysVisibleHeight)
        slideViewBottomConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: slideView, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints(slideViewHorizontalConstraints)
        guard let slideViewHeightConstraint = slideViewHeightConstraint, let slideViewBottomConstraint = slideViewBottomConstraint else {
            return
        }
        self.view.addConstraint(slideViewHeightConstraint)
        self.view.addConstraint(slideViewBottomConstraint)
        
        // Create slideViewVisualEffectView
        let blur = UIBlurEffect(style: .dark)
        slideViewVisualEffectView = UIVisualEffectView(effect: blur)
        slideViewVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
        slideViewVisualEffectView.contentView.backgroundColor = Constant.VisualEffects.mapBlurContentViewBackgroundColor
        slideView.addSubview(slideViewVisualEffectView)
        
        // Add slideViewVisualEffectView Constraints
        let slideViewVisualEffectViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[slideViewVisualEffectView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["slideViewVisualEffectView" : slideViewVisualEffectView])
        let slideViewVisualEffectViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[slideViewVisualEffectView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["slideViewVisualEffectView" : slideViewVisualEffectView])
        slideView.addConstraints(slideViewVisualEffectViewHorizontalConstraints)
        slideView.addConstraints(slideViewVisualEffectViewVerticalConstraints)
        
        // Create panGestureRecognizer
        //slideView.addGestureRecognizer(panGestureRecognizer)
        
        overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0
        self.view.insertSubview(overlay, belowSubview: slideView)
        
        let overlayHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[overlay]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["overlay" : overlay])
        let overlayVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[overlay]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["overlay" : overlay])
        self.view.addConstraints(overlayHorizontalConstraints)
        self.view.addConstraints(overlayVerticalConstraints)
        
        mainViewHeight = self.view.frame.height
        midStateHeight = mainViewHeight/2 - midStateConstant
        
        let maskLayer = CAShapeLayer()
        let maskWidth = self.view.frame.width + abs(slideViewSideHiddenConstant) * 2
        let roundedRect = CGRect(x: 0, y: 0, width: maskWidth, height: mainViewHeight)
        maskLayer.frame = roundedRect
        maskLayer.path = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8.75, height: 8.75)).cgPath
        
        let frame = CGRect(x: 0, y: 0, width: maskWidth, height: mainViewHeight)
        let maskView = UIView(frame: frame)
        
        maskView.layer.addSublayer(maskLayer)
        slideViewVisualEffectView.mask = maskView
        
    }
    
    func configureContainer() {
        
        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        slideView.addSubview(container)
        
        // Add container Constraints
        let containerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["container" : container])
        let containerVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["container" : container])
        self.view.addConstraints(containerHorizontalConstraints)
        self.view.addConstraints(containerVerticalConstraint)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureDetected(_:)))
        panGestureRecognizer.delegate = self
        container.addGestureRecognizer(panGestureRecognizer)
        
        // Create handleIcon
        let handleIcon = Graphics.createHandleIcon(in: container)
        
        // Create titleLabel
        let titleLabel = UIObjects.createLabel(text: NSLocalizedString("stations", comment: ""), textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold))
        container.addSubview(titleLabel)
        
        // Add titleLabel Constraints
        let titleLabelCenterX = NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let titleLabelCenterVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[handleIcon]-topSeparation-[titleLabel]", options: NSLayoutFormatOptions(), metrics: ["topSeparation" : Constant.HandleIcon.topSeparation + 5], views: ["handleIcon" : handleIcon, "titleLabel" : titleLabel])
        container.addConstraint(titleLabelCenterX)
        container.addConstraints(titleLabelCenterVerticalConstraints)
        
        let tableViewController = MapPlacesTableViewController()
        self.addChildViewController(tableViewController)
        
        // Create tableView
        guard let tableView = tableViewController.view else {
            return
        }
        container.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        // Inform tableViewController it did move to parent.
        tableViewController.didMove(toParentViewController: self)
        
        let tableViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["tableView" : tableViewController.view])
        let tableViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-topSeparation-[tableView]|", options: NSLayoutFormatOptions(), metrics: ["topSeparation" : alwaysVisibleHeight], views: ["titleLabel" : titleLabel, "tableView" : tableViewController.view])
        container.addConstraints(tableViewHorizontalConstraints)
        container.addConstraints(tableViewVerticalConstraints)
        
    }
    
    // MARK: - Map View Functions
    
    func setMapView() {
        
        // Create mapView
        mapView = CustomMapView()
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.centerCoordinate = mapView.userLocation.coordinate
        mapView.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            let centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 19.4284700, longitude: -99.1276600)
            mapView.setRegion(MKCoordinateRegionMake(centerCoordinate, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 0)), animated: false)
        }
        self.view.addSubview(mapView)
        
        // Add mapView Constraints
        let mapViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["mapView" : mapView])
        let mapViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["mapView" : mapView])
        self.view.addConstraints(mapViewHorizontalConstraints)
        self.view.addConstraints(mapViewVerticalConstraints)
        
        // Create mapButtonContainer
        let blur = UIBlurEffect(style: .dark)
        mapButtonContainer = UIVisualEffectView(effect: blur)
        mapButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        mapButtonContainer.layer.cornerRadius = 10
        mapButtonContainer.clipsToBounds = true
        mapButtonContainer.contentView.backgroundColor = Constant.VisualEffects.mapBlurContentViewBackgroundColor
        mapView.addSubview(mapButtonContainer)
        
        // Add mapButtonContainer Constraints
        let mapButtonContainerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[mapButtonContainer(45)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["mapButtonContainer" : mapButtonContainer])
        let mapButtonContainerHeight = NSLayoutConstraint(item: mapButtonContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
        mapButtonContainerTopConstraint = NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: mapButtonContainer, attribute: .top, multiplier: 1, constant: -(Tools.getStatusBarHeight() + 10))
        guard let mapButtonContainerTopConstraint = mapButtonContainerTopConstraint else {
            return
        }
        mapView.addConstraints(mapButtonContainerHorizontalConstraints)
        mapView.addConstraint(mapButtonContainerHeight)
        mapView.addConstraint(mapButtonContainerTopConstraint)
        
        // Create mapLowerContainer
        let mapLowerContainer = UIView()
        mapLowerContainer.translatesAutoresizingMaskIntoConstraints = false
        mapLowerContainer.backgroundColor = .clear
        mapButtonContainer.addSubview(mapLowerContainer)
        
        // Add mapLowerContainer Constraints
        let mapLowerContainerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapLowerContainer]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["mapLowerContainer" : mapLowerContainer])
        let mapLowerContainerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-45-[mapLowerContainer]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["mapLowerContainer" : mapLowerContainer])
        mapButtonContainer.addConstraints(mapLowerContainerHorizontalConstraints)
        mapButtonContainer.addConstraints(mapLowerContainerVerticalConstraints)
        
        // Create locationButton
        locationButton = LocationButton(type: .system)
        guard let locationButton = locationButton else {
            return
        }
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addTarget(self, action: #selector(self.locationButtonTouched(_:)), for: .touchUpInside)
        locationButton.locationState = .follow
        locationButton.imageView?.contentMode = .scaleAspectFit
        locationButton.tintColor = Tools.colorPicker(1, alpha: 1)
        locationButton.backgroundColor = .clear
        mapLowerContainer.addSubview(locationButton)
        
        // Add locationButton Constraints
        let locationButtonCenterX = NSLayoutConstraint(item: mapLowerContainer, attribute: .centerX, relatedBy: .equal, toItem: locationButton, attribute: .centerX, multiplier: 1, constant: 1)
        locationButtonHeight = NSLayoutConstraint(item: locationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 21)
        locationButtonCenterY = NSLayoutConstraint(item: mapLowerContainer, attribute: .centerY, relatedBy: .equal, toItem: locationButton, attribute: .centerY, multiplier: 1, constant: -1)
        mapLowerContainer.addConstraint(locationButtonCenterX)
        if let locationButtonHeight = locationButtonHeight {
            mapLowerContainer.addConstraint(locationButtonHeight)
        }
        if let locationButtonCenterY = locationButtonCenterY {
            mapLowerContainer.addConstraint(locationButtonCenterY)
        }
        
        guard let storedStationsWithCoordinates = CoreDataTools.storedStationsWithCoordinates else {
            return
        }
        
        // FIXME: Better annotation
        for station in storedStationsWithCoordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(station.latitude), longitude: CLLocationDegrees(station.longitude))
            annotation.title = station.name
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - CLLocationManagerDelegate Functions
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            self.addStatusView(status: status)
        } else {
            if let statusView = statusView {
                statusView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - CLLocation Status Functions
    
    func addStatusView(status: CLAuthorizationStatus) {
        if let statusView = statusView {
            statusView.removeFromSuperview()
        }
        // Create statusView
        statusView = UIView()
        if let statusView = statusView {
            statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
            statusView.translatesAutoresizingMaskIntoConstraints = false
            statusView.backgroundColor = Tools.colorPicker(2, alpha: 0.95)
            self.view.addSubview(statusView)
            
            // Add statusView Constraints
            let statusViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[statusView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["statusView" : statusView])
            let statusViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[statusView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["statusView" : statusView])
            
            self.view.addConstraints(statusViewHorizontalConstraints)
            self.view.addConstraints(statusViewVerticalConstraints)
            
            // Create imageView
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            statusView.addSubview(imageView)
            
            // Add image Constraints
            let imageViewSize: CGFloat = 150
            let imageViewCenterX = NSLayoutConstraint(item: statusView, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0)
            let imageViewCenterY = NSLayoutConstraint(item: statusView, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 60)
            let imageViewWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageViewSize)
            let imageViewHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageViewSize)
            statusView.addConstraint(imageViewCenterX)
            statusView.addConstraint(imageViewCenterY)
            statusView.addConstraint(imageViewWidth)
            statusView.addConstraint(imageViewHeight)
            
            // Create title
            let title = UILabel()
            title.translatesAutoresizingMaskIntoConstraints = false
            title.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
            title.textAlignment = .center
            title.textColor = Tools.colorPicker(1, alpha: 1)
            title.numberOfLines = 0
            statusView.addSubview(title)
            
            // Add title Constraints
            let titleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[title]-50-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["title" : title])
            let titleVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView]-20-[title]", options: NSLayoutFormatOptions(), metrics: nil, views: ["imageView" : imageView, "title" : title])
            statusView.addConstraints(titleHorizontalConstraints)
            statusView.addConstraints(titleVerticalConstraints)
            
            // Create subTitle
            let subTitle = UILabel()
            subTitle.translatesAutoresizingMaskIntoConstraints = false
            subTitle.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
            subTitle.textAlignment = .center
            subTitle.textColor = Tools.colorPicker(1, alpha: 1)
            subTitle.numberOfLines = 0
            statusView.addSubview(subTitle)
            
            // Add subTitle Constraints
            let subTitleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[subTitle]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subTitle" : subTitle])
            let subTitleVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-10-[subTitle]", options: NSLayoutFormatOptions(), metrics: nil, views: ["title" : title, "subTitle" : subTitle])
            statusView.addConstraints(subTitleHorizontalConstraints)
            statusView.addConstraints(subTitleVerticalConstraints)
            
            switch status {
            case .restricted:
                imageView.image = UIImage(named: "Parental Control Icon")
                title.text = NSLocalizedString("restrictedLocationTitle", comment: "")
                subTitle.text = NSLocalizedString("restrictedLocationSubtitle", comment: "")
            default:
                break
            }
        }
        
    }
    
    func createShadowPath() -> CGMutablePath {
        UIGraphicsBeginImageContext(self.view.frame.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        let shadowPath = CGMutablePath()
        let radius: CGFloat = 8.75
        let delta: CGFloat = 5
        let innerRadius: CGFloat = 8.75 - (delta/2) * 2
        let minLeftX = slideView.bounds.minX
        let minRightX = slideView.bounds.maxX - radius
        let maxLeftX = slideView.bounds.minX + radius
        let minY = slideView.bounds.minY
        let maxY = slideView.bounds.minY + radius + delta
        let maxX = slideView.bounds.maxX
        let innerMaxX = slideView.bounds.maxX - delta
        let innerMaxY = slideView.bounds.minY + delta
        let innerMinRightX = slideView.bounds.maxX - radius - delta
        let innerMaxLeftX = slideView.bounds.minX + radius + delta
        let innerMinLeftX = slideView.bounds.minX + delta
        shadowPath.move(to: CGPoint(x: minLeftX, y: maxY))
        shadowPath.addArc(tangent1End: CGPoint(x: minLeftX, y: minY), tangent2End: CGPoint(x: maxLeftX, y: minY), radius: radius)
        shadowPath.addLine(to: CGPoint(x: minRightX, y: minY))
        shadowPath.addArc(tangent1End: CGPoint(x: maxX, y: minY), tangent2End: CGPoint(x: maxX, y: maxY), radius: radius)
        shadowPath.addLine(to: CGPoint(x: maxX, y: maxY))
        shadowPath.addLine(to: CGPoint(x: innerMaxX, y: maxY))
        shadowPath.addArc(tangent1End: CGPoint(x: innerMaxX, y: innerMaxY), tangent2End: CGPoint(x: innerMinRightX, y: innerMaxY), radius: innerRadius)
        shadowPath.addLine(to: CGPoint(x: innerMaxLeftX, y: innerMaxY))
        shadowPath.addArc(tangent1End: CGPoint(x: innerMinLeftX, y: innerMaxY), tangent2End: CGPoint(x: innerMinLeftX, y: innerMaxY), radius: innerRadius)
        shadowPath.addLine(to: CGPoint(x: innerMinLeftX, y: maxY))
        shadowPath.closeSubpath()
        context?.saveGState()
        UIGraphicsEndImageContext()
        return shadowPath
    }
    
    // MARK: - UIStatusBar Functions
    
    func setBackgroundForStatusBar() {
        
        let statusBarFrame = Tools.getStatusBarFrame()
        if statusBarFrame.height <= 20 {
            if statusBarBackgroundView == nil {
                // Create statusBarBackgroundView
                let blur = UIBlurEffect(style: .light)
                statusBarBackgroundView = UIVisualEffectView(effect: blur)
                guard let statusBarBackgroundView = statusBarBackgroundView else {
                    return
                }
                statusBarBackgroundView.frame = Tools.getStatusBarFrame()
                statusBarBackgroundView.contentView.backgroundColor = Tools.colorPicker(2, alpha: 0)
                self.view.insertSubview(statusBarBackgroundView, belowSubview: overlay)
            }
        } else {
            statusBarBackgroundView?.removeFromSuperview()
            statusBarBackgroundView = nil
        }
    }
    
}
