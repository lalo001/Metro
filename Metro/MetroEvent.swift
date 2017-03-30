//
//  MetroEvent.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/29/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import CoreData

public class MetroEvent: NSManagedObject {
    
    var image: UIImage? {
        guard let imageURLString = imageURLString else {
            return nil
        }
        guard let imageURL = URL(string: imageURLString) else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }
        guard let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }

    convenience init(name: String, category: String, imageURLString: String?, eventDescription: String, date: String, startTime: String, endTime: String, station: Station?, line: Line?, context: NSManagedObjectContext) {
        self.init(entity: MetroEvent.entity(), insertInto: context)
        self.name = name
        self.category = category
        self.imageURLString = imageURLString
        self.eventDescription = eventDescription
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.date(from: date) as NSDate? ?? Date(timeIntervalSince1970: 0)  as NSDate
        dateFormatter.dateFormat = "hh:mm:ss"
        self.startTime = dateFormatter.date(from: startTime) as NSDate? ?? Date(timeIntervalSince1970: 0) as NSDate
        self.endTime = dateFormatter.date(from: endTime) as NSDate? ?? Date(timeIntervalSince1970: 0) as NSDate
        self.station = station
        self.station?.addToEvents(self)
        self.line = line
        self.line?.addToEvents(self)
    }
}
