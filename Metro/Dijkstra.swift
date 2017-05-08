//
//  Dijkstra.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/7/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class Vertex: NSObject {
    let name: String
    var id: String
    var edges: [Vertex]
    var parent: Vertex?
    
    init(name: String) {
        self.name = name.capitalized
        self.id = name.capitalized
        self.edges = []
    }
    
    func isEqual(other: Vertex) -> Bool {
        return id == other.id
    }
    
    
}

class Graph {
    
    var vertexList: [Vertex] = []
    
    func addVertex(vertex: Vertex) {
        self.vertexList.append (vertex)
    }
    
    func getVertex(id: String) -> Vertex? {
        for vertex in self.vertexList {
            if vertex.name.capitalized == id.capitalized {
                return vertex
            }
        }
        return nil
    }
    
    func add(destination: Vertex, source: inout Vertex) {
        source.edges.append(destination)
    }
    
    func shortestPath(from origin: Vertex, to destination: Vertex) -> [String] {
        var visited = [Vertex]()
        var frontier = [Vertex]()
        visited.append(origin)
        
        frontier.append(origin)
        
        var i = 0
        while frontier.count > 0 {
            let current: Vertex = frontier.remove(at:0)
            if current == destination {
                visited.append(current)
                break
            } else {
                for edge in current.edges {
                    if !visited.contains(edge) {
                        visited.append(edge)
                        edge.parent = current
                        frontier.append(edge)
                    }
                    
                }
            }
            i = i + 1
        }
        var shortestPath: [String] = []
        var parent = visited.last
        while parent != nil {
            if let id = parent?.id {
                shortestPath.append(id)
            }
            parent = parent?.parent
        }
        return shortestPath
    }
}

class Dijkstra {
    
