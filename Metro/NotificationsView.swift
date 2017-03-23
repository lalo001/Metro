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
        self.backgroundColor = .red
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 30, y: 30, width: 50, height: 21)
        button.setTitle("Hola", for: .normal)
        button.addTarget(ViewController(), action: #selector(ViewController.presentTabBar(_:)), for: .touchUpInside)
        self.addSubview(button)
    }
    
}
