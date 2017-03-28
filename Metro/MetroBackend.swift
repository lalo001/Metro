//
//  MetroBackend.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/27/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class MetroBackend: NSObject {
    
    static let mainUrl = "https://metro.hyuchia.mx/"
    
    static func getEvents(completion: @escaping (([[String : Any]]?, Error?) -> Void)) {
        
        // Create URL
        guard let url = URL(string: mainUrl + "events") else {
            let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("urlIsNil", comment: "")]
            let error = NSError(domain: "InvalidURL", code: 1, userInfo: userInfo)
            completion(nil, error)
            return
        }
        
        // Create session
        let session = URLSession.shared
        
        // Create and configure request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create task
        let task = session.dataTask(with: url, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print("Task error: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                // Check the response
                guard let httpResponse = response as? HTTPURLResponse else {
                    let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("httpResponseIsNil", comment: "")]
                    let error = NSError(domain: "InvalidHTTPResponse", code: 1, userInfo: userInfo)
                    completion(nil, error)
                    return
                }
                
                let statusCode = httpResponse.statusCode
                print(statusCode)
                switch statusCode {
                case 200:
                    guard let data = data else {
                        let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("dataIsNil", comment: "")]
                        let error = NSError(domain: "InvalidData", code: 1, userInfo: userInfo)
                        completion(nil, error)
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]]
                        completion(json, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                    break
                case 404:
                    break
                case 500:
                    break
                default:
                    break
                }
            }
        })
        
        task.resume() // Execute task
    }
}
