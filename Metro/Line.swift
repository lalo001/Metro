//
//  Line.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/20/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreData

public class Line: NSManagedObject {
    /// These constants specify the type of service of a line.
    public enum ServiceType: Int {
        
        case subway = 0, lightRail, suburbanTrain, unknown
        
        var description: String {
            switch self {
            case .subway:
                return NSLocalizedString("subway", comment: "")
            case .lightRail:
                return NSLocalizedString("lightRail", comment: "")
            case .suburbanTrain:
                return NSLocalizedString("suburbanTrain", comment: "")
            case .unknown:
                
                return NSLocalizedString("unknown", comment: "")
            }
        }
    }
    var serviceType: ServiceType {
        set {
            self.serviceTypeRaw = Int16(newValue.rawValue)
        }
        get {
            return ServiceType(rawValue: Int(self.serviceTypeRaw)) ?? .unknown
        }
    }
    
    var colors: [UIColor]? {
        set {
            self.colorsData = NSKeyedArchiver.archivedData(withRootObject: newValue as Any) as NSData?
        }
        get {
            if let colorsData = colorsData as Data? {
                let colorArray = NSKeyedUnarchiver.unarchiveObject(with: colorsData) as? [UIColor]
                return colorArray
            }
            return nil
        }
    }
    
    override public var description: String {
        if let name = self.name {
            return "\(self.serviceType.description) Line \(name)."
        } else {
            return "\(self.serviceType.description) Line has no name."
        }
    }
    
    convenience init(name: String, serviceType: ServiceType, order: Int, context: NSManagedObjectContext) {
        self.init(entity: Line.entity(), insertInto: context)
        self.name = name
        self.serviceType = serviceType
        self.order = Int16(order)
    }
    
    func addStation(station: Station) {
        self.addToStations(station)
        station.addToLines(self)
    }
    
    func setLineEnds(from firstStation: Station, to secondStation: Station) {
        self.addToLineEnds([firstStation, secondStation])
    }
}
