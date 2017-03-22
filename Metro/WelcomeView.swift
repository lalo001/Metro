//
//  WelcomeView.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/19/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import AVFoundation

class WelcomeView: UIView {
    
    var player: AVQueuePlayer?
    var playerLooper: AVPlayerLooper?
    var videoLayer: AVPlayerLayer?
    
    private var fileURL: URL?
    private var myContext = 0
    private var shouldAddObserver = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Tools.colorPicker(2, alpha: 1)
        // Load Train.mp4 from Main Bundle
        let filePath = Bundle.main.path(forResource: "Train.mp4", ofType: nil)
        if let filePath = filePath {
            // If user has audio playing when the app opens this will allow it to continue.
            
            // Get iPhone audio session
            let audioSession = AVAudioSession.sharedInstance()
            do {
                // Set the category to ambient which indicates sound isn't important for the app and mixWithOthers to allow multiple tracks of audio.
                try audioSession.setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
            } catch {
                print(error)
            }
            // Create a URL with the file path created before.
            fileURL = URL.init(fileURLWithPath: filePath)
            guard let fileURL = fileURL else {
                return
            }
            // Initialize player with no items on the queue.
            player = AVQueuePlayer()
            guard let player = player else {
                return
            }
            // Initialize videoLayer in which the video will show.
            videoLayer = AVPlayerLayer(player: player)
            videoLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            if let videoLayer = videoLayer {
                self.layer.addSublayer(videoLayer)
            }
            // Makes sure we are on the main queue in which we should update the UI.
            DispatchQueue.main.async(execute: {
                // Create a AVPlayerItem using the URL.
                let video = AVPlayerItem(url: fileURL)
                // Create a loop with the player and the video we want.
                self.playerLooper = AVPlayerLooper(player: player, templateItem: video)
                // Set the video volume to 0.
                player.volume = 0
                // Play the video.
                player.play()
            })
        }
        
        // Create overlayView
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = Tools.colorPicker(2, alpha: 0.9)
        self.addSubview(overlayView)
        
        // Add overlayView Constraints
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[overlayView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["overlayView" : overlayView])
        let overlayViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[overlayView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["overlayView" : overlayView])
        let overlayViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[overlayView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["overlayView" : overlayView])
        self.addConstraints(overlayViewHorizontalConstraints)
        self.addConstraints(overlayViewVerticalConstraints)
        
        // Create welcomeToLabel
        let welcomeToLabel = Tools.createLabel(text: NSLocalizedString("welcomeTo", comment: ""), textAlignment: .left, textColor: Constant.labels.subtitleLabelColor, font: UIFont.systemFont(ofSize: 22, weight: UIFontWeightMedium))
        overlayView.addSubview(welcomeToLabel)
        
        // Add welcomeToLabel Constraints
        let welcomeToLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[welcomeToLabel]", options: NSLayoutFormatOptions(), metrics: nil, views: ["welcomeToLabel" : welcomeToLabel])
        let welcomeToLabelVerticalConstraints = NSLayoutConstraint(item: overlayView, attribute: .centerY, relatedBy: .equal, toItem: welcomeToLabel, attribute: .centerY, multiplier: 1, constant: -60)
        overlayView.addConstraints(welcomeToLabelHorizontalConstraints)
        overlayView.addConstraint(welcomeToLabelVerticalConstraints)
        
        // Create metroLabel
        let metroLabel = Tools.createLabel(text: NSLocalizedString("metro", comment: "").uppercased(), textAlignment: .left, textColor: Constant.labels.titleLabelColor, font: UIFont.systemFont(ofSize: 64, weight: UIFontWeightHeavy))
        overlayView.addSubview(metroLabel)
        
        // Add metroLabel Constraints
        let metroLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[welcomeToLabel]-(-5)-[metroLabel]", options: .alignAllLeft, metrics: nil, views: ["welcomeToLabel" : welcomeToLabel, "metroLabel" : metroLabel])
        overlayView.addConstraints(metroLabelVerticalConstraints)
        
        // Create sloganLabel
        let sloganLabel = Tools.createLabel(text: NSLocalizedString("slogan", comment: ""), textAlignment: .left, textColor: Constant.labels.subtitleLabelColor, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium))
        // With this property set to 0 text will wrap
        sloganLabel.numberOfLines = 0
        overlayView.addSubview(sloganLabel)
        
        // Add sloganLabel Constraints
        let sloganLabelLeading = NSLayoutConstraint(item: overlayView, attribute: .right, relatedBy: .equal, toItem: sloganLabel, attribute: .right, multiplier: 1, constant: 20)
        let sloganLabelVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[metroLabel]-10-[sloganLabel]", options: .alignAllLeft, metrics: nil, views: ["metroLabel" : metroLabel, "sloganLabel" : sloganLabel])
        overlayView.addConstraint(sloganLabelLeading)
        overlayView.addConstraints(sloganLabelVerticalConstraints)
    }
    
    deinit {
        print("Deinit")
    }
}
