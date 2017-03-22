//
//  Line.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/20/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreData

class Line: NSManagedObject {
    public enum ServiceType: Int {
        case subway = 0, lightRail, suburbanTrain, unknown
    }
    var serviceType: ServiceType {
        set {
            self.serviceTypeRaw = Int16(serviceType.rawValue)
        }
        get {
            return ServiceType(rawValue: Int(self.serviceTypeRaw)) ?? .unknown
        }
    }
    /*
    let name: String
    var _colors: [UIColor] = []
    var colors: [UIColor] {
        set {
            if let number = Int(name) {
                let index = number == 12 ? 17 : number + 3
                _colors = [Tools.colorPicker(index, alpha: 1)]
            } else {
                switch name {
                case "A":
                    _colors = [Tools.colorPicker(13, alpha: 1)]
                    break
                case "B":
                    _colors = [Tools.colorPicker(14, alpha: 1), Tools.colorPicker(15, alpha: 1)]
                    break
                case "Suburban Train":
                    _colors = [Tools.colorPicker(17, alpha: 1)]
                default:
                    _colors = [.clear]
                }
            }
        }
        get {
            return _colors
        }
    }
    var lineEnds: [Station] = []
    var stations: [Station] = []
    let serviceType: ServiceType
    
    public enum ServiceType: Int {
        case subway = 0, lightRail, suburbanTrain
    }
    
    init(name: String, serviceType: ServiceType) {
        self.name = name
        self.serviceType = serviceType
    }
    
    func addStation(station: Station) {
        self.stations.append(station)
        station.lines.append(self)
        //if station.isLineEnd && !lineEnds.contains(where: station) {
            self.lineEnds.append(station)
        //}
    }*/
}
