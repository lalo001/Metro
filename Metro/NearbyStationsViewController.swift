//
//  NearbyStationsViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/7/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class NearbyStationsViewController: UIViewController {
    
    var nearbyStations: [(Station, CGFloat)]?
    var direction: PickerButton.Direction?

    override func loadView() {
        super.loadView()
        
        // Set background color
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create closeButton
        let closeButton = Graphics.createCancelButton(in: self.view, tintColor: Tools.colorPicker(3, alpha: 1), target: self, action: #selector(self.closeButtonPressed(_:)))
        
        // Create titleLabel
        let titleLabel = UIObjects.createLabel(text: NSLocalizedString("nearbyStations", comment: "").uppercased(), textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 17, weight: UIFontWeightSemibold))
        self.view.addSubview(titleLabel)
        
        // Add titleLabel Constraints
        let titleLabelCenterX = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let titleLabelCenterY = NSLayoutConstraint(item: closeButton, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(titleLabelCenterX)
        self.view.addConstraint(titleLabelCenterY)
        
        // Create nearbyResultStationsTableViewController
        let nearbyResultStationsTableViewController = NearbyResultStationsTableViewController()
        
        self.addChildViewController(nearbyResultStationsTableViewController)
        
        // Create nearbyResultsView
        let nearbyResultsView = nearbyResultStationsTableViewController.view
        nearbyResultsView?.translatesAutoresizingMaskIntoConstraints = false
        if let nearbyResultsView = nearbyResultsView {
            self.view.addSubview(nearbyResultsView)
            
            // Add nearbyResultsView Constraints
            let nearbyResultsViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[nearbyResultsView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["nearbyResultsView" : nearbyResultsView])
            let nearbyResultsViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[closeButton]-separation-[nearbyResultsView]|", options: NSLayoutFormatOptions(), metrics: ["separation" : Constant.Buttons.cancelButtonTopConstant/2], views: ["closeButton" : closeButton, "nearbyResultsView" : nearbyResultsView])
            self.view.addConstraints(nearbyResultsViewHorizontalConstraints)
            self.view.addConstraints(nearbyResultsViewVerticalConstraints)
            
            nearbyResultStationsTableViewController.didMove(toParentViewController: self)
            nearbyResultStationsTableViewController.filteredStations = nearbyStations ?? []
            nearbyResultStationsTableViewController.direction = direction
            DispatchQueue.main.async {
                nearbyResultStationsTableViewController.tableView.reloadData()
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
    
    func closeButtonPressed(_ sender: UIButton) {
        closeInput()
    }
    
    func closeInput() {
        DispatchQueue.main.async {
            guard let parentVC = self.presentingViewController as? InputStationViewController else {
                return
            }
            parentVC.shouldShowKeyboardAutomatically = false
            parentVC.presentingViewController?.dismiss(animated: true, completion: nil)
        }
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
