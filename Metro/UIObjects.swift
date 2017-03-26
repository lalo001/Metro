//
//  UIObjects.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/23/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class UIObjects: NSObject {
    
    // MARK: - Waiting Screen Creation
    
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
    
    // MARK: - PickerButton Creation
    
    /**
     Create a PickerButton with the desired station.
     
     - parameters:
        - station: The desired Station that will be used for the button properties.
        - view: A [UIView](apple-reference-documentation://hsdIxI1kkd) where the button will be added.
        - topConstant: A [CGFloat](apple-reference-documentation://hswJZ0A9na) that indicates the top separation of the button to its topObject.
        - topObject: Any object with which the button will have a top constraint.
     - note: If topObject is `nil`\, the top constraint is made with the superview.
     */
    static func createPickerButton(for station: Station, inside view: UIView, with topConstant: CGFloat, to topObject: Any?, target: Any?, action: Selector?) -> UIView {

        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        // Add container Constraints
        let containerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["container" : container])
        var containerVerticalConstraints: [NSLayoutConstraint]
        if let topObject = topObject {
            containerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[topObject]-topConstant-[container]", options: NSLayoutFormatOptions(), metrics: ["topConstant" : topConstant], views: ["topObject" : topObject, "container" : container])
        } else {
            containerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-topConstant-[container]", options: NSLayoutFormatOptions(), metrics: ["topConstant" : topConstant], views: ["container" : container])
        }
        view.addConstraints(containerHorizontalConstraints)
        view.addConstraints(containerVerticalConstraints)
    
        // Create button
        let button = PickerButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Tools.colorPicker(1, alpha: 1)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = Constant.StationPicker.pickerTextFont
        button.setTitleColor(Tools.colorPicker(1, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "Chevron"), for: .normal)
        button.imageView?.alpha = Constant.StationPicker.nonTextAlpha
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        let imageWidth = button.currentImage?.size.width ?? 0
        let leftImageInset = view.frame.width - imageWidth
        button.titleLabel?.preferredMaxLayoutWidth = leftImageInset
        button.setTitle((station.name ?? "").uppercased(), for: .normal)
        button.transform = CGAffineTransform(scaleX: -1, y: 1)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        button.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        container.addSubview(button)
        
        // Add button Constraints
        let buttonHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[button]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["button" : button])
        let buttonVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[button]", options: NSLayoutFormatOptions(), metrics: nil, views: ["button" : button])
        container.addConstraints(buttonHorizontalConstraints)
        container.addConstraints(buttonVerticalConstraints)
        
        button.layoutIfNeeded() // Apply constraints to get correct frames.
        // Update button insets.
        let inset: CGFloat = button.frame.width - (button.titleLabel?.frame.width ?? 0) - (button.imageView?.frame.width ?? 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: -inset)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
        
        // Create line
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Tools.colorPicker(1, alpha: Constant.StationPicker.nonTextAlpha)
        container.addSubview(line)
        
        // Add line Constraints
        let lineWidth = button.frame.width + Constant.StationPicker.lineWidthOffset
        let lineHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[line(lineWidth)]", options: NSLayoutFormatOptions(), metrics: ["lineWidth" : lineWidth], views: ["line" : line])
        guard let lines = station.lines?.array as? [Line] else {
            let lineVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[button]-separation-[line(2)]|", options: .alignAllLeft, metrics: ["separation" : Constant.StationPicker.lineSeparation], views: ["button" : button, "line" : line])
            container.addConstraints(lineHorizontalConstraints)
            container.addConstraints(lineVerticalConstraints)
            return container
        }
        let lineVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[button]-separation-[line(2)]", options: .alignAllLeft, metrics: ["separation" : Constant.StationPicker.lineSeparation], views: ["button" : button, "line" : line])
        container.addConstraints(lineHorizontalConstraints)
        container.addConstraints(lineVerticalConstraints)
        
        // FIXME: Delete
        lines[0].colors = [Tools.colorPicker(5, alpha: 1)]
        
        let circlesContainer = UIObjects.createCircles(for: lines, in: container, with: Constant.StationPicker.bottomLineSeparation, to: line)
        let circlesContainerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[circlesContainer]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["circlesContainer" : circlesContainer])
        container.addConstraints(circlesContainerVerticalConstraints)
        
        return container
    }
    
    // MARK: - Line Circle Creation
    
    /**
     Adds more than 1 color for a line circle.
     
     - parameters:
        - circle: The [UIView](apple-reference-documentation://hsdIxI1kkd) where the colors will be added.
        - colors: A [UIColor](apple-reference-documentation://hs-90gzW29) array of the colors that will be added to the circle.
        - diameter: A [CGFloat](apple-reference-documentation://hswJZ0A9na) that indicates the size of the circle.
     */
    static func addColors(for circle: UIView, with colors: [UIColor], diameter: CGFloat) {
        let eachDiameter = diameter/CGFloat(colors.count)
        var circles: [UIView] = []
        for i in 0..<colors.count {
            let current = UIView()
            current.translatesAutoresizingMaskIntoConstraints = false
            current.backgroundColor = colors[i]
            circle.addSubview(current)
            
            let currentHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[current]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["current" : current])
            var currentVerticalConstraints: [NSLayoutConstraint]
            if i == 0 {
                currentVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[current(height)]", options: NSLayoutFormatOptions(), metrics: ["height" : eachDiameter], views: ["current" : current])
            } else if i + 1 == colors.count {
                currentVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[previous][current(height)]|", options: NSLayoutFormatOptions(), metrics: ["height" : eachDiameter], views: ["previous" : circles[i - 1], "current" : current])
            } else {
                currentVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[previous][current(height)]", options: NSLayoutFormatOptions(), metrics: ["height" : eachDiameter], views: ["previous" : circles[i - 1], "current" : current])
            }
            circle.addConstraints(currentHorizontalConstraints)
            circle.addConstraints(currentVerticalConstraints)
            circles.append(current)
        }
    }
    
    /**
     Creates a UIView for use as Line Circle.
     
     - parameters:
        - line: The Line object that contains the information that will be used for the circle.
        - diameter: A [CGFloat](apple-reference-documentation://hswJZ0A9na) that must be the size of the desired circle.
        - view: A [UIView](apple-reference-documentation://hsdIxI1kkd) where the circle will be added.
    - returns: A circular [UIView](apple-reference-documentation://hsdIxI1kkd) with the line color and name.
     
     */
    static func createCircle(for line: Line, with diameter: CGFloat, in view: UIView) -> UIView? {
        
        let cornerRadius = diameter/2
        
        // Create circle
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.clipsToBounds = true
        guard let colors = line.colors, let colorsCount = line.colors?.count else {
            return nil
        }
        guard colorsCount > 0 else {
            return nil
        }
        if colorsCount > 1 {
            self.addColors(for: circle, with: colors, diameter: diameter)
        } else {
            circle.backgroundColor = colors[0]
        }
        circle.layer.cornerRadius = cornerRadius
        view.addSubview(circle)
        
        // Add circle Constraints
        let circleWidth = NSLayoutConstraint(item: circle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: diameter)
        let circleHeight = NSLayoutConstraint(item: circle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: diameter)
        view.addConstraint(circleWidth)
        view.addConstraint(circleHeight)
        
        if let name = line.name {
            
            // Create numberLabel
            let numberLabel = createLabel(text: name, textAlignment: .center, textColor: Constant.Labels.lineNameColor, font: Constant.Labels.lineNameFont)
            circle.addSubview(numberLabel)
            
            // Add numberLabel Constraints
            let numberLabelCenterX = NSLayoutConstraint(item: circle, attribute: .centerX, relatedBy: .equal, toItem: numberLabel, attribute: .centerX, multiplier: 1, constant: 0)
            let numberLabelCenterY = NSLayoutConstraint(item: circle, attribute: .centerY, relatedBy: .equal, toItem: numberLabel, attribute: .centerY, multiplier: 1, constant: 0)
            circle.addConstraint(numberLabelCenterX)
            circle.addConstraint(numberLabelCenterY)
            
            return circle
        } else {
            return nil
        }
    }
    
    /**
     Creates all the circles for the lines that exist in a given array and wraps them in a container.
     
     - parameters:
        - lines: An array of Line objects.
        - view: A [UIView](apple-reference-documentation://hsdIxI1kkd) where the container will be added.
        - topConstant: The separation top constant between the topObject and the container.
        - topObject: The object to which the container will have a top constraint.
    - returns: A [UIView](apple-reference-documentation://hsdIxI1kkd) that has all the circles for each Line element on the given array.
     
     */
    static func createCircles(for lines: [Line], in view: UIView, with topConstant: CGFloat, to topObject: Any?) -> UIView {
        
        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        // Add container Constraints
        let containerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]", options: NSLayoutFormatOptions(), metrics: ["leftMargin" : Constant.StationPicker.leftMarginSeparation, "rightMargin" : Constant.StationPicker.rightMarginSeparation], views: ["container" : container])
        var containerVerticalConstraints: [NSLayoutConstraint]
        if let topObject = topObject {
            containerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[topObject]-topConstant-[container]", options: NSLayoutFormatOptions(), metrics: ["topConstant" : topConstant], views: ["topObject" : topObject, "container" : container])
        } else {
            containerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-topConstant-[container]", options: NSLayoutFormatOptions(), metrics: ["topConstant" : topConstant], views: ["container" : container])
        }
        view.addConstraints(containerHorizontalConstraints)
        view.addConstraints(containerVerticalConstraints)
        
        let sortedLines = lines.sorted(by: {
            $0.name ?? "" < $1.name ?? ""
        })
        
        var circles: [UIView] = []
        
        for i in 0..<sortedLines.count {
            let currentCircle = UIObjects.createCircle(for: sortedLines[i], with: 20, in: container)
            if let currentCircle = currentCircle {
                var currentCircleHorizontalConstraints: [NSLayoutConstraint]
                if i == 0 {
                    currentCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[currentCircle]", options: NSLayoutFormatOptions(), metrics: nil, views: ["currentCircle" : currentCircle])
                } else if i + 1 == sortedLines.count {
                    currentCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[previousCircle]-[currentCircle]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["previousCircle" : circles[i - 1], "currentCircle" : currentCircle])
                } else {
                    currentCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[previousCircle]-[currentCircle]", options: NSLayoutFormatOptions(), metrics: nil, views: ["previousCircle" : circles[i - 1], "currentCircle" : currentCircle])
                }
                let currentCircleVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[currentCircle]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["currentCircle" : currentCircle])
                view.addConstraints(currentCircleHorizontalConstraints)
                view.addConstraints(currentCircleVerticalConstraints)
                circles.append(currentCircle)
            }
        }
        
        return container
    }
    
}
