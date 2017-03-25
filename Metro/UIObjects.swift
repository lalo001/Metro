//
//  UIObjects.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/23/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

struct Constant {
    
    struct TextFields {
        static let aboveViewSpace: CGFloat = 25
        static let activeColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let fontSize: CGFloat = 15
        static let fontWeight: CGFloat = UIFontWeightMedium
        static let iconSize: CGFloat = 25
        static let iconLeftMargin: CGFloat = 18
        static let iconBiggerWidthLeftMargin: CGFloat = 15
        static let lineHeight: CGFloat = 0.5
        static let lineColor: UIColor = Tools.colorPicker(3, alpha: 1)
        static let nonActiveColor: UIColor = Tools.colorPicker(1, alpha: 0.8)
        static let placeholderFontSize: CGFloat = 15
        static let spaceBelowText: CGFloat = 10
        static let textLeftMargin: CGFloat = 55
        static let textRightMargin: CGFloat = 20
        static let textAlignment: NSTextAlignment = .left
    }
    
    struct Buttons {
        static let mainButtonHeight: CGFloat = 50
    }
    
    struct Animations {
        static let loadingAnimationDuration: TimeInterval = 0.5
    }
    
    struct Labels {
        static let appWelcomeLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let appWelcomeLabelFont: UIFont = UIFont.systemFont(ofSize: 64, weight: UIFontWeightHeavy)
        static let inputLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let inputLabelFont: UIFont = UIFont.systemFont(ofSize: 28, weight: UIFontWeightBold)
        static let navigationBarTitleColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let stationCircleColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let stationCircleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        static let subtitleLabelColor: UIColor = Tools.colorPicker(1, alpha: 0.5)
        static let titleLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
    }
    
    struct StationPicker {
        static let leftTextMargin: CGFloat = 20
        static let nonTextAlpha: CGFloat = 0.5
        static let pickerTitleColor: UIColor = Tools.colorPicker(3, alpha: 1)
        static let pickerTitleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        static let pickerTextFont: UIFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightRegular)
        static let rightTextMargin: CGFloat = 80
    }
    
}

class UIObjects: NSObject {

    // MARK: - Station Circle Creation
    
    /**
     Creates a UIView for use as Station Circle.
     
     - parameters:
        - station: The Station object that contains the information that will be used for the circle.
        - cornerRadius: A [CGFloat](apple-reference-documentation://hswJZ0A9na) that must be the size of the desired
     - returns: A circular UIView with the station color and line number.
     
     */
    static func createStationCircle(station: Station, cornerRadius: CGFloat) -> UIView {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = .red
        circle.layer.cornerRadius = cornerRadius
        let name = (station.lines?[0] as? Line)?.name ?? ""
        let numberLabel = createLabel(text: name, textAlignment: .center, textColor: Tools.colorPicker(1, alpha: 1), font: UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium))
        circle.addSubview(numberLabel)
        
        // Add numberLabel Constraints
        let numberLabelCenterX = NSLayoutConstraint(item: circle, attribute: .centerX, relatedBy: .equal, toItem: numberLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let numberLabelCenterY = NSLayoutConstraint(item: circle, attribute: .centerY, relatedBy: .equal, toItem: numberLabel, attribute: .centerY, multiplier: 1, constant: 0)
        circle.addConstraint(numberLabelCenterX)
        circle.addConstraint(numberLabelCenterY)
        
        return circle
    }
    
    // MARK: - UILabel Creation
    
    /**
     Creates a UILabel ready for Autolayout Constraints.
     
     - parameters:
        - text: The desired text as [String](apple-reference-documentation://hsZdGligc7).
        - textAlignment: The desired text alignment as a value of [NSTextAlignment](apple-reference-documentation://hsfWdvvFm8).
        - textColor: The desired text color as [UIColor](apple-reference-documentation://hs-90gzW29).
        - font: The desired font as [UIFont](apple-reference-documentation://hsf3LciMnT).
     - returns: A UILabel with the passed properties.
     
     */
    static func createLabel(text: String, textAlignment: NSTextAlignment, textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.font = font
        return label
    }
    
