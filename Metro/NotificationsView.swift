//
//  NotificationsView.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/19/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class NotificationsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Tools.colorPicker(2, alpha: 1)
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        self.addSubview(containerView)
        
        let containerViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["containerView" : containerView])
        let containerViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["containerView" : containerView])
        self.addConstraints(containerViewHorizontalConstraints)
        self.addConstraints(containerViewVerticalConstraints)
        
        let roundedButton = UIObjects.createRoundedButton(with: "Enter Metro", in: containerView, target: ViewController(), action: #selector(ViewController.presentTabBar(_:)))
    }
    
}
