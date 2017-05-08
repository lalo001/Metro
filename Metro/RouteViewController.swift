//
//  RouteViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/7/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController {
    
    var route: [String]?
    var containerView: UIView!
    
    // Navigation Menu Variables
    var menuContainer: UIView!
    var leftCategoryButton: UIButton!
    var leftCategoryButtonCenterY: NSLayoutConstraint!
    var rightCategoryButton: UIButton!
    var rightCategoryButtonCenterY: NSLayoutConstraint!
    var selectedLine: UIView!
    var selectedLineCenterX: NSLayoutConstraint!
    var selectedLineWidth: NSLayoutConstraint!
    var selectLineVerticalConstraints: [NSLayoutConstraint]!
    var currentTransitionHorizontalConstraint: [NSLayoutConstraint]!
    var currentCategory: Category = .left
    var routeListTableViewController: RouteListTableViewController?
    
    enum Category: Int {
        case left = 0, right
    }
    
    override func loadView() {
        super.loadView()
        
        // Set background color
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem?.title = ""
        
        // Create backButton
        let backButton = Graphics.createBackButton(in: self.view, tintColor: Tools.colorPicker(3, alpha: 1), target: self, action: #selector(self.backButtonPressed(_:)))
        
        // Create titleLabel
        let titleLabel = UIObjects.createLabel(text: NSLocalizedString("shortestRoute", comment: "").uppercased(), textAlignment: .left, textColor: Tools.colorPicker(1, alpha: 1), font: .systemFont(ofSize: 17, weight: UIFontWeightSemibold))
        self.view.addSubview(titleLabel)
        
        // Add titleLabel Constraints
        let titleLabelCenterX = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let titleLabelCenterY = NSLayoutConstraint(item: backButton, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(titleLabelCenterX)
        self.view.addConstraint(titleLabelCenterY)
        
        // Create menuContainer
        menuContainer = UIView()
        menuContainer.backgroundColor = .clear
        menuContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menuContainer)
        
        // Add menuContainer Constraints
        let menuContainerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[menuContainer]-60-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["menuContainer" : menuContainer])
        let menuContainerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel][menuContainer(55)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["titleLabel" : titleLabel, "menuContainer" : menuContainer])
        self.view.addConstraints(menuContainerHorizontalConstraints)
        self.view.addConstraints(menuContainerVerticalConstraints)
        
        // Calculate currentHorizontalSeparation
        let currentHorizontalSeparation = (self.view.frame.width - 160)/2
        
        // Create leftCategoryButton
        leftCategoryButton = UIButton(type: .system)
        leftCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        leftCategoryButton.setTitle(NSLocalizedString("list", comment: "").uppercased(), for: .normal)
        leftCategoryButton.setTitleColor(Tools.colorPicker(3, alpha: 1), for: .normal)
        leftCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        leftCategoryButton.addTarget(self, action: #selector(self.leftOptionTouched(_:)), for: .touchUpInside)
        leftCategoryButton.titleLabel?.textAlignment = .center
        menuContainer.addSubview(leftCategoryButton)
        
        // Add leftCategoryButton Constraints
        let leftCategoryButtonHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[leftCategoryButton(currentHorizontalSeparation)]", options: NSLayoutFormatOptions(), metrics: ["currentHorizontalSeparation" : currentHorizontalSeparation], views: ["leftCategoryButton" : leftCategoryButton])
        leftCategoryButtonCenterY = NSLayoutConstraint(item: menuContainer, attribute: .centerY, relatedBy: .equal, toItem: leftCategoryButton, attribute: .centerY, multiplier: 1, constant: 0)
        menuContainer.addConstraints(leftCategoryButtonHorizontalConstraints)
        menuContainer.addConstraint(leftCategoryButtonCenterY)
        
        // Create rightCategoryButton
        rightCategoryButton = UIButton(type: .system)
        rightCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        rightCategoryButton.setTitle(NSLocalizedString("map", comment: "").uppercased(), for: .normal)
        rightCategoryButton.setTitleColor(Tools.colorPicker(1, alpha: 0.85), for: .normal)
        rightCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        rightCategoryButton.addTarget(self, action: #selector(self.rightOptionTouched(_:)), for: .touchUpInside)
        rightCategoryButton.titleLabel?.textAlignment = .center
        menuContainer.addSubview(rightCategoryButton)
        
        // Add rightCategoryButton Constraints
        let rightCategoryButtonHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[leftCategoryButton][rightCategoryButton(currentHorizontalSeparation)]-20-|", options: NSLayoutFormatOptions(), metrics: ["currentHorizontalSeparation" : currentHorizontalSeparation], views: ["leftCategoryButton" : leftCategoryButton, "rightCategoryButton" : rightCategoryButton])
        rightCategoryButtonCenterY = NSLayoutConstraint(item: menuContainer, attribute: .centerY, relatedBy: .equal, toItem: rightCategoryButton, attribute: .centerY, multiplier: 1, constant: 2.5)
        menuContainer.addConstraints(rightCategoryButtonHorizontalConstraints)
        menuContainer.addConstraint(rightCategoryButtonCenterY)
        
        // Create selectedLine
        selectedLine = UIView()
        selectedLine.backgroundColor = Tools.colorPicker(3, alpha: 1)
        selectedLine.layer.cornerRadius = 1
        selectedLine.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(selectedLine)
        
        // Add selectedLine Constraints
        selectedLineCenterX = NSLayoutConstraint(item: leftCategoryButton, attribute: .centerX, relatedBy: .equal, toItem: selectedLine, attribute: .centerX, multiplier: 1, constant: 0)
        selectedLineWidth = NSLayoutConstraint(item: selectedLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        selectLineVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-41-[selectedLine(2)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["selectedLine" : selectedLine])
        menuContainer.addConstraint(selectedLineCenterX)
        menuContainer.addConstraint(selectedLineWidth)
        menuContainer.addConstraints(selectLineVerticalConstraints)
        
        // Create containerView
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        // Add containerView Constraints
        let containerViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["containerView" : containerView])
        let containerViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[menuContainer][containerView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["menuContainer" : menuContainer, "containerView" : containerView])
        self.view.addConstraints(containerViewHorizontalConstraints)
        self.view.addConstraints(containerViewVerticalConstraints)
        
        self.view.layoutIfNeeded()
        
        // Create routeListTableViewController
        routeListTableViewController = RouteListTableViewController()
        routeListTableViewController?.stations = CoreDataTools.fetchStations(with: route)
        guard let routeListTableViewController = routeListTableViewController else {
            return
        }
        
        self.addChildViewController(routeListTableViewController)
        
        // Create routeListView
        let routeListView = routeListTableViewController.view
        routeListView?.translatesAutoresizingMaskIntoConstraints = false
        if let routeListView = routeListView {
            containerView.addSubview(routeListView)
            
            // Add routeListView Constraints
            let routeListViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[routeListView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["routeListView" : routeListView])
            let routeListViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[routeListView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["routeListView" : routeListView])
            containerView.addConstraints(routeListViewHorizontalConstraints)
            containerView.addConstraints(routeListViewVerticalConstraints)
            
            routeListTableViewController.didMove(toParentViewController: self)
            
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
    
    func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation Buttons Functions
    
    func leftOptionTouched(_ sender: UIButton) {
        if currentCategory != .left {
            var currentButton: UIButton
            var currentButtonCenterY: NSLayoutConstraint
            switch currentCategory {
            case .right:
                currentButton = self.rightCategoryButton
                currentButtonCenterY = self.rightCategoryButtonCenterY
                break
            default:
                currentButton = sender
                currentButtonCenterY = self.leftCategoryButtonCenterY
                break
            }
            currentCategory = .left
            let transitionX = leftCategoryButton.frame.minX + (leftCategoryButton.frame.width/2) - 25
            let transitionWidth = abs(transitionX - selectedLine.frame.minX) + selectedLine.frame.width
            NSLayoutConstraint.deactivate([selectedLineCenterX, selectedLineWidth])
            NSLayoutConstraint.deactivate(currentTransitionHorizontalConstraint ?? [])
            currentTransitionHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(transitionX)-[selectedLine(\(transitionWidth))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["selectedLine" : selectedLine])
            menuContainer.addConstraints(currentTransitionHorizontalConstraint)
            
            UIView.animate(withDuration: 0.25, animations: {
                // Move line to transitionWidth and transitionX.
                self.view.layoutIfNeeded()
            }, completion: {(Bool) -> Void in
                // Change transitionWidth to original width.
                NSLayoutConstraint.deactivate(self.currentTransitionHorizontalConstraint)
                self.currentTransitionHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(transitionX)-[selectedLine(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["selectedLine" : self.selectedLine])
                self.menuContainer.addConstraints(self.currentTransitionHorizontalConstraint)
                UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                    // Change old category color and y-position.
                    currentButton.setTitleColor(Tools.colorPicker(1, alpha: 0.85), for: .normal)
                    currentButtonCenterY.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
                UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn, animations: {
                    self.leftCategoryButtonCenterY.constant = 2.5
                    // Change color and size of selected category.
                    self.leftCategoryButton.setTitleColor(Tools.colorPicker(3, alpha: 1), for: .normal)
                    self.view.layoutIfNeeded()
                }, completion: nil)
            })
        }
        
    }
    
    func rightOptionTouched(_ sender: UIButton) {
        if currentCategory != .right {
            var currentButton: UIButton
            var currentButtonCenterY: NSLayoutConstraint
            switch currentCategory {
            case .left:
                currentButton = self.leftCategoryButton
                currentButtonCenterY = self.leftCategoryButtonCenterY
                break
            default:
                currentButton = sender
                currentButtonCenterY = self.rightCategoryButtonCenterY
                break
            }
            let currentX = rightCategoryButton.frame.minX + (rightCategoryButton.frame.width/2) - 25
            let transitionX = currentButton.frame.minX + (currentButton.frame.width/2) - 25
            let transitionWidth = abs(currentX - selectedLine.frame.minX) + selectedLine.frame.width
            NSLayoutConstraint.deactivate([selectedLineCenterX, selectedLineWidth])
            NSLayoutConstraint.deactivate(currentTransitionHorizontalConstraint ?? [])
            currentTransitionHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(transitionX)-[selectedLine(\(transitionWidth))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["selectedLine" : selectedLine])
            menuContainer.addConstraints(currentTransitionHorizontalConstraint)
            currentCategory = .right
            
            UIView.animate(withDuration: 0.25, animations: {
                // Move line to transitionWidth and transitionX.
                self.view.layoutIfNeeded()
            }, completion: {(Bool) -> Void in
                // Change transitionWidth to original width.
                NSLayoutConstraint.deactivate(self.currentTransitionHorizontalConstraint)
                self.currentTransitionHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(currentX)-[selectedLine(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["selectedLine" : self.selectedLine])
                self.menuContainer.addConstraints(self.currentTransitionHorizontalConstraint)
                UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                    // Change old category color and y-position.
                    currentButton.setTitleColor(Tools.colorPicker(1, alpha: 0.85), for: .normal)
                    currentButtonCenterY.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
                UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn, animations: {
                    self.rightCategoryButtonCenterY.constant = 2.5
                    // Change color and size of selected category.
                    self.rightCategoryButton.setTitleColor(Tools.colorPicker(3, alpha: 1), for: .normal)
                    self.view.layoutIfNeeded()
                }, completion: nil)
            })
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
