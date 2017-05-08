//
//  ComplicationController.swift
//  Metro WatchKit Extension
//
//  Created by Eduardo Valencia on 3/30/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import ClockKit
import WatchConnectivity


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let hour: TimeInterval = 60 * 60
    let minute: TimeInterval = 60
    var events: [[String: Any]]? = [["name" : "Grupo Cas-Ta", "date" : "15/05/2017", "startTime" : "9:00 AM", "endTime" : "11:00 AM", "station" : "San Lázaro"]]
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date(timeIntervalSinceNow: (60 * 60 * 24)))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularLarge:
            let modularLargeTemplate =
                CLKComplicationTemplateModularLargeStandardBody()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            let startDate = dateFormatter.date(from: events?[0]["startTime"] as? String ?? "")
            let endDate = dateFormatter.date(from: events?[0]["endTime"] as? String ?? "")
            modularLargeTemplate.headerTextProvider = CLKTimeIntervalTextProvider(start: startDate ?? Date(), end: endDate ?? Date())
            modularLargeTemplate.body1TextProvider =
                CLKSimpleTextProvider(text: events?[0]["name"] as? String ?? "",
                                      shortText: "Name")
            modularLargeTemplate.body2TextProvider =
                CLKSimpleTextProvider(text: events?[0]["station"] as? String ?? "",
                                      shortText: "Station")
            template = modularLargeTemplate
            if let template = template {
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(entry)
            } else {
                handler(nil)
            }
        default:
            template = nil
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularLarge:
            let modularLargeTemplate =
                CLKComplicationTemplateModularLargeStandardBody()
            modularLargeTemplate.headerTextProvider = CLKTimeIntervalTextProvider(start: Date(), end: Date(timeIntervalSinceNow: 1.5 * hour))
            modularLargeTemplate.body1TextProvider =
                CLKSimpleTextProvider(text: "Event Time",
                                      shortText: "Time")
            modularLargeTemplate.body2TextProvider =
                CLKSimpleTextProvider(text: "Event Name",
                                      shortText: "Name")
            template = modularLargeTemplate
        default:
            template = nil
        }
        handler(template)
    }
    
    // MARK: - WCSessionDelegate Functions
    
    func getEventsFromiPhone(session: WCSession?, completion: ((Bool) -> Void)?) {
        session?.sendMessage([ : ], replyHandler: {[weak self]
            (response) -> Void in
            if let events = response["eventsData"] as? [[String : Any]] {
                self?.events = events
                print(events)
                completion?(true)
            }
            }, errorHandler: { (error) -> Void in
                print("Error: \(error.localizedDescription)")
                completion?(true)
        })
    }
}