    static var routes: [String:[String]] = [
        
        // Linea 1
        "Observatorio": ["Tacubaya"],
        "Tacubaya": ["Juanacatlán","Constituyentes","Patriotismo"],
        "Juanacatlán": ["Chapultepec"],
        "Chapultepec": ["Sevilla"],
        "Sevilla": ["Insurgentes"],
        "Insurgentes": ["Cuauhtémoc"],
        "Cuauhtémoc": ["Balderas"],
        "Balderas": ["Salto del Agua","Juárez"],
        "Salto del Agua": ["Isabel la Católica","San Juan de Letrán"],
        "Isabel la Católica": ["Pino Suárez"],
        
        "Pino Suárez": ["Zócalo","Merced","San Antonio Abad"],
        "Merced": ["Candelaria"],
        "Candelaria": ["San Lázaro","Morelos"],
        "San Lázaro": ["Moctezuma","Flores Magón"],
        "Moctezuma": ["Balbuena"],
        "Balbuena": ["Boulevard Pto. Aéreo"],
        "Boulevard Pto. Aéreo": ["Gómez Farías"],
        "Gómez Farías": ["Zaragoza"],
        "Zaragoza": ["Pantitlán"],
        "Pantitlán": ["Hangares","Agrícola Oriental"],
        
        // Linea 2
        "Taxqueña": ["General Anaya"],
        "General Anaya": ["Ermita"],
        "Ermita":["Portales","Mexicaltzingo"],
        "Portales": ["Nativitas"],
        "Nativitas": ["Villa de Cortés"],
        
        "Villa de Cortés": ["Xola"],
        "Xola": ["Viaducto"],
        "Viaducto": ["Chabacano"],
        "Chabacano": ["San Antonio Abad","Obrera","Jamaica"],
        
        "San Antonio Abad": ["Pino Suárez"],
        "Zócalo": ["Allende"],
        "Allende": ["Bellas Artes"],
        "Bellas Artes": ["Hidalgo","Garibaldi"],
        "Hidalgo": ["Revolución","Guerrero"],
        "Revolución": ["San Cosme"],
        "San Cosme": ["Normal"],
        "Normal": ["Colegio Militar"],
        "Colegio Militar": ["Popotla"],
        "Popotla": ["Cuitláhuac"],
        "Cuitláhuac": ["Tacuba"],
        "Tacuba": ["Panteones","Refinería"],
        "Panteones": ["Cuatro Caminos"],
        "Cuatro Caminos": [],
        
        // Linea 3
        "Universidad": ["Copilco"],
        "Copilco": ["Miguel Ángel de Quevedo"],
        "Miguel Ángel de Quevedo": ["Viveros/Derechos Humanos"],
        "Viveros/Derechos Humanos": ["Coyoacán"],
        "Coyoacán": ["Zapata"],
        "Zapata": ["División del Norte","Parque de los Venados"],
        "División del Norte": ["Eugenia"],
        "Eugenia": ["Etiopía/Plaza de la Transparencia"],
        "Etiopía/Plaza de la Transparencia": ["Centro Médico"],
        "Centro Médico": ["Hospital General","Lázaro Cárdenas"],
        "Hospital General": ["Niños Héroes"],
        "Niños Héroes": ["Balderas"],
        "Juárez": ["Hidalgo"],
        "Guerrero": ["Tlatelolco","Garibaldi"],
        "Tlatelolco": ["La Raza"],
        "La Raza": ["Potrero","Autobuses del Norte"],
        "Potrero": ["Deportivo 18 de Marzo"],
        "Deportivo 18 de Marzo": ["Indios Verdes","Lindavista"],
        "Indios Verdes": [],
        
        // Linea 4
        "Santa Anita": ["Jamaica","La Viga"],
        "Jamaica": ["Fray Servando","Mixiuhca"],
        "Fray Servando": ["Candelaria"],
        "Morelos": ["Canal del Norte","San Lázaro"],
        "Canal del Norte": ["Consulado"],
        "Consulado": ["Bondojito","Valle Gómez"],
        "Bondojito": ["Talismán"],
        "Talismán": ["Martín Carrera"],
        "Martín Carrera": ["La Villa-Basílica"],
        
        // Linea 5
        "Hangares": ["Terminal Aérea"],
        "Terminal Aérea": ["Oceanía"],
        "Oceanía": ["Aragón","Deportivo Oceanía"],
        "Aragón": ["Eduardo Molina"],
        "Eduardo Molina": ["Consulado"],
        "Valle Gómez": ["Misterios"],
        "Misterios": ["La Raza"],
        "Autobuses del Norte": ["Instituto del Petróleo"],
        "Instituto del Petróleo": ["Politécnico","Vallejo"],
        "Politécnico": [],
        
        // Linea 6
        "La Villa-Basílica": ["Deportivo 18 de Marzo"],
        "Lindavista": ["Instituto del Petróleo"],
        "Vallejo": ["Norte 45"],
        "Norte 45": ["Ferrería/Arena Ciudad de México"],
        "Ferrería/Arena Ciudad de México": ["Azcapotzalco"],
        "Azcapotzalco": ["Tezozómoc"],
        "Tezozómoc": ["El Rosario"],
        "El Rosario": [],
        
        //Linea 7
        "Barranca del Muerto": ["Mixcoac"],
        "Mixcoac": ["San Antonio","Insurgentes Sur"],
        "San Antonio": ["San Pedro de los Pinos"],
        "San Pedro de los Pinos": ["Tacubaya"],
        "Constituyentes": ["Auditorio"],
        "Auditorio": ["Polanco"],
        "Polanco": ["San Joaquín"],
        "San Joaquín": ["Tacuba"],
        "Refinería": ["Camarones"],
        "Camarones": ["Aquiles Serdán"],
        "Aquiles Serdán": ["El Rosario"],
        
        // Linea 8
        "Const. de 1917": ["UAM-I"],
        "UAM-I": ["Cerro de la Estrella"],
        "Cerro de la Estrella": ["Iztapalapa"],
        "Iztapalapa": ["Atlalilco"],
        "Atlalilco": ["Escuadrón 201","Culhuacán"],
        "Escuadrón 201": ["Aculco"],
        "Aculco": ["Apatlaco"],
        "Apatlaco": ["Iztacalco"],
        "Iztacalco": ["Coyuya"],
        "Coyuya": ["Santa Anita"],
        "La Viga": ["Chabacano"],
        "Obrera": ["Doctores"],
        "Doctores": ["Salto del Agua"],
        "San Juan de Letrán": ["Bellas Artes"],
        "Garibaldi": ["Lagunilla"],
        
        // Linea 9
        "Patriotismo": ["Chilpancingo"],
        "Chilpancingo": ["Centro Médico"],
        "Lázaro Cárdenas": ["Chabacano"],
        "Mixiuhca": ["Velódromo"],
        "Velódromo": ["Ciudad Deportiva"],
        "Ciudad Deportiva": ["Puebla"],
        "Puebla": ["Pantitlán"],
        
        // Linea A
        "Agrícola Oriental": ["Canal de San Juan"],
        "Canal de San Juan": ["Tepalcates"],
        "Tepalcates": ["Guelatao"],
        "Guelatao": ["Peñón Viejo"],
        "Peñón Viejo": ["Acatitla"],
        "Acatitla": ["Santa Marta"],
        "Santa Marta": ["Los Reyes"],
        "Los Reyes": ["La Paz"],
        "La Paz": [],
        
        // Linea B
        "Buenavista": ["Guerrero"],
        "Lagunilla": ["Tepito"],
        "Tepito": ["Morelos"],
        "Flores Magón": ["Romero Rubio"],
        "Romero Rubio": ["Oceanía"],
        "Deportivo Oceanía": ["Bosque de Aragón"],
        "Bosque de Aragón": ["Villa de Aragón"],
        "Villa de Aragón": ["Nezahualcóyotl"],
        "Nezahualcóyotl": ["Impulsora"],
        "Impulsora": ["Río de los Remedios"],
        "Río de los Remedios": ["Múzquiz"],
        "Múzquiz": ["Ecatepec"],
        "Ecatepec": ["Olímpica"],
        "Olímpica": ["Plaza Aragón"],
        "Plaza Aragón": ["Ciudad Azteca"],
        "Ciudad Azteca": [],
        
        // Linea 12
        "Insurgentes Sur": ["Hospital 20 de Noviembre"],
        "Hospital 20 de Noviembre": ["Zapata"],
        "Parque de los Venados": ["Eje Central"],
        "Eje Central": ["Ermita"],
        "Mexicaltzingo": ["Atlalilco"],
        "Culhuacán": ["San Andrés Tomatlán"],
        "San Andrés Tomatlán": ["Lomas Estrella"],
        "Lomas Estrella": ["Calle 11"],
        "Calle 11": ["Periférico Oriente"],
        "Periférico Oriente": ["Tezonco"],
        "Tezonco": ["Olivos"],
        "Olivos": ["Nopalera"],
        "Nopalera": ["Zapotitlán"],
        "Zapotitlán": ["Tlaltenco"],
        "Tlaltenco": ["Tláhuac"],
        "Tláhuac": []
    ]
    
