//
//  Station.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/20/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreData

class Station: NSManagedObject {
    
    /// These constants specify the status of the station.
    public enum Status: Int {
        case open = 0, closed, inMaintenance
    }
    
    var status: Status {
        set {
            self.statusRaw = Int16(newValue.rawValue)
        }
        get {
            return Status(rawValue: Int(self.statusRaw)) ?? .closed
        }
    }
    
    var serviceTypes: [Line.ServiceType] {
        get {
            var _serviceTypes: [Line.ServiceType] = []
            if let lines = self.lines {
                for line in lines {
                    if let line = line as? Line {
                        if !_serviceTypes.contains(line.serviceType) {
                            _serviceTypes.append(line.serviceType)
                        }
                    }
                }
            }
            return _serviceTypes
        }
    }
    
    /**
    Create a new station managed object.
    - parameters:
        - name: The station name String.
        - status: The station status constant.
        - isLineEnd: A boolean that indicates wether the station is the end of any line.
        - hasRestroom: A boolean that indicates
    */
    convenience init(name: String, status: Status, isLineEnd: Bool, hasRestroom: Bool, hasComputers: Bool, hasPOI: Bool, context: NSManagedObjectContext?) {
        self.init(entity: Station.entity(), insertInto: context)
        self.name = name
        self.status = status
        self.isLineEnd = isLineEnd
        self.hasRestroom = hasRestroom
        self.hasComputers = hasComputers
        self.hasPOI = hasPOI
    }
    
}
