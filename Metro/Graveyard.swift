//
//  Graveyard.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/20/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class Graveyard: NSObject {
    
    // MARK: - AVPlayer Loop Funcionaility for iOS 9 and prior.
    /*
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
        
        /*
         // Only override draw() if you perform custom drawing.
         // An empty implementation adversely affects performance during animation.
         override func draw(_ rect: CGRect) {
         // Drawing code
         }
         */
        
        var player: AVPlayer?
        var queue: AVQueuePlayer?
        var playerLooper: AVPlayerLooper?
        var videoLayer: AVPlayerLayer?
        var video: AVPlayerItem?
        
        private var fileURL: URL?
        private var myContext = 0
        private var shouldAddObserver = true
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = Tools.colorPicker(2, alpha: 1)
            
            // Create player
            let filePath = Bundle.main.path(forResource: "Train.mp4", ofType: nil)
            if let filePath = filePath {
                print("Found")
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
                } catch {
                    print(error)
                }
                fileURL = URL.init(fileURLWithPath: filePath)
                guard let fileURL = fileURL else {
                    return
                }
                video = AVPlayerItem(url: fileURL)
                guard let video = video else {
                    return
                }
                queue = AVQueuePlayer(items: [video])
                player = queue
                guard let player = player else {
                    return
                }
                videoLayer = AVPlayerLayer(player: player)
                videoLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                if let videoLayer = videoLayer {
                    self.layer.addSublayer(videoLayer)
                }
                //playerLooper = AVPlayerLooper(player: player, templateItem: video)
                player.volume = 0
                player.play()
                
                video.addObserver(self, forKeyPath: "duration", options: .new, context: &myContext)
            }
            
            // Create overlayView
            let overlayView = UIView()
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            overlayView.backgroundColor = Tools.colorPicker(2, alpha: 0.9)
            self.addSubview(overlayView)
            
            // Add overlayView Constraints
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
            video?.removeObserver(self, forKeyPath: "duration", context: &myContext)
        }
        
        // MARK: Loop funcionality for iOS 9.
        
        @available(iOS 9.0, *)
        func addTimeObserver() {
            guard let duration = player?.currentItem?.duration else {
                return
            }
            var times = [NSValue]()
            
            // Set initial time to zero
            var currentTime = kCMTimeZero
            
            // Divide the asset's duration into quarters.
            let interval = CMTimeMultiplyByFloat64(duration, 0.25)
            
            // Build boundary times at 25%, 50%, 75%, 100%
            while currentTime < duration {
                currentTime = currentTime + interval
                times.append(NSValue(time:currentTime))
            }
            
            // Queue on which to invoke the callback
            let mainQueue = DispatchQueue.main
            
            player?.addBoundaryTimeObserver(forTimes: times, queue: mainQueue) { [weak self] Void in
                guard let currentTime = self?.player?.currentItem?.currentTime() else {
                    return
                }
                // If the current time is below the 25% then add new video to queue so it has enough time to load.
                if CMTimeCompare(currentTime, kCMTimeZero + CMTimeMultiplyByFloat64(interval, 1.5)) <= 0{
                    guard let fileURL = self?.fileURL else {
                        return
                    }
                    
                    let newVideo = AVPlayerItem(url: fileURL)
                    guard let queue = self?.queue else {
                        return
                    }
                    queue.insert(newVideo, after: nil)
                }
            }
        }
        
        // MARK: - Key Value Observation
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if context == &myContext {
                if let newValue = change?[.newKey] {
                    if newValue is CMTime {
                        if let newTime = newValue as? CMTime {
                            if !CMTIME_IS_INDEFINITE(newTime) {
                                if shouldAddObserver {
                                    print("Add Observer")
                                    shouldAddObserver = false
                                    addTimeObserver()
                                }
                            } else {
                                print("Remove Observer")
                                video?.removeObserver(self, forKeyPath: "duration", context:&myContext)
                                shouldAddObserver = true
                            }
                        }
                    }
                }
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
        
    }
    */
}
