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
    var fromButton: UIButton!
    
    override func loadView() {
        super.loadView()
        
        self.title = NSLocalizedString("metro", comment: "")
        self.navigationItem.title = self.title?.uppercased()
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create originLabel
        let originLabel = UIObjects.createLabel(text: NSLocalizedString("leavingFrom", comment: "").uppercased(), textAlignment: .left, textColor: Constant.StationPicker.pickerTitleColor, font: Constant.StationPicker.pickerTitleFont)
        self.view.addSubview(originLabel)
        
        // Add originLabel Constraints
        let originLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        let originLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[originLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["originLabel" : originLabel])
        self.view.addConstraints(originLabelHorizontalConstraints)
        self.view.addConstraints(originLabelVerticalConstraints)
        
        //FIXME: Delete testStation
        let testStation = coreDataDemo()
        fromButton = UIObjects.createPickerButton(for: testStation!, inside: self.view, topConstant: 5, topObject: originLabel)
        
        let circleSize: CGFloat = 25
        // To achieve a circle the cornerRadius must be half of the square size.
        let cornerRadius: CGFloat = circleSize/2
        // Create firstStationCircle
        /*let firstStationCircle = UIObjects.createStationCircle(station: testStation!, cornerRadius: cornerRadius)
        self.view.addSubview(firstStationCircle)
        
        // Add firstStationCircle Constraints
        let firstStationCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[firstStationCircle(circleSize)]", options: NSLayoutFormatOptions(), metrics: ["circleSize" : circleSize], views: ["firstStationCircle" : firstStationCircle])
        let firstStationCircleHeight = NSLayoutConstraint(item: firstStationCircle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: circleSize)
        let firstStationCenterY = NSLayoutConstraint(item: firstStationLabel, attribute: .centerY, relatedBy: .equal, toItem: firstStationCircle, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraints(firstStationCircleHorizontalConstraints)
        self.view.addConstraint(firstStationCircleHeight)
        self.view.addConstraint(firstStationCenterY)
        
        // Create secondLineLabel
        let secondLineLabel = UIObjects.createLabel(text: "\(NSLocalizedString("line", comment: "")) 1", textAlignment: .left, textColor: Constant.Labels.subtitleLabelColor, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium))
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
    
    func coreDataDemo() -> Station? {
        // MARK: - Core Data Demo
        var shouldUpdate: Bool = false // This would be given the value the API returns
        guard let managedContext = CoreDataTools.getContext() else { // In CoreDataTools there's a function that returns you the context.
            return nil
        }
        
        var testLine: Line
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
                return nil
            }
            testLine.addStation(station: testStation)
            do {
                try managedContext.save() // Save the changes. This is key.
                print("\(testLine.description) saved.")
            } catch let error {
                print(error)
            }
        }
        guard let unwrappedStation = testStation else {
            return nil
        }
        return unwrappedStation
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
