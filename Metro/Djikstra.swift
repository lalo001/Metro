//
//  Djikstra.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/30/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit


class Vertex: NSObject {
    let name: String
    var id: String
    var edges: [Vertex]
    var parent: Vertex?
    
    init(name: String) {
        self.name = name
        self.id = name
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
            if vertex.name == id {
                return vertex
            }
        }
        return nil
    }
    
    func add(destination: Vertex, source: inout Vertex) {
        source.edges.append(destination)
    }
    
    func shortestPath(from origin: Vertex, to destination: Vertex) {
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
        
        var parent = visited.last
        while parent != nil {
            print("\(parent!.id)")
            parent = parent!.parent
        }
    }
}

var subway = Graph()


var routes: [[String : Any]] = [
    // Linea 1
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


/*
for station in routes.keys {
    subway.addVertex(vertex:Vertex(name:station))
}


for route in routes.keys {
    var stationDict = routes[route]!
    var stationObject = subway.getVertex(id: route)!
    
    for neightbor in stationDict {
        var neightborObject =  subway.getVertex(id: neightbor)!
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

subway.shortestPath(from: subway.getVertex(id: "Polanco")!, to: subway.getVertex(id: "Ciudad Azteca")!)*/


