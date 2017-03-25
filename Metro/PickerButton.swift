//
//  PickerButton.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/24/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class PickerButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var intrinsicContentSize: CGSize {
        return titleLabel?.intrinsicContentSize ?? .zero
    }

}
