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
    
    static var storedLines: [Line]?
    static var storedStations: [Station]?
    
    static func getContext() -> NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }
    
    static func getPersistentStoreCoordinator() -> NSPersistentStoreCoordinator? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.persistentStoreCoordinator
        }
        return nil
    }
    
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
    
    static func getLastSessionFromToStations() -> (Station?, Station?) {
        guard let session = getLastSession() else {
            return (nil, nil)
        }
        guard let fromStation = session.fromStation, let toStation = session.toStation else {
            return (nil, nil)
        }
        return (fromStation, toStation)
    }

    static func createLines() {
        guard let managedContext = getContext() else {
            return
        }
        
        // FIXME: Debug only. Delete all previous data.
        /*let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Line")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let persistentStoreCoordinator = getPersistentStoreCoordinator() else {
            return
        }
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: managedContext)
        } catch {
            print(error.localizedDescription)
        }*/
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
    
    static func createStations() {
        guard let managedContext = getContext() else {
            return
        }
        
        //FIXME: DELETE
        /*let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let persistentStoreCoordinator = getPersistentStoreCoordinator() else {
            return
        }
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: managedContext)
        } catch {
            print(error.localizedDescription)
        }*/
        
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

}
