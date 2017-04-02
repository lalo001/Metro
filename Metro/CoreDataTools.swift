//
//  CoreDataTools.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/22/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTools: NSObject {
    
    /// Lines stored in Core Data.
    static var storedLines: [Line]?
    
    /// Stations stored in Core Data.
    static var storedStations: [Station]?
    
    /// Events stored in Core Data.
    static var storedEvents: [MetroEvent]?
    
    /// Stations stored in Core Data that have coordinates.
    static var storedStationsWithCoordinates: [Station]?
    
    // MARK: - Create Functions
    
    /**
     Create and store on Core Data all the lines used by the app.
     */
    static func createLines() {
        guard let managedContext = getContext() else {
            return
        }
        
        storedLines = []
        let lines: [[String : Any]] = [
            ["name" : "1", "type" : 0, "colors" : [4]],
            ["name" : "2", "type" : 0, "colors" : [5]],
            ["name" : "3", "type" : 0, "colors" : [6]],
            ["name" : "4", "type" : 0, "colors" : [7]],
            ["name" : "5", "type" : 0, "colors" : [8]],
            ["name" : "6", "type" : 0, "colors" : [9]],
            ["name" : "7", "type" : 0, "colors" : [10]],
            ["name" : "8", "type" : 0, "colors" : [11]],
            ["name" : "9", "type" : 0, "colors" : [12]],
            ["name" : "A", "type" : 0, "colors" : [13]],
            ["name" : "B", "type" : 0, "colors" : [14, 15]],
            ["name" : "12", "type" : 0, "colors" : [16]],
            ["name" : "TL", "type" : 1, "colors" : [17]],
            ["name" : "S", "type" : 2, "colors" : [18]]
        ]
        for i in 0 ..< lines.count {
            let currentName: String = lines[i]["name"] as? String ?? ""
            let currentType: Line.ServiceType = Line.ServiceType(rawValue: lines[i]["type"] as? Int ?? 3) ?? .unknown
            let currentColorIndexes: [Int] = lines[i]["colors"] as? [Int] ?? []
            var currentColors: [UIColor] = []
            if currentColorIndexes.count <= 0 {
                currentColors = [.black]
            } else {
                for j in 0 ..< currentColorIndexes.count {
                    currentColors.append(Tools.colorPicker(currentColorIndexes[j], alpha: 1))
                }
            }
            let currentLine = Line(name: currentName, serviceType: currentType, order: i, context: managedContext)
            currentLine.colors = currentColors
            storedLines?.append(currentLine)
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /**
     Store Metro Events acquired from the API in Core Data.
     
     - parameters:
     - events: An array of dictionaries containing the events with its required attributes.
     - warning: All previously stored events will be deleted and replaced with the events passed to this function.
     */
    static func createMetroEvents(events: [[String : Any]]) {
        guard let managedContext = getContext() else {
            return
        }
        storedEvents = []
        
        // Delete previous events.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MetroEvent")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let persistentStoreCoordinator = getPersistentStoreCoordinator() else {
            return
        }
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: managedContext)
        } catch {
            print(error.localizedDescription)
        }
        
        for i in 0 ..< events.count {
            let currentName = events[i]["Name"] as? String ?? ""
            let currentCategory = events[i]["Category"] as? String ?? ""
            let currentImageURL = URL(string: events[i]["Image"] as? String ?? "")
            let currentDescription = events[i]["Description"] as? String ?? ""
            let currentDate = events[i]["Date"] as? String ?? ""
            let currentStartTime = events[i]["StartTime"] as? String ?? ""
            let currentEndTime = events[i]["EndTime"] as? String ?? ""
            let currentStationName = events[i]["Station"] as? String ?? ""
            let currentStation = storedStations?.first(where: {
                $0.name == currentStationName
            })
            let currentLineName = events[i]["Line"] as? String ?? ""
            let currentLine = storedLines?.first(where: {
                $0.name == currentLineName
            })
            let currentEvent = MetroEvent(name: currentName, category: currentCategory, imageURLString: currentImageURL?.absoluteString, eventDescription: currentDescription, date: currentDate, startTime: currentStartTime, endTime: currentEndTime, station: currentStation, line: currentLine, context: managedContext)
            storedEvents?.append(currentEvent)
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /**
     Create a new session object and store it in Core Data.
     - note: It can only exist one session at any given time. Calling this function after a session has been created will have no effect.
     */
    static func createSession() {
        guard let managedContext = getContext() else {
            return
        }
        if getLastSession() == nil {
            let _ = Session(entity: Session.entity(), insertInto: managedContext)
            do {
                try managedContext.save()
                print("Saved new session.")
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("A session already exists.")
        }
    }
    
    /**
     Create and store on Core Data all the stations used by the app. It also creates the neccessary relationships between stations and lines.
     */
    static func createStations() {
        guard let managedContext = getContext() else {
            return
        }
        
        storedStations = []
        let stations: [[String : Any]] = [
            // Linea 1
            ["name" : "Observatorio", "lines" : ["1"], "status" : 0, "isLineEnd" : true, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Tacubaya"]],
            ["name" : "Tacubaya", "lines" : ["1", "7", "9"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Juanacatlán", "Constituyentes", "Patriotismo"]],
            ["name" : "Juanacatlán", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Chapultepec"]],
            ["name" : "Chapultepec", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Sevilla"]],
            ["name" : "Sevilla", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Insurgentes"]],
            ["name" : "Insurgentes", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Cuauhtémoc"]],
            ["name" : "Cuauhtémoc", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Balderas"]],
            ["name" : "Balderas", "lines" : ["1", "3"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Salto del Agua", "Juárez"]],
            ["name" : "Salto del Agua", "lines" : ["1", "8"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Isabel la Católica", "San Juan de Letrán"]],
            ["name" : "Isabel la Católica", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Pino Suárez"]],
            ["name" : "Pino Suárez", "lines" : ["1", "2"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Zócalo", "Merced", "San Antonio Abad"]],
            ["name" : "Merced", "lines" : ["1", "2"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Candelaria"]],
            ["name" : "Candelaria", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["San Lázaro", "Morelos"]],
            ["name" : "San Lázaro", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Moctezuma", "Flores Magón"]],
            ["name" : "Moctezuma", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Balbuena"]],
            ["name" : "Balbuena", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Boulevard Puerto Aéreo"]],
            ["name" : "Boulevard Puerto Aéreo", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Gómez Farías"]],
            ["name" : "Gómez Farías", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Zaragoza"]],
            ["name" : "Zaragoza", "lines" : ["1"], "status" : 0, "isLineEnd" : false, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Pantitlán"]],
            ["name" : "Pantitlán", "lines" : ["1", "5", "9", "A"], "status" : 0, "isLineEnd" : true, "hasRestroom" : false, "hasComputers" : false, "hasPOI" : false, "routes" : ["Hangares", "Agrícola Oriental"]]
        ]
        
        for i in 0 ..< stations.count {
            let currentName = stations[i]["name"] as? String ?? ""
            let currentStatus = Station.Status(rawValue: (stations[i]["status"] as? Int ?? 0)) ?? .open
            let isLineEnd = stations[i]["isLineEnd"] as? Bool ?? false
            let hasRestroom = stations[i]["hasRestroom"] as? Bool ?? false
            let hasComputers = stations[i]["hasComputers"] as? Bool ?? false
            let hasPOI = stations[i]["hasPOI"] as? Bool ?? false
            let currentStation = Station(name: currentName, status: currentStatus, isLineEnd: isLineEnd, hasRestroom: hasRestroom, hasComputers: hasComputers, hasPOI: hasPOI, context: managedContext)
            let lines: [String] = stations[i]["lines"] as? [String] ?? []
            for j in 0 ..< lines.count {
                guard let storedLines = storedLines else {
                    break
                }
                let currentLine = storedLines.filter({
                    $0.name == lines[j]
                }).first
                if let currentLine = currentLine {
                    currentStation.addToLines(currentLine)
                }
            }
            storedStations?.append(currentStation)
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: Get Functions
    
    /**
     Get the current managed context for Core Data's persistent container.
     
     - returns: A [NSManagedObjectContext](apple-reference-documentation://hseREZ0QHW) object.
    */
    static func getContext() -> NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }
    
    /**
     Get the session that is currently stored in Core Data.
     
     - returns: If a session exists, it returns a Session object.
     */
    static func getLastSession() -> Session? {
        guard let managedContext = getContext() else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        do {
            guard let results: Session  = try managedContext.fetch(fetchRequest).first as? Session else {
                return nil
            }
            return results
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    /**
     Get the from-station and to-station selected on Search Route Controller during the user's last session.
     
     - returns: A tuple of the form (toStation, fromStation).
     - note: Both elements will always either exist or be nil.
     */
    static func getLastSessionFromToStations() -> (Station?, Station?) {
        guard let session = getLastSession() else {
            return (nil, nil)
        }
        guard let fromStation = session.fromStation, let toStation = session.toStation else {
            return (nil, nil)
        }
        return (fromStation, toStation)
    }
    
    /**
     Get the current Core Data's persistent store coordinator.
     
     - returns: A [NSPersistentStoreCoordinator](apple-reference-documentation://hsRdlxSPjF) object.
     */
    static func getPersistentStoreCoordinator() -> NSPersistentStoreCoordinator? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.persistentStoreCoordinator
        }
        return nil
    }
    
    /**
     Get from the API the coordinates for each station and fill and array with the stations that do have a corresponding coordinate.
     */
    static func getStationsCoordinates() {
        guard let managedContext = getContext() else {
            return
        }
        storedStationsWithCoordinates = []
        MetroBackend.getCoordinates(completion: {(stations, error) -> Void in
            if error == nil && stations != nil {
                guard let keys = stations?.keys else {
                    return
                }
                for currentKey in keys {
                    let currentLine = storedLines?.first(where: {
                        $0.name == currentKey
                    })
                    guard let currentStations = currentLine?.stations?.allObjects as? [Station], let currentStationsCoordinates = stations?[currentKey] as? [[String : Any]] else {
                        print("Continue first")
                        continue
                    }
                    for i in 0 ..< currentStationsCoordinates.count {
                        let currentName = currentStationsCoordinates[i]["title"] as? String ?? ""
                        guard let currentStation = currentStations.first(where: {
                            $0.name == currentName
                        }) else {
                            continue
                        }
                        guard let latlng = currentStationsCoordinates[i]["latlng"] as? [String : Float] else {
                            continue
                        }
                        guard let currentLatitude = latlng["latitude"], let currentLongitude = latlng["longitude"] else {
                            print("Continue")
                            continue
                        }
                        currentStation.latitude = currentLatitude
                        currentStation.longitude = currentLongitude
                        storedStationsWithCoordinates?.append(currentStation)
                    }
                }
                do {
                    try managedContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        })
    }
    
    /**
     Update the attributes of the session stored in Core Data.
     
     - parameters:
        - lastUpdateDate: The date in which the stations and lines were last updated on.
        - fromStation: The most recent from-station selected by the user on Search Route Controller.
        - toStation: The most recent to-station selected by the user on Search Route Controller.
     - note: Parameters left nil will not be updated.
     */
    static func updateSession(lastUpdateDate: Date?, fromStation: Station?, toStation: Station?) {
        guard let managedContext = getContext() else {
            return
        }
        guard let session = getLastSession() else {
            return
        }
        if let lastUpdateDate = lastUpdateDate {
            session.lastUpdateDate = lastUpdateDate as NSDate
        }
        if let fromStation = fromStation {
            session.fromStation = fromStation
            fromStation.lastSessionFromStation = session
        }
        if let toStation = toStation {
            session.toStation = toStation
            toStation.lastSessionToStation = session
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Fetch Functions
    
    /**
     Cache all the data stored on Core Data related with events, lines, and stations.
     */
    static func fetchData() {
        guard let managedContext = getContext() else {
            return
        }
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Line")
        guard let lines = try? managedContext.fetch(fetchRequest) as? [Line] else {
            return
        }
        storedLines = lines
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        guard let stations = try? managedContext.fetch(fetchRequest) as? [Station] else {
            return
        }
        storedStationsWithCoordinates = stations?.filter({
            $0.hasCoordinates
        })
        storedStations = stations
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MetroEvent")
        guard let events = try? managedContext.fetch(fetchRequest) as? [MetroEvent] else {
            return
        }
        storedEvents = events
    }

}
