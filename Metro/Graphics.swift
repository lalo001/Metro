//
//  Graphics.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/25/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class Graphics {

    // MARK: - Route Icon Functions
    
    /**
     Create the route icon consisting of two circles (one with a doughnut-like shape and other solid-filled circle) and a line between them.
     
     - parameters:
        - view: A [UIView](apple-reference-documentation://hsdIxI1kkd) where the route icon will be added.
        - startingObject: Any object to which the first circle will have a top to top constraint with constant zero.
        - endingObject: Any object to which the second circle will have a bottom to bottom constraint with constant zero.
     */
    static func createRouteIcon(in view: UIView, from startingObject: Any, to endingObject: Any) {
        
        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        // Add container Constraints
        let containerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftSeparation-[container(width)]", options: NSLayoutFormatOptions(), metrics: ["leftSeparation" : Constant.RouteIcon.leftSeparation, "width" : Constant.RouteIcon.circleDiameter], views: ["container" : container])
        let containerTopConstraint = NSLayoutConstraint(item: startingObject, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0)
        let containerBottomConstraint = NSLayoutConstraint(item: endingObject, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints(containerHorizontalConstraints)
        view.addConstraint(containerTopConstraint)
        view.addConstraint(containerBottomConstraint)
        
        // Create upperCircle
        let upperCircle = Circle(cornerRadius: Constant.RouteIcon.circleDiameter/2)
        upperCircle.translatesAutoresizingMaskIntoConstraints = false
        upperCircle.clipsToBounds = true
        upperCircle.layer.cornerRadius = Constant.RouteIcon.circleDiameter/2
        upperCircle.layer.borderWidth = Constant.RouteIcon.borderWidth
        upperCircle.layer.borderColor = Constant.RouteIcon.circleColor.cgColor
        container.addSubview(upperCircle)
        
        // Add upperCircle Constraints
        let upperCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[upperCircle]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["upperCircle" : upperCircle])
        let upperCircleVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[upperCircle(height)]", options: NSLayoutFormatOptions(), metrics: ["height" : Constant.RouteIcon.circleDiameter], views: ["upperCircle" : upperCircle])
        container.addConstraints(upperCircleHorizontalConstraints)
        container.addConstraints(upperCircleVerticalConstraints)
        
        // Create lowerCircle
        let lowerCircle = Circle(cornerRadius: Constant.RouteIcon.circleDiameter/2)
        lowerCircle.translatesAutoresizingMaskIntoConstraints = false
        lowerCircle.clipsToBounds = true
        lowerCircle.backgroundColor = Constant.RouteIcon.circleColor
        container.addSubview(lowerCircle)
        
        // Add lowerCircle Constraints
        let lowerCircleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[lowerCircle]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["lowerCircle" : lowerCircle])
        let lowerCircleVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[lowerCircle(height)]|", options: NSLayoutFormatOptions(), metrics: ["height" : Constant.RouteIcon.circleDiameter], views: ["lowerCircle" : lowerCircle])
        container.addConstraints(lowerCircleHorizontalConstraints)
        container.addConstraints(lowerCircleVerticalConstraints)
        
        // Create line
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = Constant.RouteIcon.circleColor
        line.layer.cornerRadius = Constant.RouteIcon.circleDiameter/15
        container.addSubview(line)
        
        // Add line Constraints
        let lineCenterX = NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: line, attribute: .centerX, multiplier: 1, constant: 0)
        let lineWidth = NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constant.RouteIcon.borderWidth - 0.5)
        let lineVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[upperCircle]-4-[line]-4-[lowerCircle]", options: NSLayoutFormatOptions(), metrics: nil, views: ["upperCircle" : upperCircle, "line" : line, "lowerCircle" : lowerCircle])
        container.addConstraint(lineCenterX)
        container.addConstraint(lineWidth)
        container.addConstraints(lineVerticalConstraints)
    }
    
    /**
     Create a UIButton with the Invert Icon inside a circle and centered between the topContainer end and lowerContainer beginning.
     
     - parameters:
        - view: A [UIView](apple-reference-documentation://hsdIxI1kkd) where the invert icon will be added.
        - viewForCenter: A [UIView](apple-reference-documentation://hsdIxI1kkd) where the reference view for centering the button will be added.
        - topContainer: A [UIView](apple-reference-documentation://hsdIxI1kkd) that is the top limit for the centered view.
        - lowerContainer: A [UIView](apple-reference-documentation://hsdIxI1kkd) that is the bottom limit for the centered view.
        - target: The [UIButton](apple-reference-documentation://hsOyO61dSB) target for a touchUpInside action.
        - action: A [Selector](apple-reference-documentation://hs-szf3dZP) to trigger when a touchUpInside event happens on the button.
     */
    static func createInvertIconButton(in view: UIView, with viewForCenter: UIView, from topContainer: UIView, to lowerContainer: UIView, target: Any, action: Selector) {
        
        // Create centerContainer
        let centerContainer = createCenterForInvertIcon(from: topContainer, to: lowerContainer, in: viewForCenter)
        
        // Create image
        guard let image = UIImage(named: "Invert Icon") else {
            return
        }
        // Create imageView
        let arrowButton = UIButton(type: .system)
        arrowButton.backgroundColor = Tools.colorPicker(1, alpha: 1)
        arrowButton.tintColor = Tools.colorPicker(3, alpha: 1)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.setImage(image, for: .normal)
        arrowButton.imageView?.contentMode = .center
        arrowButton.layer.cornerRadius = Constant.InvertIcon.imageSize/2
        arrowButton.addTarget(target, action: action, for: .touchUpInside)
        view.addSubview(arrowButton)
        
        // Add imageView Constraints
        let arrowButtonHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[arrowButton(width)]-leftSeparation-|", options: NSLayoutFormatOptions(), metrics: ["width" : Constant.InvertIcon.imageSize, "leftSeparation" : Constant.RouteIcon.leftSeparation], views: ["arrowButton" : arrowButton])
        let arrowButtonHeightConstraints = NSLayoutConstraint(item: arrowButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constant.InvertIcon.imageSize)
        let arrowButtonCenterY = NSLayoutConstraint(item: centerContainer, attribute: .centerY, relatedBy: .equal, toItem: arrowButton, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraints(arrowButtonHorizontalConstraints)
        view.addConstraint(arrowButtonHeightConstraints)
        view.addConstraint(arrowButtonCenterY)
    }
    
    fileprivate static func createCenterForInvertIcon(from topContainer: UIView, to lowerContainer: UIView, in view: UIView) -> UIView {
        
        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        // Add container Constraints
        let containerHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["container" : container])
        let containerVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[topContainer][container][lowerContainer]", options: NSLayoutFormatOptions(), metrics: nil, views: ["topContainer" : topContainer, "container" : container, "lowerContainer" : lowerContainer])
        view.addConstraints(containerHorizontalConstraints)
        view.addConstraints(containerVerticalConstraints)
        
        return container
    }
}
