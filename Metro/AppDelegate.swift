//
//  AppDelegate.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/19/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Check if there is a session stored. If not, create sessionm lines and stations.
        if CoreDataTools.getLastSession() == nil {
            CoreDataTools.createLines()
            CoreDataTools.createStations()
            CoreDataTools.createSession() // Create a new session.
        } else {
            // If there's a session fetch everything from Core Data.
            CoreDataTools.fetchData()
        }
        CoreDataTools.getStationsCoordinates() // Update coordinates of stations from API.
        
        // Init Watch Connectivity session if supported.
        if WCSession.isSupported() {
            session = WCSession.default()
        }
        
        // Update events from API.
        MetroBackend.getEvents(completion: {(events, error) -> Void in
            if error != nil && CoreDataTools.storedEvents == nil {
                CoreDataTools.storedEvents = []
            } else if error == nil {
                if let events = events {
                    CoreDataTools.createMetroEvents(events: events)
                }
            }
        })
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    static var storeName: String = "Metro"
    
    static var storeURL: URL {
        let storePaths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let storePath = storePaths[0] as String
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(
                atPath: storePath as String,
                withIntermediateDirectories: true,
                attributes: nil)
        } catch {
            print("Error creating storePath \(storePath): \(error)")
        }
        
        let sqliteFilePath = storePath.appending(storeName + ".sqlite")
        return URL(fileURLWithPath: sqliteFilePath)
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: storeName)
        let description = NSPersistentStoreDescription(url: storeURL)
        
        // Lightweight automatic migration
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print(error.localizedDescription)
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print(nserror.localizedDescription)
            }
        }
    }

}

extension AppDelegate: WCSessionDelegate {
    
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }

    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(activationState)
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    
    // Receive and reply message with Data from Apple Watch.
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        let urlString = String(data: messageData, encoding: .utf8) ?? ""
        if let imageURL = URL(string: urlString) {
            if let imageData = try? Data(contentsOf: imageURL) {
                replyHandler(imageData)
            }
        }
        replyHandler(Data())
    }

    // Receive and reply message with [String : Any] from Apple Watch.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let events = CoreDataTools.storedEvents else {
            replyHandler(["error" : "No events"])
            return
        }
        var eventsDictionary: [[String : Any]] = []
        for i in 0 ..< events.count {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.string(from: events[i].date as Date? ?? Date())
            let currentDictionary = ["name" : events[i].name as Any, "imageURL" : events[i].imageURLString ?? "", "date" : date, "description" : events[i].eventDescription as Any]
            eventsDictionary.append(currentDictionary)
        }
        do {
            let json = try JSONSerialization.data(withJSONObject: eventsDictionary, options: .prettyPrinted)
            let decode = try JSONSerialization.jsonObject(with: json, options: .allowFragments)
            replyHandler(["eventsData" : decode])
        } catch {
            replyHandler(["error" : error.localizedDescription])
            print(error.localizedDescription)
        }
    }
}
