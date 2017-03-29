//
//  ScannerViewController.swift
//  Mel
//
//  Created by Eduardo Valencia on 3/23/17.
//  Copyright © 2017 Eduardo Valencia Paz. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

enum ScannerState: Int {
    case none = 0, success, error
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, SFSafariViewControllerDelegate {
    
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var output: AVCaptureMetadataOutput?
    var scanBorder: ScanBorder?
    var scanAcceptedBorder: UIView?
    var feedbackGenerator: UINotificationFeedbackGenerator?
    var cancelButton: UIButton?
    var statusLabel: UILabel?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        DispatchQueue.main.async {
            self.feedbackGenerator = UINotificationFeedbackGenerator() // Initialize haptic engine.
            self.feedbackGenerator?.prepare() // Prepare haptic engine to reduce fire time.
        }
        
        session = AVCaptureSession() // Initialize capture session.
        
        // Get default device that can record video.
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            try device?.lockForConfiguration()
            let isFocusModeSupported = device?.isFocusModeSupported(.continuousAutoFocus) ?? false
            if isFocusModeSupported {
                device?.focusMode = .continuousAutoFocus
            }
            device?.unlockForConfiguration()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        do {
            let input = try AVCaptureDeviceInput.init(device: device)
            session?.addInput(input)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.showScanner()
            }
            break
        case .denied:
            self.showErrorOverlay(with: status)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(authorized) -> Void in
                if authorized {
                    DispatchQueue.main.async {
                        self.showScanner()
                    }
                }
            })
            break
        case .restricted:
            self.showErrorOverlay(with: status)
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.feedbackGenerator = UINotificationFeedbackGenerator() // Initialize haptic engine.
            self.feedbackGenerator?.prepare() // Prepare haptic engine to reduce fire time.
            self.statusLabel?.text = ""
        }
        if scanBorder == nil {
            scanBorder = ScanBorder(scanState: .none, isFull: false)
            scanBorder?.translatesAutoresizingMaskIntoConstraints = false
            scanBorder?.backgroundColor = .clear
            if let scanBorder = scanBorder {
                self.view.addSubview(scanBorder)
                
                let scanBorderHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scanBorder]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scanBorder" : scanBorder])
                let scanBorderVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scanBorder]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scanBorder" : scanBorder])
                
                self.view.addConstraints(scanBorderHorizontalConstraints)
                self.view.addConstraints(scanBorderVerticalConstraints)
            }
        }
        if scanAcceptedBorder != nil {
            scanAcceptedBorder?.removeFromSuperview()
            scanAcceptedBorder = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        self.previewLayer?.bounds = self.view.bounds
        self.previewLayer?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Custom Functions
    
    func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showScanner() {
        output = AVCaptureMetadataOutput()
        session?.addOutput(output)
        output?.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        output?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.bounds = self.view.bounds
        previewLayer?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        if let previewLayer = previewLayer {
            self.view.layer.addSublayer(previewLayer)
        }
        
        let scanOverlay = ScanOverlay()
        scanOverlay.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scanOverlay)
        
        let scanOverlayHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scanOverlay]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scanOverlay" : scanOverlay])
        let scanOverlayVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scanOverlay]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scanOverlay" : scanOverlay])
        
        self.view.addConstraints(scanOverlayHorizontalConstraints)
        self.view.addConstraints(scanOverlayVerticalConstraints)
        
        scanBorder?.removeFromSuperview()
        scanBorder = ScanBorder(scanState: .none, isFull: false)
        scanBorder?.translatesAutoresizingMaskIntoConstraints = false
        scanBorder?.backgroundColor = .clear
        if let scanBorder = scanBorder {
            self.view.addSubview(scanBorder)
            
            let scanBorderHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scanBorder]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scanBorder" : scanBorder])
            let scanBorderVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scanBorder]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scanBorder" : scanBorder])
            
            self.view.addConstraints(scanBorderHorizontalConstraints)
            self.view.addConstraints(scanBorderVerticalConstraints)
        }
        
        cancelButton?.removeFromSuperview()
        
        // Add cancelButton
        cancelButton = Graphics.createCancelButton(in: self.view, target: self, action: #selector(self.cancelButtonPressed(_:)))
        
        // Create statusLabel
        statusLabel?.removeFromSuperview()
        statusLabel = UIObjects.createLabel(text: "", textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular))
        statusLabel?.numberOfLines = 0
        guard let statusLabel = statusLabel else {
            return
        }
        scanOverlay.addSubview(statusLabel)
        
        // Add statusLabel Constraints
        let statusLabelCenterX = NSLayoutConstraint(item: scanOverlay, attribute: .centerX, relatedBy: .equal, toItem: statusLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let statusLabelBottomConstraint = NSLayoutConstraint(item: scanOverlay, attribute: .bottom, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: Constant.Scanner.statusLabelBottomSeparation)
        scanOverlay.addConstraint(statusLabelCenterX)
        scanOverlay.addConstraint(statusLabelBottomConstraint)
        
        session?.startRunning()
        let rectOfInterest = previewLayer?.metadataOutputRectOfInterest(for: CGRect(x: self.view.center.x - 90, y: self.view.center.y - 90, width: 180, height: 180))
        output?.rectOfInterest = rectOfInterest ?? CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    func showErrorOverlay(with errorStatus: AVAuthorizationStatus) {
        print(errorStatus)
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Functions
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        for metadata in metadataObjects {
            if metadata is AVMetadataMachineReadableCodeObject {
                session?.stopRunning()
                guard let transformed = metadata as? AVMetadataMachineReadableCodeObject else {
                    continue
                }
                
                guard let url = URL(string: transformed.stringValue) else {
                    continue
                }
                
                if url.absoluteString.hasPrefix("http://") || url.absoluteString.hasPrefix("https://") {
                    DispatchQueue.main.async {
                        self.statusLabel?.text = ""
                        self.feedbackGenerator?.notificationOccurred(.success)
                        self.feedbackGenerator = nil
                        self.scanBorder?.scanState = .success
                        self.scanBorder?.isFull = true
                        self.scanBorder?.layer.setNeedsDisplay()
                        self.scanBorder?.layer.displayIfNeeded()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            let safari = SFSafariViewController(url: url)
                            safari.delegate = self
                            self.present(safari, animated: true, completion: nil)
                        })
                    }
                    return
                }
            
                //self.session?.startRunning()
            }
        }
        DispatchQueue.main.async {
            self.statusLabel?.text = NSLocalizedString("invalidLink", comment: "")
            self.feedbackGenerator?.notificationOccurred(.error)
            self.feedbackGenerator = nil
            self.scanBorder?.scanState = .error
            self.scanBorder?.isFull = true
            self.scanBorder?.layer.setNeedsDisplay()
            self.scanBorder?.layer.displayIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.scanBorder?.scanState = .none
                self.scanBorder?.isFull = false
                self.scanBorder?.layer.setNeedsDisplay()
                self.scanBorder?.layer.displayIfNeeded()
                self.feedbackGenerator = UINotificationFeedbackGenerator() // Initialize haptic engine.
                self.feedbackGenerator?.prepare() // Prepare haptic engine to reduce fire time.
                self.session?.startRunning()
            })
        }
    }
    
    // MARK: - SFSafariViewControllerDelegate Functions
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        statusLabel?.text = ""
        self.session?.startRunning()
        self.scanBorder?.scanState = .none
        self.scanBorder?.isFull = false
        self.scanBorder?.layer.setNeedsDisplay()
        self.scanBorder?.layer.displayIfNeeded()
    }
    
}
