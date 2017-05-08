//
//  Constant.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/25/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

struct Constant {
    
    struct Animations {
        static let loadingAnimationDuration: TimeInterval = 0.5
    }
    
    struct Buttons {
        static let cancelButtonTopConstant: CGFloat = 40
        static let mainButtonTitleColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let mainButtonCornerRadius: CGFloat = Constant.Buttons.mainButtonHeight/2
        static let mainButtonBottomSeparation: CGFloat = 30
        static let mainButtonFont: UIFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
        static let mainButtonHeight: CGFloat = 50
        static let mainButtonSideSeparation: CGFloat = 40
    }
    
    struct CoreData {
        static let maximumNumberOfRecents: Int = 5
    }
    
    struct HandleIcon {
        static let backgroundColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let cornerRadius: CGFloat = Constant.HandleIcon.height/2
        static let height: CGFloat = 5
        static let topSeparation: CGFloat = 10
        static let width: CGFloat = 40
    }
    
    struct InvertIcon {
        static let imageSize: CGFloat = 40
    }
    
    struct Labels {
        static let appWelcomeLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let appWelcomeLabelFont: UIFont = UIFont.systemFont(ofSize: 64, weight: UIFontWeightHeavy)
        static let inputLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let inputLabelFont: UIFont = UIFont.systemFont(ofSize: 28, weight: UIFontWeightBold)
        static let lineNameColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let lineNameFont: UIFont = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        static let navigationBarTitleColor: UIColor = Tools.colorPicker(1, alpha: 1)
        static let subtitleLabelColor: UIColor = Tools.colorPicker(1, alpha: 0.5)
        static let titleLabelColor: UIColor = Tools.colorPicker(1, alpha: 1)
    }
    
    struct RouteIcon {
        static let borderWidth: CGFloat = 3
        static let circleColor: UIColor = Tools.colorPicker(3, alpha: 1)
        static let circleDiameter: CGFloat = 15
        static let leftSeparation: CGFloat = 15
    }
    
    struct Scanner {
        static let statusLabelBottomSeparation: CGFloat = 120
    }
    
    struct StationPicker {
        static let bottomLineSeparation: CGFloat = Constant.StationPicker.lineSeparation + 5
        static let leftMarginSeparation: CGFloat = 45
        static let lineSeparation: CGFloat = 6
        static let lineWidthOffset: CGFloat = 2
        static let nonTextAlpha: CGFloat = 1
        static let pickerTitleColor: UIColor = Tools.colorPicker(3, alpha: 1)
        static let pickerTitleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        static let pickerTextFont: UIFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightHeavy)
        static let rightMarginSeparation: CGFloat = 60
        static let topMarginSeparation: CGFloat = 30
    }
    
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
    
    struct VisualEffects {
        static let mapBlurContentViewBackgroundColor: UIColor = Tools.colorPicker(2, alpha: 0.7)
    }
    
}
