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
        
        // Delete previous lines.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Line")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let persistentStoreCoordinator = getPersistentStoreCoordinator() else {
            return
        }
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: managedContext)
        } catch {
            print(error.localizedDescription)
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
        // Delete previous stations.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let persistentStoreCoordinator = getPersistentStoreCoordinator() else {
            return
        }
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: managedContext)
        } catch {
            print(error.localizedDescription)
        }
        
        storedStations = []
        let stations: [[String : Any]] = [
            ["name": "Observatorio", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tacubaya"]],
            ["name": "Tacubaya", "lines": ["1", "7", "9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Juanacatlán", "Constituyentes", "Patriotismo"]],["name": "Juanacatlán", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Chapultepec"]],
            ["name": "Chapultepec", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Sevilla"]],
            ["name": "Sevilla", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Insurgentes"]],
            ["name": "Insurgentes", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Cuauhtémoc"]],
            ["name": "Cuauhtémoc", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Balderas"]],
            ["name": "Balderas", "lines": ["1", "3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Salto del Agua", "Juárez"]],
            ["name": "Salto del Agua", "lines": ["1", "8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Isabel la Católica", "San Juan de Letrán"]],
            ["name": "Isabel la Católica", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Pino Suárez"]],
            ["name": "Pino Suárez", "lines": ["1", "2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Zócalo", "Merced", "San Antonio Abad"]],
            ["name": "Merced", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Candelaria"]],
            ["name": "Candelaria", "lines": ["1", "4"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["San Lázaro", "Morelos"]],
            ["name": "San Lázaro", "lines": ["1", "B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Moctezuma", "Flores Magón"]],
            ["name": "Moctezuma", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Balbuena"]],
            ["name": "Balbuena", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Boulevard Pto. Aéreo"]],
            ["name": "Boulevard Pto. Aéreo", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Gómez Farías"]],
            ["name": "Gómez Farías", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Zaragoza"]],
            ["name": "Zaragoza", "lines": ["1"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Pantitlán"]],
            ["name": "Pantitlán", "lines": ["1", "5", "9", "A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Hangares", "Agrícola Oriental"]],
            ["name": "Taxqueña", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["General Anaya"]],
            ["name": "General Anaya", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Ermita"]],
            ["name": "Ermita", "lines": ["2", "12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Portales", "Mexicaltzingo"]],
            ["name": "Portales", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Nativitas"]],
            ["name": "Nativitas", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Villa de Cortés"]],
            ["name": "Villa de Cortés", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Xola"]],
            ["name": "Xola", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Viaducto"]],
            ["name": "Viaducto", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Chabacano"]],
            ["name": "Chabacano", "lines": ["2", "8", "9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["San Antonio Abad", "Obrera", "Jamaica"]],
            ["name": "San Antonio Abad", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Pino Suárez"]],
            ["name": "Zócalo", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Allende"]],
            ["name": "Allende", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Bellas Artes"]],
            ["name": "Bellas Artes", "lines": ["2", "8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Hidalgo", "Garibaldi"]],
            ["name": "Hidalgo", "lines": ["2", "3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Revolución", "Guerrero"]],
            ["name": "Revolución", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["San Cosme"]],
            ["name": "San Cosme", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Normal"]],
            ["name": "Normal", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Colegio Militar"]],
            ["name": "Colegio Militar", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Popotla"]],
            ["name": "Popotla", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Cuitláhuac"]],
            ["name": "Cuitláhuac", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tacuba"]],
            ["name": "Tacuba", "lines": ["2", "7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Panteones", "Refinería"]],
            ["name": "Panteones", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Cuatro Caminos"]],
            ["name": "Cuatro Caminos", "lines": ["2"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": []],
            ["name": "Universidad", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Copilco"]],
            ["name": "Copilco", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Miguel Ángel de Quevedo"]],
            ["name": "Miguel Ángel de Quevedo", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Viveros/Derechos Humanos"]],
            ["name": "Viveros/Derechos Humanos", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Coyoacán"]],
            ["name": "Coyoacán", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Zapata"]],
            ["name": "Zapata", "lines": ["3", "12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["División del Norte", "Parque de los Venados"]],
            ["name": "División del Norte", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Eugenia"]],
            ["name": "Eugenia", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Etiopía/Plaza de la Transparencia"]],
            ["name": "Etiopía/Plaza de la Transparencia", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Centro Médico"]],
            ["name": "Centro Médico", "lines": ["3", "9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Hospital General", "Lázaro Cárdenas"]],
            ["name": "Hospital General", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Niños Héroes"]],
            ["name": "Niños Héroes", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Balderas"]],
            ["name": "Juárez", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Hidalgo"]],
            ["name": "Guerrero", "lines": ["3", "B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tlatelolco", "Garibaldi"]],
            ["name": "Tlatelolco", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["La Raza"]],
            ["name": "La Raza", "lines": ["3", "5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Potrero", "Autobuses del Norte"]],
            ["name": "Potrero", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Deportivo 18 de Marzo"]],
            ["name": "Deportivo 18 de Marzo", "lines": ["3", "6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Indios Verdes", "Lindavista"]],
            ["name": "Indios Verdes", "lines": ["3"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": []],
            ["name": "Santa Anita", "lines": ["4", "8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Jamaica", "La Viga"]],
            ["name": "Jamaica", "lines": ["4", "9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Fray Servando", "Mixiuhca"]],
            ["name": "Fray Servando", "lines": ["4"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Candelaria"]],
            ["name": "Morelos", "lines": ["4", "B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Canal del Norte", "San Lázaro"]],
            ["name": "Canal del Norte", "lines": ["4"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Consulado"]],
            ["name": "Consulado", "lines": ["4", "5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Bondojito", "Valle Gómez"]],
            ["name": "Bondojito", "lines": ["4"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Talismán"]],
            ["name": "Talismán", "lines": ["4"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Martín Carrera"]],
            ["name": "Martín Carrera", "lines": ["4", "6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["La Villa-Basílica"]],
            ["name": "Hangares", "lines": ["5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Terminal Aérea"]],
            ["name": "Terminal Aérea", "lines": ["5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Oceanía"]],
            ["name": "Oceanía", "lines": ["5", "B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Aragón", "Deportivo Oceanía"]],
            ["name": "Aragón", "lines": ["5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Eduardo Molina"]],
            ["name": "Eduardo Molina", "lines": ["5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Consulado"]],
            ["name": "Valle Gómez", "lines": ["5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Misterios"]],
            ["name": "Misterios", "lines": ["5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["La Raza"]],
            ["name": "Autobuses del Norte", "lines": ["5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Instituto del Petróleo"]],
            ["name": "Instituto del Petróleo", "lines": ["5", "6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Politécnico", "Vallejo"]],
            ["name": "Politécnico", "lines": ["5"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": []],
            ["name": "La Villa-Basílica", "lines": ["6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Deportivo 18 de Marzo"]],
            ["name": "Lindavista", "lines": ["6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Instituto del Petróleo"]],
            ["name": "Vallejo", "lines": ["6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Norte 45"]],
            ["name": "Norte 45", "lines": ["6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Ferrería/Arena Ciudad de México"]],
            ["name": "Ferrería/Arena Ciudad de México", "lines": ["6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Azcapotzalco"]],
            ["name": "Azcapotzalco", "lines": ["6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tezozómoc"]],
            ["name": "Tezozómoc", "lines": ["6"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["El Rosario"]],
            ["name": "El Rosario", "lines": ["6", "7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": []],
            ["name": "Barranca del Muerto", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Mixcoac"]],
            ["name": "Mixcoac", "lines": ["7", "12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["San Antonio", "Insurgentes Sur"]],
            ["name": "San Antonio", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["San Pedro de los Pinos"]],
            ["name": "San Pedro de los Pinos", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tacubaya"]],
            ["name": "Constituyentes", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Auditorio"]],
            ["name": "Auditorio", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Polanco"]],
            ["name": "Polanco", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["San Joaquín"]],
            ["name": "San Joaquín", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tacuba"]],
            ["name": "Refinería", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Camarones"]],
            ["name": "Camarones", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Aquiles Serdán"]],
            ["name": "Aquiles Serdán", "lines": ["7"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["El Rosario"]],
            ["name": "Const. de 1917", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["UAM-I"]],
            ["name": "UAM-I", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Cerro de la Estrella"]],
            ["name": "Cerro de la Estrella", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Iztapalapa"]],
            ["name": "Iztapalapa", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Atlalilco"]],
            ["name": "Atlalilco", "lines": ["8", "12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Escuadrón 201", "Culhuacán"]],
            ["name": "Escuadrón 201", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Aculco"]],
            ["name": "Aculco", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Apatlaco"]],
            ["name": "Apatlaco", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Iztacalco"]],
            ["name": "Iztacalco", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Coyuya"]],
            ["name": "Coyuya", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Santa Anita"]],
            ["name": "La Viga", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Chabacano"]],
            ["name": "Obrera", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Doctores"]],
            ["name": "Doctores", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Salto del Agua"]],
            ["name": "San Juan de Letrán", "lines": ["8"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Bellas Artes"]],
            ["name": "Garibaldi", "lines": ["8", "B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Lagunilla"]],
            ["name": "Patriotismo", "lines": ["9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Chilpancingo"]],
            ["name": "Chilpancingo", "lines": ["9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Centro Médico"]],
            ["name": "Lázaro Cárdenas", "lines": ["9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Chabacano"]],
            ["name": "Mixiuhca", "lines": ["9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Velódromo"]],
            ["name": "Velódromo", "lines": ["9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Ciudad Deportiva"]],
            ["name": "Ciudad Deportiva", "lines": ["9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Puebla"]],
            ["name": "Puebla", "lines": ["9"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Pantitlán"]],
            ["name": "Agrícola Oriental", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Canal de San Juan"]],
            ["name": "Canal de San Juan", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tepalcates"]],
            ["name": "Tepalcates", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Guelatao"]],
            ["name": "Guelatao", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Peñón Viejo"]],
            ["name": "Peñón Viejo", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Acatitla"]],
            ["name": "Acatitla", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Santa Marta"]],
            ["name": "Santa Marta", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Los Reyes"]],
            ["name": "Los Reyes", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["La Paz"]],
            ["name": "La Paz", "lines": ["A"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": []],
            ["name": "Buenavista", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Guerrero"]],
            ["name": "Lagunilla", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tepito"]],
            ["name": "Tepito", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Morelos"]],
            ["name": "Flores Magón", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Romero Rubio"]],
            ["name": "Romero Rubio", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Oceanía"]],
            ["name": "Deportivo Oceanía", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Bosque de Aragón"]],
            ["name": "Bosque de Aragón", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Villa de Aragón"]],
            ["name": "Villa de Aragón", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Nezahualcóyotl"]],
            ["name": "Nezahualcóyotl", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Impulsora"]],
            ["name": "Impulsora", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Río de los Remedios"]],
            ["name": "Río de los Remedios", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Múzquiz"]],
            ["name": "Múzquiz", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Ecatepec"]],
            ["name": "Ecatepec", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Olímpica"]],
            ["name": "Olímpica", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Plaza Aragón"]],
            ["name": "Plaza Aragón", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Ciudad Azteca"]],
            ["name": "Ciudad Azteca", "lines": ["B"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": []],
            ["name": "Insurgentes Sur", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Hospital 20 de Noviembre"]],
            ["name": "Hospital 20 de Noviembre", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Zapata"]],
            ["name": "Parque de los Venados", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Eje Central"]],
            ["name": "Eje Central", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Ermita"]],
            ["name": "Mexicaltzingo", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Atlalilco"]],
            ["name": "Culhuacán", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["San Andrés Tomatlán"]],
            ["name": "San Andrés Tomatlán", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Lomas Estrella"]],
            ["name": "Lomas Estrella", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Calle 11"]],
            ["name": "Calle 11", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Periférico Oriente"]],
            ["name": "Periférico Oriente", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tezonco"]],
            ["name": "Tezonco", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Olivos"]],
            ["name": "Olivos", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Nopalera"]],
            ["name": "Nopalera", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Zapotitlán"]],
            ["name": "Zapotitlán", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tlaltenco"]],
            ["name": "Tlaltenco", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": ["Tláhuac"]],
            ["name": "Tláhuac", "lines": ["12"], "status": 0, "isLineEnd": false, "hasRestroom": false, "hasComputers": false, "hasPOI": false, "routes": []]
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
     */
    static func getLastSessionFromToStations() -> (Station?, Station?) {
        guard let session = getLastSession() else {
            return (nil, nil)
        }
        return (session.fromStation, session.toStation)
    }
    
    /**
     Get the last session recent stations.
     
     - returns: An array of stations.
     */
    static func getLastSessionRecentStations(for direction: PickerButton.Direction) -> [Station]? {
        guard let session = getLastSession() else {
            return nil
        }
        guard let recents = (direction == .from ? session.fromRecents?.array : session.toRecents?.array) as? [Station] else {
            return nil
        }
        return recents
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
    
    static func addToRecentStations(station: Station, with direction: PickerButton.Direction) {
        guard let managedContext = getContext() else {
            return
        }
        guard let session = getLastSession() else {
            return
        }
        let currentRecents = direction == .from ? session.fromRecents : session.toRecents
        let maximumAllowedRecents = Constant.CoreData.maximumNumberOfRecents
        if (currentRecents?.count ?? 0) >= maximumAllowedRecents, let currentRecents = currentRecents {
            let mutableCurrentRecents = NSMutableOrderedSet(orderedSet: currentRecents)
            if currentRecents.count > maximumAllowedRecents {
                mutableCurrentRecents.removeAllObjects()
            } else if currentRecents.count == maximumAllowedRecents {
                mutableCurrentRecents.removeObject(at: currentRecents.count - 1)
            }
            if direction == .from {
                session.fromRecents = mutableCurrentRecents
            } else if direction == .to {
                session.toRecents = mutableCurrentRecents
            }
        }
        if !(currentRecents?.contains(station) ?? true) {
            if direction == .from {
                session.insertIntoFromRecents(station, at: 0)
            } else if direction == .to {
                session.insertIntoToRecents(station, at: 0)
            }
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
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
    
    static func fetchStation(with name: String) -> Station? {
        guard let managedContext = getContext() else {
            return nil
        }
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        fetchRequest.predicate = predicate
        guard let stations = try? managedContext.fetch(fetchRequest) as? [Station] else {
            return nil
        }
        return stations?.first
    }
    
    static func fetchStations(with route: [String]?) -> [Station]? {
        guard let route = route else {
            return nil
        }
        var stations: [Station] = []
        for i in 0 ..< route.count {
            if let currentStation = CoreDataTools.fetchStation(with: route[i]) {
                stations.append(currentStation)
            }
        }
        return stations
    }

}
