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
    
    var fromStation: Station?
    var fromButtonContainer: UIView!
    var fromCirclesContainer: UIView!
    var toButtonContainer: UIView!
    var toCirclesContainer: UIView!
    
    override func loadView() {
        super.loadView()
        
        self.title = NSLocalizedString("metro", comment: "")
        self.navigationItem.title = self.title?.uppercased()
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create originLabel
        let originLabel = UIObjects.createLabel(text: NSLocalizedString("leavingFrom", comment: "").uppercased(), textAlignment: .left, textColor: Constant.StationPicker.pickerTitleColor, font: Constant.StationPicker.pickerTitleFont)
        self.view.addSubview(originLabel)
        
        // Add originLabel Constraints
        let originLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[originLabel]", options: NSLayoutFormatOptions(), metrics: ["leftMargin" : Constant.StationPicker.leftMarginSeparation], views: ["originLabel" : originLabel])
        let originLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        self.view.addConstraints(originLabelHorizontalConstraints)
        self.view.addConstraints(originLabelVerticalConstraints)
        
        //FIXME: Delete testStation
        let results = coreDataDemo()
        
        // Create fromButtonContainer
        fromButtonContainer = UIObjects.createPickerButton(for: results.1!, inside: self.view, with: 5, to: originLabel, target: self, action: #selector(self.stationButtonTouched(_:)))
        results.0?.colors = [Tools.colorPicker(5, alpha: 1)] // FIXME: Delete
        
        // Create destinationLabel
        let destinationLabel = UIObjects.createLabel(text: NSLocalizedString("destination", comment: "").uppercased(), textAlignment: .left, textColor: Constant.StationPicker.pickerTitleColor, font: Constant.StationPicker.pickerTitleFont)
        self.view.addSubview(destinationLabel)
        
        // Add destinationLabel Constraints
        let destinationLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[fromButtonContainer]-30-[destinationLabel]", options: .alignAllLeft, metrics: nil, views: ["fromButtonContainer" : fromButtonContainer, "destinationLabel" : destinationLabel])
        self.view.addConstraints(destinationLabelVerticalConstraints)
        
        // Create toButtonContainer
        let station = Station(name: "Tasqueña", status: .open, isLineEnd: true, hasRestroom: true, hasComputers: false, hasPOI: false, context: CoreDataTools.getContext())
        station.addToLines(results.0!)
        toButtonContainer = UIObjects.createPickerButton(for: station, inside: self.view, with: 5, to: destinationLabel, target: self, action: #selector(self.stationButtonTouched(_:)))
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
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let inset: CGFloat = toButton.frame.width - (toButton.titleLabel?.frame.width ?? 0) - (toButton.imageView?.frame.width ?? 0)
        print("Inset: \(inset)")
        toButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        toButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: -inset)
        toButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }*/
    
    // MARK: - Custom Functions
    
    func stationButtonTouched(_ sender: PickerButton) {
        print("Station touched.")
    }
    
    // FIXME: Delete
    func coreDataDemo() -> (Line?, Station?) {
        // MARK: - Core Data Demo
        var shouldUpdate: Bool = false // This would be given the value the API returns
        guard let managedContext = CoreDataTools.getContext() else { // In CoreDataTools there's a function that returns you the context.
            return (nil, nil)
        }
        
        var testLine: Line?
        var testStation: Station?
        
        let fetchRequest = NSFetchRequest<Line>(entityName: "Line") // Begin a fetch on Line
        let predicate = NSPredicate(format: "name = %@", "2") // Predicate so that we are looking for Lines named '2'
        fetchRequest.predicate = predicate // Assign the predicate to the fetch
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) // Execute the fetch and save the results
            if fetchedResult.count == 0 {
                shouldUpdate = true
                print("New.")
            } else {
                print("Already added. Count: \(fetchedResult.count)")
                if let line = fetchedResult.first, let station = fetchedResult.first?.stations?.allObjects[0] as? Station {
                    testLine = line
                    testStation = station
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        if shouldUpdate {
            // In case we need to update
            testLine = Line(name: "2", serviceType: .lightRail, context: managedContext) // Call Line convenience init. This a custom init.
            testStation = Station(name: "Etiopía / Plaza de la transparencia", status: .open, isLineEnd: true, hasRestroom: true, hasComputers: false, hasPOI: false, context: managedContext) // Call Station convenience init.
            guard let testStation = testStation else {
                return (nil, nil)
            }
            testLine?.addStation(station: testStation)
            do {
                try managedContext.save() // Save the changes. This is key.
                print("\(testLine!.description) saved.") // FIXME: Delete
            } catch let error {
                print(error)
            }
        }
        
        guard let unwrappedLine = testLine, let unwrappedStation = testStation else {
            return (nil, nil)
        }
        return (unwrappedLine, unwrappedStation)
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
