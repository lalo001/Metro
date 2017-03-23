//
//  Tools.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/19/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

struct Constant {
    
    struct textFields {
        static let lineHeight: CGFloat = 0.5
        static let lineColor: UIColor = Tools.colorPicker(3, alpha: 1)
        static let placeholderFontSize: CGFloat = 15
        static let fontSize: CGFloat = 15
        static let iconSize: CGFloat = 25
        static let iconLeftMargin: CGFloat = 18
        static let iconBiggerWidthLeftMargin: CGFloat = 15
        static let fontWeight: CGFloat = UIFontWeightMedium
        static let spaceBelowText: CGFloat = 10
        static let textLeftMargin: CGFloat = 55
        static let textRightMargin: CGFloat = 20
        static let activeColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let textAlignment: NSTextAlignment = .left
        static let nonActiveColor: UIColor = Tools.colorPicker(1, alpha: 0.8)
        static let aboveViewSpace: CGFloat = 25
    }
    
    struct buttons {
        static let mainButtonHeight: CGFloat = 50
    }
    
    struct animations {
        static let loadingAnimationDuration: TimeInterval = 0.5
    }
    
    struct labels {
        static let appWelcomeLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let appWelcomeLabelFont: UIFont = UIFont.systemFont(ofSize: 64, weight: UIFontWeightHeavy)
        static let inputLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let inputLabelFont: UIFont = UIFont.systemFont(ofSize: 28, weight: UIFontWeightBold)
        static let stationCircleColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let stationCircleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        static let subtitleLabelColor: UIColor = Tools.colorPicker(1, alpha: 0.5)
        static let titleLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let navigationBarTitleColor: UIColor = Tools.colorPicker(1, alpha: 1)
        
    }
    
}

class Tools: NSObject {
    
    // MARK: - Create Gradient
    
    static func createGradient(_ bounds: CGRect, colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        return gradient
    }
    
    
    /**
     Available Colors
     ================
     
     The following are the colors with their associated index:
     
     1. White
     2. Main Background Black
     3. Main Pink
     4. Line 1 Pink
     5. Line 2 Blue
     6. Line 3 Green
     7. Line 4 Turquoise
     8. Line 5 Yellow
     9. Line 6 Red
     10. Line 7 Orange
     11. Line 8 Green
     12. Line 9 Brown
     13. Line A Purple
     14. Line B Gray
     15. Line B Green
     16. Line 12 Golden
     17. Suburban Line Red
     
     - parameters:
        - index: the desired color index
        - alpha: the color alpha
     - returns: A UIColor with the desired RGB
     
     */
    static func colorPicker(_ index: Int, alpha: CGFloat) -> UIColor {
        var color: UIColor = UIColor()
        switch (index) {
        case 1:
            // #FFFFFF
            color = UIColor.init(white: 1, alpha: alpha)
        case 2:
            // #221E22
            color = UIColor(red: 34.0/255.0, green: 30.0/255.0, blue: 34.0/255.0, alpha: alpha)
        case 3:
            // #E2148B
            color = UIColor(red: 226.0/255.0, green: 20.0/255.0, blue: 139.0/255.0, alpha: alpha)
        case 4:
            // #F25E9A
            color = UIColor(red: 242.0/255.0, green: 94.0/255.0, blue: 154.0/255.0, alpha: alpha)
        case 5:
            // #008BDE
            color = UIColor(red: 0.0/255.0, green: 139.0/255.0, blue: 222.0/255.0, alpha: alpha)
        case 6:
            // #879230
            color = UIColor(red: 135.0/255.0, green: 146.0/255.0, blue: 48.0/255.0, alpha: alpha)
        case 7:
            // #5CC0AD
            color = UIColor(red: 92.0/255.0, green: 192.0/255.0, blue: 173.0/255.0, alpha: alpha)
        case 8:
            // #F5C800
            color = UIColor(red: 245.0/255.0, green: 200.0/255.0, blue: 0.0/255.0, alpha: alpha)
        case 9:
            // #F73E2E
            color = UIColor(red: 247.0/255.0, green: 62.0/255.0, blue: 46.0/255.0, alpha: alpha)
        case 10:
            // #F77E13
            color = UIColor(red: 247.0/255.0, green: 126.0/255.0, blue: 19.0/255.0, alpha: alpha)
        case 11:
            // #02A06B
            color = UIColor(red: 2.0/255.0, green: 160.0/255.0, blue: 107.0/255.0, alpha: alpha)
        case 12:
            // #B36133
            color = UIColor(red: 179.0/255.0, green: 97.0/255.0, blue: 51.0/255.0, alpha: alpha)
        case 13:
            // #B151B6
            color = UIColor(red: 177.0/255.0, green: 81.0/255.0, blue: 182.0/255.0, alpha: alpha)
        case 14:
            // #A4A4A4
            color = UIColor(red: 164.0/255.0, green: 164.0/255.0, blue: 164.0/255.0, alpha: alpha)
        case 15:
            // #009E60
            color = UIColor(red: 0.0/255.0, green: 158.0/255.0, blue: 96.0/255.0, alpha: alpha)
        case 16:
            // #B09A65
            color = UIColor(red: 176.0/255.0, green: 154.0/255.0, blue: 101.0/255.0, alpha: alpha)
        case 17:
            // #D61B0D
            color = UIColor(red: 214.0/255.0, green: 27.0/255.0, blue: 13.0/255.0, alpha: alpha)
        default:
            color = .clear
            break
        }
        return color
    }
    
    // MARK: - Create UIImage from UIColor to use as background for UIButton
    
    static func imageFromColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor (color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    // MARK: - Give color to an image
    
    static func imageWithColor(_ image: UIImage, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(at: CGPoint(x: 0, y: 0), blendMode: .normal, alpha: 1)
        context!.setFillColor(color.cgColor)
        context!.setBlendMode(.sourceIn)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
        
    }
    
    // MARK: - Get Keyboard Height
    
    static func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let kbSize : NSValue = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)!
        let kbRect = kbSize.cgRectValue
        let deviceHeight = UIScreen.main.bounds.size.height
        let deviceWidth = UIScreen.main.bounds.size.width
        var kbHeight : CGFloat!
        if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait) {
            kbHeight = deviceHeight - kbRect.origin.y
        } else if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown) {
            kbHeight = kbRect.size.height + kbRect.origin.y
        } else if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft) {
            kbHeight = deviceWidth - kbRect.origin.x
        } else {
            kbHeight = kbRect.size.width + kbRect.origin.x
        }
        return kbHeight
    }
    
    // MARK: - Check if Email is Valid
    
    static func isEmailValid(_ testStr:String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
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
        let numberLabel = createLabel(text: name, textAlignment: .center, textColor: colorPicker(1, alpha: 1), font: UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium))
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
    
}