    static func prepareDijkstra(firstStation: String, secondStation: String) -> [String]? {
        let subway = Graph()
        for station in routes.keys {
            subway.addVertex(vertex:Vertex(name:station.capitalized))
        }
        
        for route in routes.keys {
            guard let currentRoute = routes[route], let routeVertex = subway.getVertex(id: route.capitalized) else {
                return nil
            }
            let stationDict = currentRoute
            var stationObject = routeVertex
            
            for neightbor in stationDict {
                guard let neighborVertex = subway.getVertex(id: neightbor.capitalized) else {
                    return nil
                }
                var neightborObject = neighborVertex
                subway.add(
                    destination: neightborObject,
                    source: &stationObject
                )
                
                subway.add(
                    destination: stationObject,
                    source: &neightborObject
                )
            }
        }
        return executeDijkstra(with: subway, firstStation: firstStation, secondStation: secondStation)?.reversed()
    }
    
    static func executeDijkstra(with subway: Graph, firstStation: String, secondStation: String) -> [String]? {
        guard let firstVertex = subway.getVertex(id: firstStation), let secondVertex = subway.getVertex(id: secondStation) else {
            return nil
        }
        return subway.shortestPath(from: firstVertex, to: secondVertex)
    }

}

//subway.shortestPath(from: subway.getVertex(id: "Polanco")!, to: subway.getVertex(id: "Ciudad Azteca")!)
