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
    
    func getContext() -> NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }

}
