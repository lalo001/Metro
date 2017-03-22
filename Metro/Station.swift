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
    public enum Status: Int {
        case open = 0, closed, maintenance
    }
    
    var status: Status {
        set {
            self.statusRaw = Int16(newValue.rawValue)
        }
        get {
            return Status(rawValue: Int(self.statusRaw)) ?? .closed
        }
    }
    
    /*
    var lines: [Line] = []
    let name: String
    let status: Status
    let isLineEnd: Bool
    var serviceTypes: [Line.ServiceType] {
        get {
            var _serviceTypes: [Line.ServiceType] = []
            for line in lines {
                if !_serviceTypes.contains(line.serviceType) {
                    _serviceTypes.append(line.serviceType)
                }
            }
            return _serviceTypes
        }
    }
    
    public enum Status: Int {
        case open = 0, closed, maintenance
    }
    
    init(name: String, status: Status, isLineEnd: Bool) {
        self.name = name
        self.status = status
        self.isLineEnd = isLineEnd
    }*/
    
}
