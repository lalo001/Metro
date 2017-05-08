//
//  Tools.swift
//  Metro
//
//  Created by Eduardo Valencia on 2/19/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

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
     17. Light Rail Line Blue
     18. Suburban Line Red
     19. Search Bar Gray
     20. Scanner Error Red
     21. Scanner Success Green
     
     - parameters:
        - key: the desired color key
        - alpha: the color alpha
     - returns: A UIColor with the desired RGB
     
     */
    static func colorPicker(_ key: Int, alpha: CGFloat) -> UIColor {
        var colorDictionary: [Int : UIColor] = [
            1 : UIColor.init(white: 1, alpha: alpha), // #FFFFFF
            2 : UIColor(red: 34.0/255.0, green: 30.0/255.0, blue: 34.0/255.0, alpha: alpha), // #221E22
            3 : UIColor(red: 226.0/255.0, green: 20.0/255.0, blue: 139.0/255.0, alpha: alpha), // #E2148B
            4 : UIColor(red: 242.0/255.0, green: 94.0/255.0, blue: 154.0/255.0, alpha: alpha), // #F25E9A
            5 : UIColor(red: 0.0/255.0, green: 139.0/255.0, blue: 222.0/255.0, alpha: alpha), // #008BDE
            6 : UIColor(red: 135.0/255.0, green: 146.0/255.0, blue: 48.0/255.0, alpha: alpha), // #879230
            7 : UIColor(red: 92.0/255.0, green: 192.0/255.0, blue: 173.0/255.0, alpha: alpha), // #5CC0AD
            8 : UIColor(red: 245.0/255.0, green: 200.0/255.0, blue: 0.0/255.0, alpha: alpha), // #F5C800
            9 : UIColor(red: 247.0/255.0, green: 62.0/255.0, blue: 46.0/255.0, alpha: alpha), // #F73E2E
            10 : UIColor(red: 247.0/255.0, green: 126.0/255.0, blue: 19.0/255.0, alpha: alpha), // #F77E13
            11 : UIColor(red: 2.0/255.0, green: 160.0/255.0, blue: 107.0/255.0, alpha: alpha), // #02A06B
            12 : UIColor(red: 179.0/255.0, green: 97.0/255.0, blue: 51.0/255.0, alpha: alpha), // #B36133
            13 : UIColor(red: 177.0/255.0, green: 81.0/255.0, blue: 182.0/255.0, alpha: alpha), // #B151B6
            14 : UIColor(red: 164.0/255.0, green: 164.0/255.0, blue: 164.0/255.0, alpha: alpha), // #A4A4A4
            15 : UIColor(red: 0.0/255.0, green: 158.0/255.0, blue: 96.0/255.0, alpha: alpha), // #009E60
            16 : UIColor(red: 176.0/255.0, green: 154.0/255.0, blue: 101.0/255.0, alpha: alpha), // #B09A65
            17: UIColor(red: 128.0/255.0, green: 155.0/255.0, blue: 245.0/255.0, alpha: alpha), // #809BF5
            18 : UIColor(red: 214.0/255.0, green: 27.0/255.0, blue: 13.0/255.0, alpha: alpha), // #D61B0D
            19 : UIColor(red: 53.0/255.0, green: 50.0/255.0, blue: 54.0/255.0, alpha: alpha), // #363236
            20 : UIColor(red: 231/255.0, green: 29/255.0, blue: 54/255.0, alpha: alpha), // #E71D36
            21 : UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: alpha) // #4CD964
        ]
        if let color = colorDictionary[key] {
            return color
        }
        return .clear
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
    
    // MARK: - Check if Email is Valid
    
    static func isEmailValid(_ testStr: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // MARK: - UIStatusBar Functions
    
    static func getStatusBarHeight() -> CGFloat {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let height = min(statusBarFrame.width, statusBarFrame.height)
        return height <= 20 ? height : 20
    }
    
    static func getStatusBarFrame() -> CGRect {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let height = min(statusBarFrame.width, statusBarFrame.height)
        let width = max(statusBarFrame.width, statusBarFrame.height)
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        return frame
    }
    
    // MARK: - Location Error Functions
    
    static func showLocationServicesOffAlert(_ vc: AnyObject) {
        let alert = UIAlertController(title: NSLocalizedString("locationServicesOff", comment: "").capitalized(with: Locale(identifier: NSLocalizedString("locale", comment: ""))), message: NSLocalizedString("locationServicesOffDescription", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default, handler: { (action: UIAlertAction) -> Void in
            guard let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showLocationNotAvailableAlert(_ vc: AnyObject) {
        let alert = UIAlertController(title: NSLocalizedString("currentLocationNotAvailable", comment: "").capitalized(with: Locale(identifier: NSLocalizedString("locale", comment: ""))), message: NSLocalizedString("currentLocationNotAvailableDescription", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showNoRouteFoundAlert(_ vc: AnyObject) {
        let alert = UIAlertController(title: NSLocalizedString("noRouteFound", comment: ""), message: NSLocalizedString("noRouteFoundDescription", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}
