//
//  EventDetailInterfaceController.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/30/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class EventDetailInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var date: WKInterfaceLabel!
    @IBOutlet var eventImage: WKInterfaceImage!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    var imageURL: String?
    
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
        guard let events = context as? [String : Any] else {
            return
        }
        titleLabel.setText(events["name"] as? String ?? "")
        date.setText(events["date"] as? String ?? "")
        imageURL = events["imageURL"] as? String ?? ""
        if let imageURL = URL(string: imageURL ?? "") {
            if let imageData = try? Data(contentsOf: imageURL) {
                let image = UIImage(data: imageData)
                eventImage.setImage(image)
            } else {
                // FIXME: Fallback to default image
            }
        }
        descriptionLabel.setText(events["description"] as? String ?? "")
        if WCSession.isSupported() {
            session = WCSession.default()
            if imageURL != nil {
                if let data = imageURL?.data(using: .utf8) {
                    session?.sendMessageData(data, replyHandler: {[weak self](data) -> Void in
                        if let image = UIImage(data: data) {
                            self?.eventImage.setImage(image)
                        }
                        }, errorHandler: {(error) -> Void in
                            print(error.localizedDescription)
                    })
                }
            }
            
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // MARK: - WCSessionDelegate Functions
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

        if let error = error {
            print(error.localizedDescription)
        } else {
            if imageURL != nil {
                if let data = imageURL?.data(using: .utf8) {
                    session.sendMessageData(data, replyHandler: {[weak self](data) -> Void in
                        if let image = UIImage(data: data) {
                            self?.eventImage.setImage(image)
                        }
                    }, errorHandler: {(error) -> Void in
                        print(error.localizedDescription)
                    })
                }
            }
        }
    }
}