    /**
     Creates a blurred black waiting screen with a UIActivityIndicator.
        
     - parameters:
        - mainView: A [UIView](apple-reference-documentation://hsdIxI1kkd) where the waiting screen will be added.
     
     */
    static func createWaitingScreen(mainView: UIView) -> UIView {
        // Create blurView
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.tag = 2
        blurView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(blurView)
        
        // Add blurView Constraints
        let blurViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[blurView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["blurView" : blurView])
        let blurViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[blurView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["blurView" : blurView])
        mainView.addConstraints(blurViewHorizontalConstraints)
        mainView.addConstraints(blurViewVerticalConstraints)
        
        // Create activityIndicator
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        blurView.addSubview(activityIndicator)
        
        // Add activityIndicator Constraints
        let activityCenterX = NSLayoutConstraint(item: blurView, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        let activityCenterY = NSLayoutConstraint(item: blurView, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        blurView.addConstraint(activityCenterX)
        blurView.addConstraint(activityCenterY)
        
        return blurView
    }
    
    /**
     Create a PickerButton with the desired station.
     
     - parameters:
        - station: The desired Station that will be used for the button properties.
        - view: A [UIView](apple-reference-documentation://hsdIxI1kkd) where the button will be added.
        - topConstant: A [CGFloat](apple-reference-documentation://hswJZ0A9na) that indicates the top separation of the button to its topObject.
        - topObject: Any object with which the button will have a top constraint.
    - note: If topObject is `nil`\, the top constraint is made with the superview.
     */
    static func createPickerButton(for station: Station, inside view: UIView, topConstant: CGFloat, topObject: Any?) -> PickerButton {
        
        // Create button
        let button = PickerButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Tools.colorPicker(1, alpha: 1)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = Constant.StationPicker.pickerTextFont
        button.setTitleColor(Tools.colorPicker(1, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(named: "Picker Icon"), for: .normal)
        button.imageView?.alpha = Constant.StationPicker.nonTextAlpha
        let imageWidth = button.currentImage?.size.width ?? 0
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
        let leftImageInset = view.frame.width - Constant.StationPicker.leftTextMargin - Constant.StationPicker.rightTextMargin - imageWidth
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 0, right: -leftImageInset)
        button.titleLabel?.preferredMaxLayoutWidth = leftImageInset
        button.setTitle(station.name, for: .normal)
        view.addSubview(button)
        
        // Add button Constraints
        let buttonHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftInset-[button]-rightInset-|", options: NSLayoutFormatOptions(), metrics: ["leftInset" : Constant.StationPicker.leftTextMargin, "rightInset" : Constant.StationPicker.rightTextMargin], views: ["button" : button])
        var buttonVerticalConstraints: [NSLayoutConstraint]
        if let topObject = topObject {
            buttonVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[topObject]-(topConstant)-[button]", options: NSLayoutFormatOptions(), metrics: ["topConstant" : topConstant], views: ["topObject" : topObject, "button" : button])
        } else {
            buttonVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(topConstant)-[button]", options: NSLayoutFormatOptions(), metrics: ["topConstant" : topConstant], views: ["button" : button])
        }
        view.addConstraints(buttonHorizontalConstraints)
        view.addConstraints(buttonVerticalConstraints)
        
        // Create line
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Tools.colorPicker(1, alpha: Constant.StationPicker.nonTextAlpha)
        view.addSubview(line)
        
        // Add line Constraints
        let lineWidth = view.frame.width - Constant.StationPicker.leftTextMargin - Constant.StationPicker.rightTextMargin
        let lineHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[line(lineWidth)]", options: NSLayoutFormatOptions(), metrics: ["lineWidth" : lineWidth], views: ["line" : line])
        let lineVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[button]-8-[line(1.5)]", options: .alignAllLeft, metrics: nil, views: ["button" : button, "line" : line])
        view.addConstraints(lineHorizontalConstraints)
        view.addConstraints(lineVerticalConstraints)
        return button
    }
    
}
