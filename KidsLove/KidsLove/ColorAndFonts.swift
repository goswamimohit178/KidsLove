//
//  ColorAndFonts.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 06/02/23.
//

import Foundation
import UIKit

extension UIColor {
    static func wrongAnswerColor() -> UIColor {
            return UIColor(red: 1.0, green: 0.25, blue: 0.0, alpha: 1.0)
        }

        static func selectBtnColor() -> UIColor {
            return UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0)
        }
        
    static func rightAnswerColor() -> UIColor {
        return .systemGreen
    }
    
    static func homeButtonColor() -> UIColor {
        return .systemGreen
    }
    static func buttonBackgroundColor() -> UIColor {
        return .lightGray
    }
    
}

extension UIFont {
    static func myAppTitle() -> UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    static func myAppBodyFonts() -> UIFont {
        return UIFont.systemFont(ofSize: 40)
    }
}
