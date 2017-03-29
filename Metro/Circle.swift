//
//  Circle.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/27/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class Circle: UIView {

    var cornerRadius: CGFloat?

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.layer.cornerRadius = cornerRadius ?? 0
    }

    init (cornerRadius: CGFloat) {
        super.init(frame: .zero)
        self.cornerRadius = cornerRadius
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
