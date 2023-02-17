//
//  ColorAndFonts.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 06/02/23.
//

import Foundation
import UIKit

extension UIColor {
    static var defaultThemeColor = ThemeManager.themeColor
    
    static func wrongAnswerColor() -> UIColor {
        return UIColor(red: 1.0, green: 0.25, blue: 0.0, alpha: 1.0)
    }
    
    static func selectBtnColor() -> UIColor {
        return homeButtonColor()
    }
    
    static func rightAnswerColor() -> UIColor {
        return UIColor(red: 0.739, green: 1.000, blue: 0.290, alpha: 1.0)
    }
    
    static func continueBtnColor() -> UIColor {
        return UIColor(red: 0.739, green: 1.000, blue: 0.290, alpha: 1.0)
    }
    
    static func homeButtonColor() -> UIColor {
//        return UIColor(red: 0.922, green: 0.275, blue: 0.400, alpha: 1.0)
        return defaultThemeColor
        
    }
    static func disableButtonColor() -> UIColor {
        return .systemGray3
    }
    static func buttonBackgroundColor() -> UIColor {
        return .systemGray6
    }
    
    static func bodyFontColor() -> UIColor {
        return UIColor(named: "textColor")!
    }
    
    static func btnShadowColor() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
    }
    
    static func progressBarColor() -> UIColor {
        return homeButtonColor()
    }
    
    static func operatorProgressBar() -> UIColor {
        return UIColor(red: 0.9993169904, green: 0.6469120383, blue: 0, alpha: 1)
    }
    
    static func defaultTextColor() -> UIColor {
        return UIColor(named: "textColor")!
    }
    
}

extension UIFont {
    static func headingFonts() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }
    
    static func myAppBodyFonts() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .title1)
    }
    static func operatorViewCellFont() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }
    
}



