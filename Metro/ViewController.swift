//
//  ViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/19/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView?
    var pageControl: UIPageControl?
    var leftContainerView: WelcomeView?
    var currentTime: CMTime = CMTime()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create scrollView.
        scrollView = UIScrollView()
        // Unwrap to avoid force unwrapping later (i.e. scrollView!).
        guard let scrollView = scrollView else {
            // If scrollView is nil something went wrong so end loadView().
            return
        }
        // This is important for any UI object you'll add constraints to; otherwise constraints become ambiguous.
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        // Add scrollView Constraints.
        let scrollViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scrollView" : scrollView])
        let scrollViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scrollView" : scrollView])
        self.view.addConstraints(scrollViewHorizontalConstraints)
        self.view.addConstraints(scrollViewVerticalConstraints)
        
        // Create contentView.
        // This view gives the content size for scrollView when using Autolayout.
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
        
        // Calculate contentSize (Horizontal) for contentView.
        let contentSize = self.view.bounds.width * 3
        
        // Add contentView Constraints.
        let contentViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView(contentSize)]|", options: NSLayoutFormatOptions(), metrics: ["contentSize" : contentSize], views: ["contentView" : contentView])
        let contentViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(viewHeight)]|", options: NSLayoutFormatOptions(), metrics: ["viewHeight" : self.view.bounds.height], views: ["contentView" : contentView])
        // Constraints must be added to the parent view.
        scrollView.addConstraints(contentViewHorizontalConstraints)
        scrollView.addConstraints(contentViewVerticalConstraints)
        
        // Create leftContainerView
        leftContainerView = WelcomeView()
        leftContainerView?.translatesAutoresizingMaskIntoConstraints = false
        guard let leftContainerView = leftContainerView else {
            return
        }
        contentView.addSubview(leftContainerView)
        
        // Add leftContainerView Constraints
        let leftContainerViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftContainerView(viewWidth)]", options: NSLayoutFormatOptions(), metrics: ["viewWidth" : self.view.bounds.width], views: ["leftContainerView" : leftContainerView])
        let leftContainerViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftContainerView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["leftContainerView" : leftContainerView])
        contentView.addConstraints(leftContainerViewHorizontalConstraints)
        contentView.addConstraints(leftContainerViewVerticalConstraints)
        
        // Create centerContainerView
        let centerContainerView = LocationView()
        centerContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(centerContainerView)
        
        // Add centerContainerView Constraints
        let centerContainerViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[leftContainerView][centerContainerView(viewWidth)]", options: NSLayoutFormatOptions(), metrics: ["viewWidth" : self.view.bounds.width], views: ["leftContainerView" : leftContainerView, "centerContainerView" : centerContainerView])
        let centerContainerViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[centerContainerView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["centerContainerView" : centerContainerView])
        contentView.addConstraints(centerContainerViewHorizontalConstraints)
        contentView.addConstraints(centerContainerViewVerticalConstraints)
        
        // Create rightContainerView
        let rightContainerView = NotificationsView()
        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightContainerView)
        
        // Add rightContainerView Constraints
        let rightContainerViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[centerContainerView][rightContainerView(viewWidth)]|", options: NSLayoutFormatOptions(), metrics: ["viewWidth" : self.view.bounds.width], views: ["centerContainerView" : centerContainerView, "rightContainerView" : rightContainerView])
        let rightContainerViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[rightContainerView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["rightContainerView" : rightContainerView])
        contentView.addConstraints(rightContainerViewHorizontalConstraints)
        contentView.addConstraints(rightContainerViewVerticalConstraints)
        
        // Create pageControl
        pageControl = UIPageControl()
        guard let pageControl = pageControl else {
            return
        }
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        self.view.addSubview(pageControl)
        
        // Add pageControl Constraints
        let pageControlCenterX = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: pageControl, attribute: .centerX, multiplier: 1, constant: 0)
        let pageControlVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[pageControl]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["pageControl" : pageControl])
        // Visual format constraints return an [NSLayoutConstraint] that's why it uses addConstraints. When the initializer of NSLayoutConstraint is used then it uses addConstraint.
        self.view.addConstraint(pageControlCenterX)
        self.view.addConstraints(pageControlVerticalConstraints)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leftContainerView?.player?.pause()
    }
    
    // MARK: - UIScrollViewDelegate Functions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x/self.view.bounds.width)
        pageControl?.currentPage = Int(page)
    }
    
    // MARK: - Custom Functions
    
    func applicationWillEnterForeground (_ notification: Notification) {
        leftContainerView?.player?.seek(to: currentTime)
        leftContainerView?.player?.play()
    }
    
    func applicationDidEnterBackground (_ notification: Notification) {
        let currentCM = leftContainerView?.player?.currentTime()
        if let currentCM = currentCM {
            currentTime = currentCM
        }
        leftContainerView?.player?.pause()
    }
    
    func presentTabBar(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Tab Bar")
        self.present(vc, animated: true, completion: { [weak self] _ in
            self?.leftContainerView = nil
        })
    }

}
