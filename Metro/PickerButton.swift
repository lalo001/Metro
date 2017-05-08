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
    
    public enum Direction: Int {
        case from = 0, to
    }
    
    var direction: Direction?
    
    override var intrinsicContentSize: CGSize {
        let titleWidth = titleLabel?.intrinsicContentSize.width ?? 0
        let imageWidth = imageView?.intrinsicContentSize.width ?? 0
        let size = CGSize(width: titleWidth + imageWidth + contentEdgeInsets.left + contentEdgeInsets.right, height: (titleLabel?.intrinsicContentSize.height ?? 0) + titleEdgeInsets.top + titleEdgeInsets.bottom + contentEdgeInsets.top + contentEdgeInsets.bottom)
        return size
    }
}
