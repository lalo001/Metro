//
//  InterfaceController.swift
//  Metro WatchKit Extension
//
//  Created by Eduardo Valencia on 3/30/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var tableView: WKInterfaceTable!
    var events: [[String : Any]] = []
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        createTable()
    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            session = WCSession.default()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.pushController(withName: "showDetail", context: events[rowIndex])
        
    }
    
    // MARK: - TableView Functions
    
    func createTable() {
        tableView.setNumberOfRows(events.count, withRowType: "EventRow")
        for i in 0 ..< events.count {
            if let row = tableView.rowController(at: i) as? EventRow {
                row.eventName.setText(events[i]["name"] as? String ?? "")
            }
        }
    }
    
    @IBAction func reloadTable() {
        createTable()
        getEventsFromiPhone(session: session)
    }
    
    // MARK: - WCSessionDelegate Functions
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(activationState)
        if let error = error {
            print(error.localizedDescription)
        } else {
            getEventsFromiPhone(session: session)
        }
    }
    
    func getEventsFromiPhone(session: WCSession?) {
        session?.sendMessage([ : ], replyHandler: {[weak self]
            (response) -> Void in
            if let events = response["eventsData"] as? [[String : Any]] {
                self?.events = events
                self?.createTable()
            }
            }, errorHandler: { (error) -> Void in
                print("Error: \(error.localizedDescription)")
        })
    }
}
